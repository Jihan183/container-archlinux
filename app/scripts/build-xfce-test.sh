#!/bin/bash

export DOWNLOAD_DATE="${DOWNLOAD_DATE:-$(date '+%Y-%m-%d %T')}"

docker build \
    --build-arg USERNAME \
    --build-arg DOWNLOAD_DATE \
    --build-arg DEBUG \
    --volume "$PWD/xfce/db:/container/xfce:ro" \
    --volume "$PWD/container:/container:ro" \
    --tag xfce-test/xfce-test:archlinux --file Dockerfile .
