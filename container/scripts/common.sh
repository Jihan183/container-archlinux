function runuser() {
    sudo /usr/bin/runuser -p -u "${USERNAME:-$USER}" "${@}"
    # sudo --user "${USERNAME:-$USER}" "${@:2}"
}
