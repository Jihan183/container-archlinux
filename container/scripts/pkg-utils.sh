#!/bin/bash -ex

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

# hack to make sure yay-bin is used if the user picks yay
PACMAN_HELPER_URL="${PACMAN_HELPER_URL/%yay.git/yay-bin.git}"

runuser -- git clone --depth=1 "${PACMAN_HELPER_URL}" /tmp/"${PACMAN_HELPER}"
cd /tmp/"${PACMAN_HELPER}"
runuser -- makepkg --install --force --syncdeps --rmdeps --noconfirm --needed

runuser -- "${PACMAN}" -S aurutils nano man --noconfirm --needed
# gconf gsettings-desktop-schemas
