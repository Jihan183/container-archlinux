#!/bin/bash

# shellcheck source=app/scripts/common-args.sh
source "$(dirname "$(readlink --canonicalize "${BASH_SOURCE[0]}")")/common-args.sh"

docker build \
    --no-cache \
    --pull \
    --force-rm \
    --build-arg USERNAME \
    --build-arg DOWNLOAD_DATE \
    --build-arg DEBUG \
    --volume "$ROOT_DIR/container/:/container/:ro" \
    --tag xfce-test/xfce-test:archlinux --file Dockerfile .
