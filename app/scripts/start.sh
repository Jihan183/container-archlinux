#!/bin/bash

if [[ -z "$LOCAL_XFCE" && -d "$HOME/Dev/xfce-workdir" ]]; then
    LOCAL_XFCE=$HOME/Dev/xfce-workdir
fi

#     --keepcache \
x11docker --debug --desktop \
    --clipboard \
    --size 1280x720 \
    --cap-default \
    --network=private \
    --init=dockerinit \
    --xephyr \
    --user=RETAIN \
    --name xfce-test \
    --pull=ask \
    --showenv \
    --showid \
    --showinfofile \
    --showpid1 \
    -- \
    ${LOCAL_XFCE:+--volume "$LOCAL_XFCE:/container/xfce/workdir:ro"} \
    -- \
    schuellerf/xfce-test:latest
    # xfce-test/xfce-test-archlinux:dev
