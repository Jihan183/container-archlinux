#!/bin/bash

# https://wiki.archlinux.org/index.php/Aurweb_RPC_interface#API_usage
AUR_RPC='https://aur.archlinux.org/rpc/?v=5'
SCRIPTS_DIR=$(dirname "$(readlink --canonicalize "${BASH_SOURCE[0]}")")

function fetch_deps() {
    case "${1,,}" in
    "aur")
        curl --silent \
            "$AUR_RPC&type=info&by=name$(printf '&arg[]=%s-git' "${2}")" |
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
            "$AUR_RPC&type=info&by=name$(printf '&arg[]=%s-git' "${2}")" |
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
    api="$1"
    for p in "${@:2}"; do
        printf 'Updating %s...' "${p}"
        mapfile -t DEPS < <(fetch_deps "$api" "$p" | clean_deps)
        mapfile -t MAKE_DEPS < <(fetch_makedeps "$api" "$p" | clean_deps)

        if ((${#DEPS[@]})); then
            sed -i -E "s/(^depends)=\(.*\)/\1=(${DEPS[*]@Q})/" "xfce/db/$p/PKGBUILD"
        fi
        if ((${#MAKE_DEPS[@]})); then
            sed -i -E "s/(^makedepends)=\(.*\)/\1=(${MAKE_DEPS[*]@Q})/" "xfce/db/$p/PKGBUILD"
        fi

        echo 'done'
    done
}

packages="xfce/packages.json"

mapfile -t AUR_GIT_PACKAGES < <(awk '!/^\s*\/\//' "$packages" | jq -cr '.aur_git_packages[]')

# These are packages which we are able find in the main repos
mapfile -t ARCH_MAIN_PACKAGES < <(awk '!/^\s*\/\//' "$packages" | jq -cr '.arch_main_packages[]')

# These are packages we can only find on AUR (better than nothing)
mapfile -t AUR_PACKAGES < <(awk '!/^\s*\/\//' "$packages" | jq -cr '.aur_packages[]')

# all packages to be built: 65
ALL_XFCE_PACKAGES=(
    "${AUR_GIT_PACKAGES[@]}" "${ARCH_MAIN_PACKAGES[@]}"
    "${AUR_PACKAGES[@]}"
)

if ((!${#ALL_XFCE_PACKAGES[@]})); then
    echo "No packages to read. Exiting..."
    exit 1
fi

update_packages aur "${AUR_GIT_PACKAGES[@]}" "${AUR_PACKAGES[@]}"
update_packages arch "${ARCH_MAIN_PACKAGES[@]}"
