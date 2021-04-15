# if ! ((__COMMON_INCLUDED__)); then

export DOWNLOAD_DATE="${DOWNLOAD_DATE:-$(date '+%Y-%m-%d %T')}"

# https://wiki.archlinux.org/index.php/Aurweb_RPC_interface#API_usage
AUR_RPC='https://aur.archlinux.org/rpc/?v=5'

SCRIPTS_DIR=$(dirname "$(readlink --canonicalize "${BASH_SOURCE[0]}")")
ROOT_DIR=$(realpath "${SCRIPTS_DIR}/../../")
PKG_JSON="${ROOT_DIR}/xfce/packages.json"

#     __COMMON_INCLUDED__=1
# fi
