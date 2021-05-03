#!/bin/bash -e
set -o pipefail

# shellcheck source=container/scripts/common.sh
source "${XFCE_BASE}/scripts/common.sh"

groupadd --gid "${USER_ID}" "${USER_NAME}" \
        && useradd --create-home --no-log-init \
                --shell "/bin/${USER_SHELL}"  \
                --comment "Xfce dev user" \
                --uid="${USER_ID}" --gid "${USER_ID}" \
                "${USER_NAME}"

install --owner="${USER_NAME}" -dm755 "${USER_HOME}"/.local/{,bin}
install -dm750 /etc/sudoers.d/ --owner=root
sed "s:%{USER_NAME}%:${USER_NAME}:g" "${XFCE_BASE}/etc/sudoers.d/20-xfce-test.in" \
        | tee /etc/sudoers.d/20-xfce-test

runuser -- id
