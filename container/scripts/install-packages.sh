#!/bin/bash -e

source /container/scripts/common.sh

mapfile -t all_pkgs < /container/pkglist.txt
runuser -- "${PACMAN}" -Syu "${all_pkgs[@]}" --needed --noconfirm
