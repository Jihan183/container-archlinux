#!/bin/bash -e

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

cd "${XFCE_WORK_DIR}"

export LOGDEST="${LOGDEST:-/tmp/makelogs}"

echo -en "\nLog output will be written to: $LOGDEST\n"

runuser -- env LC_ALL=C aur build \
    --ignorearch \
    --arg-file "${CONTAINER_BASE}/pkglist.txt" \
    --remove --pkgver --database=custom \
    --margs --syncdeps --noconfirm --log | stdbuf -oL sed --silent -E '
        /Making package:/{
            x
            /^$/{g;p}
            x
        }
        /Finished making:/{
            G
            /^.+: (\S+).+\n.+: \1.+$/M{P;z;h}
        }'

# shellcheck disable=SC2016
runuser -- aur repo -lq | xargs -I {} bash -c '
    cat "${LOGDEST}"/{}*{prepare,build,package}.log | gzip > "${LOGDEST}"/{}-log.gz'
