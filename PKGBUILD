# Maintainer: Chigozirim Chukwu <noblechuk5[at]web[dot]de>

pkgname='xfce-test-container-archlinux'
pkgver=1.0
pkgrel=1
pkgdesc=''
arch=(any)
url='https://github.com/xfce-test/container-archlinux'
license=(GPLv3)
groups=(xfce-test)
depends=(jq python docker)
makedepends=()
optdepends=()
options=()
source=("$pkgname::git+$url.git#branch=main")
md5sums=('SKIP')

pkgver() {
  cd "$pkgname"
  git describe --long --tags | sed -E "s:^$pkgname.::;s/^v//;s/^xfce-//;s/([^-]*-g)/r\1/;s/-/./g"
}

build() {
  python setup.py build
}

package() {
  python setup.py install --root="$pkgdir" --optimize=1 --skip-build
}
