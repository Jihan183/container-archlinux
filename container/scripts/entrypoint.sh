#!/bin/bash

# shellcheck source=container/scripts/common.sh
source "${XFCE_BASE}/scripts/common.sh"

function dbg() {
    echo "${@}" >&2
}

function bind_to_workdir() {
    printf 'Getting things ready for local development...'
    # shellcheck disable=SC2016
    find "${XFCE_GIT_DIR}" -type f -name 'PKGBUILD' \
        -exec printf '\nupdating: {}...' \; \
        -execdir sh -c '
        pkgname="${PWD##*/}"
        dest="${XFCE_WORKDIR}/$pkgname"
        if [ ! -d $dest ]; then
            printf "skipped"
        else
            sed -Ei "s|\\\$url\.git|file://${dest}|" "$1"
            sed -Ei "s|https?://.+\.git|file://${dest}|" "./$pkgname/config"
            printf "done"
        fi
    ' _ '{}' \;
    echo
}

if ((${#@})); then
    dbg 'running user supplied program...'
    exec "${SHELL:-/bin/sh}" -c "${@}"
fi

# if the user has mounted their workdir in the container, then
# make sure we are pulling it from the working copy
if [ -d "${XFCE_BASE}/workdir" ]; then
    export XFCE_WORKDIR="${XFCE_BASE}/workdir/"
    bind_to_workdir 2>&1 | less +F -E -R -Q --tilde
fi

# start xfce?
if [ -n "$DISPLAY" ]; then
    echo "Turning off screensaver"
    xset s off

    if [[ -t 0 && -t 1 ]]; then
        # --interactive --tty
        dbg 'starting interactive session...'
        startxfce4 2>~/.xsession-errors >/dev/null & disown
    else
        dbg 'starting xfce4 session...'
        exec startxfce4 2>~/.xsession-errors >/dev/null
    fi
fi

exec "${SHELL:-/bin/sh}"
