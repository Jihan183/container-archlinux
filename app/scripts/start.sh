#!/bin/bash

# shellcheck source=app/scripts/vars.sh
source "$(dirname "$(readlink --canonicalize "${BASH_SOURCE[0]}")")/vars.sh"

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
    --xopt '-dpms' # disables dpms on xserver
    # --keepcache
)

if type podman >&2; then
    x11docker_args+=(--podman)
fi

# docker/podman args
docker_podman_arg=(
    --security-opt seccomp=unconfined
    # --cap-add sys_ptrace # this is useful for debug purposes
    ${LOCAL_XFCE:+--volume "$LOCAL_XFCE:/container/xfce/workdir:ro"}
)

# image/container args
image_cont_args=(
    "${XFCE_TEST_IMAGE:-xfce-test/xfce-test-archlinux:devel}"
)

x11docker "${x11docker_args[@]}" \
        -- \
        "${docker_podman_arg[@]}" \
        -- \
        "${image_cont_args[@]}"
