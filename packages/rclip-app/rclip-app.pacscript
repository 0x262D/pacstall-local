name="rclip-app"
pkgname="rclip"
gives="rclip"
version="1.2.3"
description="rclip is a command-line photo search tool based on the awesome OpenAI's CLIP neural network"
maintainer="0x262D <pacstall@copypaste.anonaddy.me>"
url="https://github.com/yurijmikhalevich/${gives}/releases/download/v${version}/rclip-v${version}-x86_64.AppImage"
hash="e7b23c7e03178fdc99ab72fa53153436a1250a8b910083413f2f49dd7fc81425"
breaks="${pkgname} ${pkgname}-deb ${pkgname}-bin ${pkgname}-git"
pkgdir="${STOWDIR}/${name}"
repology=("project: ${pkgname}")

prepare() {
  true
}

build() {
  true
}

install() {
  # Install appimage
  sudo install -Dm755 "rclip-v${version}-x86_64.AppImage" "${pkgdir}/usr/bin/${pkgname}"
}
# vim:set ft=sh ts=2 sw=2 et:
