#!/bin/bash

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

runuser -- ln -s "${CONTAINER_BASE}" "${USER_HOME}/container"

# zsh is too basebones initially, let's fix that
if [ "${USER_SHELL,,}" = 'zsh' ]; then
        runuser -- "${PACMAN}" -Syu oh-my-zsh-git --needed --noconfirm
        install -Dm644 --owner="${USER_NAME}" /usr/share/oh-my-zsh/zshrc "${USER_HOME}/.zshrc"
fi

# do something for bash here if needed
