# Maintainer: Chigozirim Chukwu <noblechuk5[at]web[dot]de>

pkgname='xfce-test-archlinux'
pkgver=1.0
pkgrel=1
pkgdesc='ArchLinux environment for hacking on xfce'
arch=(any)
url='https://github.com/xfce-test/container-archlinux'
license=(GPLv3)
groups=(xfce-test)
depends=(jq docker x11docker)
makedepends=()
optdepends=(
  'kittypack: for downloading package dependencies from arch main repos'
  'podman-docker: prefer podman to docker'
)
options=()
source=("$pkgname::git+$url.git#branch=main")
md5sums=('SKIP')

pkgver() {
  cd "$pkgname"
  git describe | sed -E "s:^$pkgname.::;s/^v//;s/^xfce-//;s/([^-]*-g)/r\1/;s/-/./g"
}

package() {
  cd "$pkgname"
  cp --archive --parents app/scripts/*.{sh,awk} "$pkgdir/usr/share/$pkgname"/
  cp --archive --parents xfce/ "$pkgdir/usr/share/$pkgname"/
  cp --archive --parents container/ "$pkgdir/usr/share/$pkgname"/
  cp --archive Dockerfile "$pkgdir/usr/share/$pkgname"/
  cp --archive .env "$pkgdir/etc/$pkgname"/
  ln --force --symbolic "../share/${pkgname}/app/scripts/build.sh" "$pkgdir/usr/bin/${pkgname}-build"
  ln --force --symbolic "../share/${pkgname}/app/scripts/start.sh" "$pkgdir/usr/bin/${pkgname}-start"
}
