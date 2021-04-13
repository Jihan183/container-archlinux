#!/bin/bash -ex

source /container/scripts/common.sh

runuser -- git clone --depth=1 "${PACMAN_HELPER_URL}" /tmp/"${PACMAN_HELPER}"
cd /tmp/"${PACMAN_HELPER}"
runuser -- makepkg --install --force --syncdeps --rmdeps --noconfirm --needed

runuser -- "${PACMAN}" -S aurutils --noconfirm --needed
runuser -- "${PACMAN}" -S intltool glib2 nano --noconfirm --needed
# gconf gsettings-desktop-schemas
