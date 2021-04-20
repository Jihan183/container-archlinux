#!/bin/bash

# shellcheck source=app/scripts/vars.sh
source "$(dirname "$(readlink --canonicalize "${BASH_SOURCE[0]}")")/vars.sh"

eval "$(
    grep -Ev '^#' "$ROOT_DIR/.env" \
    | awk -F'=' '{
        print "export", sprintf("%s=\"%s\";", $1, $2)
    }'
)"

docker build \
    --pull \
    --build-arg USER_NAME \
    --build-arg USER_SHELL \
    --build-arg CONTAINER_BASE \
    --build-arg MAIN_BRANCH \
    --build-arg DOWNLOAD_DATE \
    --build-arg TRAVIS_CI \
    --build-arg ACTIONS_CI \
    --build-arg PACMAN_HELPER \
    --build-arg PACMAN_HELPER_URL \
    --build-arg CONTAINER_BASE \
    --build-arg CFLAGS \
    --build-arg CPPFLAGS \
    --network=host \
    --tag xfce-test/xfce-test-archlinux --file Dockerfile .
