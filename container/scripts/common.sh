function runuser() {
    sudo /usr/bin/runuser -u "${USERNAME:-$USER}" "${@}"
    # sudo --user "${USERNAME:-$USER}" "${@:2}"
}
