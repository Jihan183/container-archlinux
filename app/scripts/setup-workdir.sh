#!/bin/bash -e

# shellcheck source=app/scripts/vars.sh
source "$(dirname "$(readlink --canonicalize "${BASH_SOURCE[0]}")")/vars.sh"

mkdir -p xfce-workdir
cd xfce-workdir
export WORK_DIR="$PWD"

find "${ROOT_DIR}/xfce/repo" -maxdepth 2 -name 'PKGBUILD' -type f -execdir sh -c '
    repo_url=`sed -En "s|url=\W*\b(.+)\b\W*$|\1.git|p" $1`
    pkg=${PWD##*/}
    pkg_workdir="$WORK_DIR/$pkg"

    if [ ! -d "$pkg_workdir" ]; then
        git init --initial-branch="${MAIN_BRANCH}" "$pkg_workdir"
        cd "$pkg_workdir"
        git remote add -m "${MAIN_BRANCH}" -f origin "$repo_url"
        git checkout "${MAIN_BRANCH}"
        # git symbolic-ref refs/heads/master refs/heads/main
    fi
' _ '{}' \;
