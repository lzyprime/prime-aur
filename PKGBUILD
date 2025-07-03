
pkgname='prime-icons'
pkgver=2025.7.1
pkgrel=1
pkgdesc="icons and cursor theme"
arch=('any')
#url='https://lzyprime.github.io'
license=('GPL-3.0-or-later')
groups=(prime-theme)
options=('!strip' '!debug')  # 关键修复：禁用自动修改

package() {
	dist="${pkgdir}/usr/share/icons"
	mkdir -p "$dist"
	cp -av * "$dist/"
}
