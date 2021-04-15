#!/bin/bash

# shellcheck source=app/scripts/common-args.sh
source "$(dirname "$(readlink --canonicalize "${BASH_SOURCE[0]}")")/common-args.sh"

docker build \
    --pull \
    --force-rm \
    --build-arg USER_NAME \
    --build-arg MAIN_BRANCH \
    --build-arg DOWNLOAD_DATE \
    --tag xfce-test/xfce-test:archlinux --file Dockerfile .
