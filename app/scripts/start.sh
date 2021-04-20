#!/bin/bash

if [[ -z "$LOCAL_XFCE" && -d "$HOME/Dev/xfce-workdir" ]]; then
    LOCAL_XFCE=$HOME/Dev/xfce-workdir
fi

#     --keepcache \
x11docker --desktop \
    --interactive \
    --size 1280x720 \
    --cap-default \
    --network=private \
    --init=none \
    --xephyr \
    --user=RETAIN \
    --name xfce-test \
    --pull=ask \
    --showenv \
    --showid \
    --showpid1 \
    -- \
    ${LOCAL_XFCE:+--volume "$LOCAL_XFCE:/container/xfce/workdir:rw"} \
    -- \
    xfce-test/xfce-test-archlinux:latest
