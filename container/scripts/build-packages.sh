#!/bin/bash -e

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

cd "${XFCE_WORK_DIR}"
tmp="$(runuser -- mktemp -d /tmp/tmp.XXXXXXXX)"

if [ -n "${ACTIONS_CI}" ]; then
    log="$tmp/build-log"
    echo "::set-output name=build_log::$log"
fi

echo -en "${log:+\nLog output will be written to: $log\n}"

result_pipe="$tmp/result_pipe"
runuser -- mkfifo --mode=600 "$result_pipe"
exec {aur}< <(runuser -- aur build \
    --ignorearch \
    --arg-file "${CONTAINER_BASE}/pkglist.txt" \
    --results "$result_pipe" \
    --pkgver --database=custom \
    --margs --syncdeps --noconfirm 2>&1 >"${log:-/dev/fd/1}" &)

stdbuf -oL tail --silent --bytes=+1 "$result_pipe" - <&${aur}
exec {aur}<&-
