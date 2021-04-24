#!/bin/bash

# shellcheck source=app/scripts/vars.sh
source "$(dirname "$(readlink --canonicalize "${BASH_SOURCE[0]}")")/vars.sh"

if [[ -z "$LOCAL_XFCE" && -d "$HOME/Dev/xfce-workdir" ]]; then
    LOCAL_XFCE=$HOME/Dev/xfce-workdir
fi

# x11docker params
x11docker_args=(
    # --debug
    --interactive
    --desktop
    --dbus
    --clipboard
    --size=1280x720
    --cap-default
    --network=private
    --init=dockerinit
    --xephyr
    --user=RETAIN
    --name=xfce-test
    --pull=ask
    --showenv
    --showid
    --showinfofile
    --showpid1
    # --keepcache
)

if type podman >&2; then
    x11docker_args+=(--podman)
fi

# docker/podman args
docker_podman_arg=(
    --cap-add=sys_ptrace
    # --security-opt seccomp=unconfined
    # --security-opt seccomp="$ROOT_DIR/app/config/seccomp-default.json"
    # --security-opt=proc-opts='gid=100,hidepid=0'
    ${LOCAL_XFCE:+--volume "$LOCAL_XFCE:/container/xfce/workdir:ro"}
)

# image/container args
image_cont_args=(
    xfce-test/xfce-test-archlinux:devel
    # schuellerf/xfce-test:latest
)

x11docker "${x11docker_args[@]}" \
        -- \
        "${docker_podman_arg[@]}" \
        -- \
        "${image_cont_args[@]}"
