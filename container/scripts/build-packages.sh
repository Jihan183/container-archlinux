#!/bin/bash -e

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

cd "${XFCE_WORK_DIR}"
results_file="${1}"

runuser -- aur build \
    --ignorearch \
    --arg-file "${CONTAINER_BASE}/pkglist.txt" \
    ${1:+--results=$1} \
    --pkgver --database=custom \
    --margs --syncdeps --noconfirm
