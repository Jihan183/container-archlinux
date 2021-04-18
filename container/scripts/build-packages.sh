#!/bin/bash -e

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

cd "${XFCE_WORK_DIR}"

if [ -n "${ACTIONS_CI}" ]; then
    log="/tmp/build-log"
fi

echo -en "${log:+\nLog output will be written to: $log\n}"

result_pipe="/tmp/result_pipe"
runuser -- mkfifo --mode=600 "$result_pipe"
{
    runuser -- aur build \
        --ignorearch \
        --arg-file "${CONTAINER_BASE}/pkglist.txt" \
        --results "$result_pipe" --remove \
        --pkgver --database=custom \
        --margs --syncdeps --noconfirm >"${log:-/dev/fd/1}"
} 2>&1 &

stdbuf -oL tail --pid="$!" --follow --silent --bytes=+1 /proc/$!/fd/1 - <"$result_pipe"
