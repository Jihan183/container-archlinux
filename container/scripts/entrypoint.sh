# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

function dbg() {
    echo "${@}" >&2
}

function bind_to_workdir() {
    # if the user has mounted their workdir in the container, then
    # make sure we are pulling it from the working copy
    if [ -d "${CONTAINER_BASE}/workdir" ]; then
        printf 'Getting things ready for local development...'
        # shellcheck disable=SC2016
        find "${XFCE_WORK_DIR}" -type f -name 'PKGBUILD' \
            -exec printf '\nupdating: {}...' \; \
            -execdir sh -c '
            dest="${CONTAINER_BASE}/workdir/${PWD##*/}"
            if [ ! -d $dest ]; then
                printf "skipped"
            else
                sed -i "s|\$url\.git|file://${dest}|" "$1"
                printf "done"
            fi
        ' _ '{}' \;
        echo
    fi
}

# # setup machine-id. Do we need this?
sudo systemd-machine-id-setup --print

if ((${#@})); then
    dbg 'running user supplied program...'
    exec "${SHELL:-/bin/sh}" -c "${@}"
fi

# check if dev workdir is available
bind_to_workdir 2>&1 | less -E -R -Q --tilde

if [[ -t 0 && -t 1 ]]; then
    dbg 'starting interactive session...'
    dbg 'note: starting xfce in the background will cause it to become suspended'
    dbg 'recommend that you run: "startx" in a new terminal'
    exec "${SHELL:-/bin/sh}"
# start xfce?
elif [ -n "$DISPLAY" ]; then
    dbg 'starting xfce4 session...'
    exec startx
fi
