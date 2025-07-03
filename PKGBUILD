
pkgname='prime-grub-theme'
pkgver=2025.7.1
pkgrel=1
pkgdesc="grub themes"
arch=('any')
#url='https://lzyprime.github.io'
license=('GPL-3.0-or-later')
groups=(prime-theme)
options=('!strip' '!debug')  # 关键修复：禁用自动修改

package() {
	dist="${pkgdir}/usr/share/grub/themes"
	mkdir -p "$dist"
	cp -a * "$dist/"
	ls "$dist"
}

install=
