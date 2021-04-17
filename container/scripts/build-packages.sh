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
    # shellcheck disable=SC2016
    exec 4>&1
    ls -l /proc/self/fd
    runuser -- ls -l /proc/self/fd

    runuser -- aur build \
        --ignorearch \
        --arg-file "${CONTAINER_BASE}/pkglist.txt" \
        --results /dev/fd/4 \
        --pkgver --database=custom \
        --margs --syncdeps --noconfirm | dd status=none of="${log:-/dev/fd/1}"
    exec 4>&-
} 2>&1
