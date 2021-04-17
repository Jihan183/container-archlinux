#!/bin/bash -e

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

cd "${XFCE_WORK_DIR}"

if [ -n "${ACTIONS_CI}" ]; then
    log="$(mktemp /tmp/build-log.XXXXXXXXXXXX)" && {
        echo "::set-output name=build_log::$log"
    }
fi

echo -en "${log:+\n\nLog output will be written to $log\n\n}"
{
    # shellcheck disable=SC1004,SC2016
    exec {res}>&1
    runuser -- aur build \
        --ignorearch \
        --arg-file "${CONTAINER_BASE}/pkglist.txt" \
        --results /proc/self/fd/${res} \
        --pkgver --database=custom \
        --margs --syncdeps --noconfirm | dd status=none of="${log:-/dev/fd/1}"
    exec {res}>&-
} 2>&1
