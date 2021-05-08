#!/bin/bash

# shellcheck source=app/scripts/vars.sh
source "$(dirname "$(readlink --canonicalize "${BASH_SOURCE[0]}")")/vars.sh"

mkdir -p "${LOCAL_XFCE}"
export WORK_DIR="$LOCAL_XFCE"

find "${ROOT_DIR}/xfce/repo" -maxdepth 2 -name 'PKGBUILD' -type f -execdir sh -c '
    repo_url=`sed -En "s|url=\W*\b(.+)\b\W*$|\1.git|p" $1`
    pkg=${PWD##*/}
    pkg_workdir="$WORK_DIR/$pkg"

    if [ ! -d "$pkg_workdir" ] || ! git -C "$pkg_workdir" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        git init --initial-branch="${MAIN_BRANCH}" "$pkg_workdir"
        git -C "$pkg_workdir" remote add -m "${MAIN_BRANCH}" -f origin "$repo_url"
        # git -C "$pkg_workdir" symbolic-ref refs/heads/master refs/heads/main
    else
        git -C "$pkg_workdir" fetch origin
    fi
' _ '{}' \;
