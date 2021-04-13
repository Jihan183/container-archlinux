#!/bin/bash -ex

source /container/scripts/common.sh

LOCAL_AUR_PKGS=/var/local/custompkgs

sed "s|%{LOCAL_AUR_PKGS}%|${LOCAL_AUR_PKGS}|g" etc/pacman.conf.in \
    | tee /etc/pacman.conf

install -dm755 "${LOCAL_AUR_PKGS}" --group "$USERNAME"
chmod g+ws "${LOCAL_AUR_PKGS}"
runuser -- repo-add "${LOCAL_AUR_PKGS}/custom.db.tar.gz"

pacman -Syu --noconfirm
