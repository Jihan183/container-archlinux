#!/bin/bash

export DEFAULT_USER="${DEFAULT_USER:-xfce-test_user}"
export DOWNLOAD_DATE="${DOWNLOAD_DATE:-$(date +%Y-%m-%d)}"

docker build \
    --build-arg DEFAULT_USER \
    --build-arg DOWNLOAD_DATE \
    --volume "$PWD/xfce/db:/container/xfce:ro" \
    --volume "$PWD/container:/container:ro" \
    --tag xfce-test/xfce-test:archlinux --file Dockerfile .
