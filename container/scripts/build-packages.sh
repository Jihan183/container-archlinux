#!/bin/bash -e

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

cd "${XFCE_WORK_DIR}"
tmp="$(runuser -- mktemp -d /tmp/tmp.XXXXXXXX)"

if [ -n "${ACTIONS_CI}" ]; then
    log="$tmp/build-log"
    echo "::set-output name=build_log::$log"
fi

echo -en "${log:+\n\nLog output will be written to $log\n\n}"
{
    result_pipe="$tmp/result_pipe"
    runuser -- mkfifo --mode=600 "$result_pipe"
    cat "$result_pipe" &

    runuser -- aur build \
        --ignorearch \
        --arg-file "${CONTAINER_BASE}/pkglist.txt" \
        --results "$result_pipe" \
        --pkgver --database=custom \
        --margs --syncdeps --noconfirm > "${log:-/dev/fd/1}"
} 2>&1
