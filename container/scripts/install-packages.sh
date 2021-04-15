#!/bin/bash -e

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

mapfile -t all_pkgs < "${CONTAINER_BASE}/pkglist.txt"
runuser -- "${PACMAN}" -Syu "${all_pkgs[@]}" --needed --noconfirm
