#!/bin/bash -e

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

cd "${XFCE_WORK_DIR}"

echo -e "\n\Log output will be written to /tmp/build-packages\n\n"
{
    exec {res}>&1
    runuser -- aur build \
        --ignorearch \
        --arg-file "${CONTAINER_BASE}/pkglist.txt" \
        --results /proc/$$/fd/${res} \
        --pkgver --database=custom \
        --margs --syncdeps --noconfirm  >/tmp/build-packages
    exec >&${res}-
} 2>&1
