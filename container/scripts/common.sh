USER_NAME="${USER_NAME:-$USER}"

function runuser() {
    sudo /usr/bin/runuser -u "${USER_NAME}" "${@}"
}

if [[ -n $ACTIONS_CI || -n $TRAVIS_CI ]]; then
    CI=true
fi
