#!/bin/bash

if ! docker images --filter reference='xfce-test/xfce-test:archlinux' --filter dangling=false; then
    echo "No images found in the image storage"
    exit 1
fi

docker run --interactive --tty --rm \
    ${LOCAL_XFCE:+--volume "$LOCAL_XFCE:/container/xfce/workdir:rw"} \
    xfce-test/xfce-test:archlinux
