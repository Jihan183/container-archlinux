#!/bin/bash -e

# shellcheck source=container/scripts/common.sh
source "${XFCE_BASE}/scripts/common.sh"

# TODO: Restore yay-bin after it becomes compatible with pacman 6
# https://aur.archlinux.org/packages/yay/#pinned-808720

# hack to make sure yay-bin is used if the user picks yay
# PACMAN_HELPER_URL="${PACMAN_HELPER_URL/%yay.git/yay-bin.git}"

runuser -- git clone --depth=1 "${PACMAN_HELPER_URL}" /tmp/"${PACMAN_HELPER}"
cd /tmp/"${PACMAN_HELPER}"
runuser -- makepkg --install --force --syncdeps --rmdeps --noconfirm --needed

runuser -- "${PACMAN}" -S aurutils --noconfirm --needed
# gconf gsettings-desktop-schemas
