#!/bin/bash

source /container/scripts/common.sh

while IFS= read -r pkg; do
    pushd "$pkg"
    runuser -- aur build --prevent-downgrade --database=custom --margs --syncdeps --noconfirm
    popd
done < /container/pkglist.txt
