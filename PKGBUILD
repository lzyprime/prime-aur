pkgname='wechat'
pkgver='4.0.1.11'
pkgrel=1
pkgdesc="WeChat for Linux"
arch=('x86_64')
url="https://weixin.qq.com"

options=('!strip' '!debug')  # 关键修复：禁用自动修改

source=(
    'wechat.AppImage::https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage'
)
noextract=(wechat.AppImage)
sha256sums=('80159c350d68d4065f36c9aed558b52a296abf761b47ec2a3a87785d801e54aa')

package() {
    install -Dm755 "wechat.AppImage" "${pkgdir}/usr/bin/wechat"
    mkdir -p "${pkgdir}/usr/share/"
    cp -r applications icons "${pkgdir}/usr/share/"
}
