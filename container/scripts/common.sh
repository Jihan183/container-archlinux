USER_NAME="${USER_NAME:-$USER}"

function runuser() {
    sudo /usr/bin/runuser -u "${USER_NAME}" "${@}"
}
