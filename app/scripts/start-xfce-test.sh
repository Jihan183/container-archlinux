#!/bin/bash

docker run -it \
    --rm --privileged \
    --volume "$PWD/xfce/db":/container/xfce:ro \
    --volume "$PWD/container":/container:ro \
    xfce-test/xfce-test:archlinux /bin/bash
