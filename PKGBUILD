# Maintainer: Chigozirim Chukwu <noblechuk5[at]web[dot]de>

pkgname='xfce-test-archlinux'
pkgver=1.0
pkgrel=1
pkgdesc=''
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
  git describe | sed -E "s:^$pkgbase.::;s/^v//;s/^xfce-//;s/([^-]*-g)/r\1/;s/-/./g"
}

build() {
  cd "$pkgname"
}

package() {
  cd "$pkgname"
}
