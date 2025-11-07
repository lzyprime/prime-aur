#!/bin/bash
set -e
[ "$#" != 2 ] && {
	echo "$0 <pkgname.deb> <dir>"
	exit 0
}

[ ! -f "$1" ] && {
	echo "deb file: $1 not found."
	exit 1
}

[ -d "$2" ] && {
	echo "dir: $2 is exists"
	exit 1
}
pkg=$1
ws=$2

pkgname="$(dpkg-deb -f "$pkg" Package)"
_pkgver="$(dpkg-deb -f "$pkg" Version)"
pkgver="${_pkgver//-/_}"
pkgdesc="$(dpkg-deb -f "$pkg" Description|| echo "$pkgname")"
depends="$(dpkg-deb -f "$pkg" Depends)"
optdepends="$(dpkg-deb -f "$pkg" Recommends)"
url="$(dpkg-deb -f "$pkg" Homepage)"
controlpath="var/lib/dpkg/info/$pkgname/${pkgver}"

mkdir -p "$ws/src/$controlpath"
dpkg-deb -X "$pkg" "$ws/src"
dpkg-deb -e "$pkg" "$ws/src/$controlpath"

cat > "$ws/PKGBUILD" << EEE
pkgname=$pkgname
pkgver="${pkgver}"
pkgdesc="$pkgdesc"
pkgrel=1
arch=(any)
url="$url"

options=('!strip' '!debug')  # 关键修复：禁用自动修改

>>>depends=(
$(echo "$depends"| tr ',' '\n' | awk '{print "# "$0}')
)
optdepends=(
$(echo "$optdepends"| tr ',' '\n' | awk '{print "# "$0}')
)
package() {
	cp -rv \${srcdir}/* "\${pkgdir}"
}
install=deb.install

EEE

declare -A scripts=()
for f in preinst postinst prerm postrm; do
	controlf="$ws/src/$controlpath/$f"
	if [ -f "$controlf" ]; then
		scripts[$f]="$(base64 "$controlf")"
	else
		scripts["$f"]="$(base64 <<< true)"
	fi
done

cat > "$ws/deb.install" << EEE
#!/bin/bash
set -e

echo "debpkg: $pkgname = $pkgver"

$(for f in "${!scripts[@]}"; do echo "$f='${scripts[$f]}'"; done)

pre_install() {
	bash -c \$(base64 -d <<< "\$postinst") -o install	
}

post_install() {
	bash -c \$(base64 -d <<< "\$postinst") -o configure
}

## arg 1:  the new package version
## arg 2:  the old package version
oldpostrm="\$(base64 <<< "true")"
pre_upgrade() {
	
	controlf="/var/lib/dpkg/info/$pkgname/\${2}/prerm"
	if [ -f "\$controlf" ]; then
		bash "\$controlf" upgrade
	fi
	bash -c \$(base64 -d <<< "\$preinst") -o upgrade
	controlf="/var/lib/dpkg/info/$pkgname/\${2}/postrm"
	if [ -f "\$controlf" ]; then
		oldpostrm=\$(base64 "\$controlf")
	fi
}

## arg 1:  the new package version
## arg 2:  the old package version
post_upgrade() {
	bash -c "\$(base64 -d <<< "\$oldpostrm")" -o upgrade
	bash -c \$(base64 -d <<< "\$postinst") -o upgrade
}

## arg 1:  the old package version
pre_remove() {
	bash -c \$(base64 -d <<< "\$prerm") -o remove
}

## arg 1:  the old package version
post_remove() {
	bash -c \$(base64 -d <<< "\$postrm") -o purge
}
EEE


