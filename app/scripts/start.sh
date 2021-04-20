#!/bin/bash

if ! docker images --filter reference='xfce-test/xfce-test-archlinux' --filter dangling=false; then
    echo "No images found in the image storage"
    exit 1
fi

if [[ -z "$LOCAL_XFCE" && -d "$HOME/Dev/xfce-workdir" ]]; then
    LOCAL_XFCE=$HOME/Dev/xfce-workdir
fi

x11docker --desktop \
    --size 1200x800 \
    --display 2 \
    --cap-default \
    --network=private \
    --init=none \
    --dbus \
    --hostdbus \
    --xephyr \
    --user=RETAIN \
    --name xfce-test \
    --pull=ask \
    --showenv \
    --showid \
    --showpid1 \
    --podman \
    --keepcache \
    -- \
    --systemd=true \
    ${LOCAL_XFCE:+--volume "$LOCAL_XFCE:/container/xfce/workdir:rw"} \
    -- \
    xfce-test/xfce-test-archlinux:latest startxfce4
