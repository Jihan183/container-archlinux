#!/bin/bash -ex
set -o pipefail

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

cd "${XFCE_WORK_DIR}"

LOGDEST="${LOGDEST:-/tmp/makelogs}"

if [ -n "${ACTIONS_CI}" ]; then
    echo -en "\n::set-output name=build_logs::$LOGDEST\n"
else
    echo -en "\nLog output will be written to: $LOGDEST\n"
fi

runuser -- env LC_ALL=C LOGDEST="$LOGDEST" aur build \
    --ignore-arch \
    --arg-file "${CONTAINER_BASE}/pkglist.txt" \
    --remove --pkgver --database=custom \
    --margs --syncdeps --noconfirm --clean --log | stdbuf -oL sed --silent -E '
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
runuser -- "${PACMAN}" -Syu man xorg-xrandr xorg-xhost --noconfirm --needed
