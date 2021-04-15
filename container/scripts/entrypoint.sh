#!/bin/bash

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

# if the user has mounted their workdir in the container, then
# make sure we are pulling it from the working copy
if [ -d "${CONTAINER_BASE}/workdir" ]; then
    printf 'Getting things ready for local development...'
    # shellcheck disable=SC2016
    find "${XFCE_WORK_DIR}" -type f -name 'PKGBUILD' \
        -exec echo -en '\nupdating: {}..' \; \
        -execdir sh -c '
            dest="${CONTAINER_BASE}/workdir/${PWD##*/}"
            if [ ! -d $dest ]; then
                echo "skipped"
            else
                sed -i "s|\$url\.git|file://${dest}|" "$1"
                echo "done"
            fi
        ' _ '{}' \;
    echo 'done'
fi

# install xfce
runuser -- "${PACMAN}" -Syu "xfce-test" --needed --noconfirm

# start the user's login shell
exec "${SHELL:-/bin/sh}"
