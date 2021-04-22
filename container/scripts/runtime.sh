#!/bin/bash -e

# shellcheck source=container/scripts/common.sh
source "${CONTAINER_BASE}/scripts/common.sh"

# bring the container tools closer to home
runuser -- ln -s "${CONTAINER_BASE}" "${USER_HOME}/container"

# zsh is too barebones initially, let's fix that
if [ "${USER_SHELL,,}" = 'zsh' ]; then
        runuser -- "${PACMAN}" -Syu oh-my-zsh-git xclip --needed --noconfirm
        install -Dm644 --owner="${USER}" /usr/share/oh-my-zsh/zshrc "${USER_HOME}/.zshrc"
fi

# setup machine-id
touch /etc/machine-id
