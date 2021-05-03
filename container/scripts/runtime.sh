#!/bin/bash -e

# shellcheck disable=SC2153
# shellcheck source=container/scripts/common.sh
source "${XFCE_BASE}/scripts/common.sh"

# zsh is too barebones initially, let's fix that
if [ "${USER_SHELL,,}" = 'zsh' ]; then
        runuser -- "${PACMAN}" -S oh-my-zsh-git xclip --needed --noconfirm
        install -Dm644 --owner="${USER}" /usr/share/oh-my-zsh/zshrc "${USER_HOME}/.zshrc"
fi

# bring the container tools closer to home
runuser -- ln -s "${XFCE_BASE}" "${USER_HOME}/container"

# Other useful tools
# nano: text editor
# man: man pages
# dconf-editor: enabling gtk inspector keyboard shortcut
runuser -- "${PACMAN}" -S nano man dconf-editor --needed --noconfirm

# setup machine-id (Not sure this is still required)
touch /etc/machine-id
