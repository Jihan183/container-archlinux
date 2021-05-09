#!/bin/bash -ex
set -o pipefail

# shellcheck source=container/scripts/common.sh
source "${XFCE_BASE}/scripts/common.sh"

function build-cmd() {
    runuser -- env \
        LC_ALL=C ${CI:+LOGDEST="$LOGDEST"} \
        MAIN_BRANCH="${MAIN_BRANCH}" DOWNLOAD_DATE="${DOWNLOAD_DATE}" \
        aur build \
            --ignore-arch --force \
            ${CI:+--arg-file "${XFCE_BASE}/pkglist.txt"} \
            --remove --pkgver --database=custom \
            --margs --syncdeps --noconfirm --clean ${CI:+--log}
}

function build-ci() {
    LOGDEST="${LOGDEST:-/tmp/makelogs}"

    if [ -n "${ACTIONS_CI}" ]; then
        echo -e "\n::set-output name=build_logs::$LOGDEST"
    else
        echo -e "\nLog output will be written to: $LOGDEST"
    fi

    cd "${XFCE_GIT_DIR}"

    build-cmd | stdbuf -oL sed --silent -E '
        /Making package:/{
            x
            /^$/{g;p}
            x
        }
        /Finished making:/{
            G
            /^.+: (\S+).+\n.+: \1.+$/M{P;z;h}
        }'

    # install the group
    runuser -- "${PACMAN}" -S 'xfce-test' --noconfirm --needed

    # install other applications needed for full functionality
    runuser -- "${PACMAN}" -S man xorg-xrandr xorg-xhost --noconfirm --needed

}

if [[ -n $ACTIONS_CI || -n $TRAVIS_CI ]]; then
    CI=true
fi


if [ -z "${CI}" ]; then
    build-cmd
else
    build-ci
fi
