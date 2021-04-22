function runuser() {
    sudo /usr/bin/runuser -u "${USER_NAME:-$USER}" "${@}"
}
