#!/bin/bash -ex

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

groupadd --gid "${USER_ID}" "${USER_NAME}" \
        && useradd --create-home --no-log-init \
                --shell "/bin/${USERSHELL}"  \
                --comment "Xfce dev user" \
                --uid="${USER_ID}" --gid "${USER_ID}" \
                "${USER_NAME}"

install --owner="${USER_NAME}" -dm755 "${USERHOME}"/.local/{,bin}
install -dm750 /etc/sudoers.d/
sed "s:%{USER_NAME}%:${USER_NAME}:g" "${CONTAINER_BASE}/etc/sudoers.d/20-xfce-test.in" \
        | tee /etc/sudoers.d/20-xfce-test

runuser -- id
