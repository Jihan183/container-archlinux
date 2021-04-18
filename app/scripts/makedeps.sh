#!/bin/bash

# shellcheck source=app/scripts/vars.sh
source "$(dirname "$(readlink --canonicalize "${BASH_SOURCE[0]}")")/vars.sh"

# reads the contents of the packages.json file
# and removes comments starting with `//`, as well
function read_pkgjson() {
    awk '!/^\s*\/\//' "$PKG_JSON"
}

# filter out packages which are in the ignore section of
# packages.json
function ignore_pkgjson() {
    awk --source 'BEGIN {'"
        $(read_pkgjson | jq -cr '.ignore_packages[]' | sed -E 's/(^.+$)/ignore["\1"]=1;/')
    }"'
    !ignore[$0]'
}

# get the dependencies from aur or arch
function fetch_deps() {
    case "${1,,}" in
    "aur")
        curl --silent \
            "$AUR_RPC&type=info&by=name$(printf '&arg[]=%s' "${2}")" |
            jq -r '[.results[].Depends?] | flatten | join("\n")'
        ;;

    "arch")
        # ARCH_WEB='https://archlinux.org/packages/search/json/'
        kittypack --json "${2}" | jq -csr '[.[].results[].depends[]?] | join("\n")'
        ;;
    esac
}

# used to fetch makedependencies
function fetch_makedeps() {
    case "${1,,}" in
    "aur")
        curl --silent \
            "$AUR_RPC&type=info&by=name$(printf '&arg[]=%s' "${2}")" |
            jq -r '[.results[].MakeDepends?] | flatten | join("\n")'
        ;;

    "arch")
        # ARCH_WEB='https://archlinux.org/packages/search/json/'
        kittypack --json "${2}" | jq -csr '[.[].results[].makedepends[]?] | join("\n")'
        ;;
    esac
}

# remove dups, and remove built packages from dep list
function clean_deps() {
    sort --unique - | "$SCRIPTS_DIR/dups.sed.sh" | "$SCRIPTS_DIR/normalize.awk" "${ALL_XFCE_PACKAGES[@]}"
}

# called to update the dependencies of each package
function update_packages() {
    # nothing to see here...
    local api="$1" p DEPS MAKE_DEPS

    for p in "${@:2}"; do
        local pp="${p%%-git}"
        printf 'Updating %s...' "${pp}"
        mapfile -t DEPS < <(fetch_deps "$api" "$p" | clean_deps)
        mapfile -t MAKE_DEPS < <(fetch_makedeps "$api" "$p" | clean_deps)

        # just an indicator that either deps or makedeps was created
        local fail=0
        if ((${#DEPS[@]})); then
            sed -i -E "s/(^depends)=\(.*\)/\1=(${DEPS[*]@Q})/" "xfce/repo/${pp}/PKGBUILD"
            fail=$((fail + ${?##-}))
        fi
        if ((${#MAKE_DEPS[@]})); then
            sed -i -E "s/(^makedepends)=\(.*\)/\1=(${MAKE_DEPS[*]@Q})/" "xfce/repo/${pp}/PKGBUILD"
            fail=$((fail + ${?##-}))
        fi

        if (( "${fail/#[^0]*/1}" )); then
            printf "nothing "
        fi

        echo 'done'
    done
}

# these packages exist on aur as git packages
mapfile -t AUR_GIT_PACKAGES < <(read_pkgjson | jq -cr '.aur_git_packages[]' | ignore_pkgjson)

# These are packages which we are able find in the main repos
mapfile -t ARCH_MAIN_PACKAGES < <(read_pkgjson | jq -cr '.arch_main_packages[]' | ignore_pkgjson)

# These are packages we can only find on AUR (better than nothing)
mapfile -t AUR_PACKAGES < <(read_pkgjson | jq -cr '.aur_packages[]' | ignore_pkgjson)

# all packages to be built: 65
ALL_XFCE_PACKAGES=(
    "${AUR_GIT_PACKAGES[@]}" "${ARCH_MAIN_PACKAGES[@]}"
    "${AUR_PACKAGES[@]}"
)

if ((!${#ALL_XFCE_PACKAGES[@]})); then
    echo "No packages to read. Exiting..."
    exit 1
fi

update_packages aur "${AUR_GIT_PACKAGES[@]/%/-git}" "${AUR_PACKAGES[@]}"
update_packages arch "${ARCH_MAIN_PACKAGES[@]}"
