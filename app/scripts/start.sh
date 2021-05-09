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
    --xephyr
    --user=RETAIN
    --name=xfce-test
    --pull=ask
    --showenv
    --showid
    --showinfofile
    --showpid1
     # disables power management and screensaver
    --xopt '-dpms -s 0'
    # --keepcache
)

if type podman >&2; then
    x11docker_args+=(--podman)
fi

# docker/podman args
docker_podman_arg=(
    --security-opt seccomp=unconfined
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
