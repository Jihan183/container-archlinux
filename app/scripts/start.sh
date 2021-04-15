#!/bin/bash

if ! docker images --filter reference='xfce-test/xfce-test:archlinux' --filter dangling=false; then
    echo "No images found in the image storage"
    exit 1
fi

export LOCAL_XFCE="${LOCAL_XFCE:-$HOME/Dev/xfce-workdir}"

docker run --interactive --tty --rm \
    --volume "$LOCAL_XFCE/":/container/xfce/workdir:rw,nocopy \
    xfce-test/xfce-test:archlinux /bin/bash
