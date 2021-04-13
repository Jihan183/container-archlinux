#!/bin/bash -ex

source /container/scripts/common.sh

useradd --create-home --no-log-init \
        --shell "/bin/${USERSHELL}" "${USERNAME}"
install --owner="${USERNAME}" -dm755 "${USERHOME}"/.local/{,bin}
install -dm755 /etc/sudoers.d/
sed "s:%{USERNAME}%:${USERNAME}:g" etc/sudoers.d/20-xfce-test.in > \
    /etc/sudoers.d/20-xfce-test
