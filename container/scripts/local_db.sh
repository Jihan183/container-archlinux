#!/bin/bash

source /container/scripts/common.sh

LOCAL_AUR_PKGS=/var/opt/custompkgs

tee --append /etc/pacman.conf <<EOF
[custom]
SigLevel = Optional TrustAll
Server = file://${LOCAL_AUR_PKGS}
EOF

install -dm755 "${LOCAL_AUR_PKGS}" --owner "$DEFAULT_USER"
runuser -- repo-add "${LOCAL_AUR_PKGS}/custom.db.tar.gz"
runuser -- "${PACMAN}" -Syu --noconfirm
