#!/bin/bash -e
set -o pipefail

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

groupadd --gid "${USER_ID}" "${USER}" \
        && useradd --create-home --no-log-init \
                --shell "/bin/${USER_SHELL}"  \
                --comment "Xfce dev user" \
                --uid="${USER_ID}" --gid "${USER_ID}" \
                "${USER}"

install --owner="${USER}" -dm755 "${USER_HOME}"/.local/{,bin}
install -dm750 /etc/sudoers.d/ --owner=root
sed "s:%{USER_NAME}%:${USER}:g" "${CONTAINER_BASE}/etc/sudoers.d/20-xfce-test.in" \
        | tee /etc/sudoers.d/20-xfce-test

runuser -- id
