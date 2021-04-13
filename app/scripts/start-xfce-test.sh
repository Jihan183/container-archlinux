#!/bin/bash

if ! docker images --filter label='name=xfce-test' --filter dangling=false; then
    echo "No images found in the image storage"
    exit 1
fi

docker run -it \
    --rm --privileged \
    --volume "$PWD/xfce/db":/container/xfce:ro \
    --volume "$PWD/container":/container:ro \
    xfce-test/xfce-test:archlinux /bin/bash
