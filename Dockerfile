FROM archlinux:latest
LABEL maintainer="noblechuk5[at]web[dot]de"
LABEL name="xfce-test"
LABEL version="0.1"
LABEL description="ArchLinux environment for hacking on xfce-test"

# only works for ArchLinux
ARG DISPLAY=":1"
ENV DISPLAY="${DISPLAY}"
ARG TRAVIS=false

ARG USERSHELL='zsh'
ARG DEBUG=1

# base packages
RUN pacman -Syu base-devel git ${USERSHELL} --noconfirm --needed

WORKDIR /container

# Setup the test user
ARG USERNAME='xfcetest'
ENV USER="${USERNAME}"
ENV USERHOME="/home/${USERNAME}"
RUN /container/scripts/create-user.sh

# for makepkg
ENV PACKAGER="${USERNAME} <xfce4-dev@xfce.org>"
ENV BUILDDIR=/var/cache/makepkg-build/
RUN install -dm755 --owner="${USERNAME}" ${BUILDDIR}

# install the local AUR database for hosting xfce packages
RUN /container/scripts/create-local-aur.sh

# build pacman helper
ARG PACMAN_HELPER='yay'
ARG PACMAN_HELPER_URL="https://aur.archlinux.org/${PACMAN_HELPER}.git"
ENV PACMAN="${PACMAN_HELPER}"
RUN env PACMAN_HELPER_URL="$(sed -E 's|/yay(\.git)$|/yay-bin\1|' <<< ${PACMAN_HELPER_URL})" /container/scripts/pkg-utils.sh

# install more packages required for the next few steps
# RUN runuser -u ${USERNAME} -- ${PACMAN} -S python-behave gsettings-desktop-schemas --noconfirm --needed
ENV XFCE_WORK_DIR='/git/xfce-test'
# needed for LDTP and friends
# RUN /usr/bin/dbus-run-session /usr/bin/gsettings set org.gnome.desktop.interface toolkit-accessibility true
RUN install -dm755 --group=${USERNAME} "${XFCE_WORK_DIR}" \
    && find /container/xfce/ -maxdepth 2 -type f -name 'PKGBUILD' \
        -execdir sh -c 'install -Dm644 \
            <(sed "s|\$url\.git|file://${PWD}|" {}) \
            /git/xfce-test/${PWD##*/}/PKGBUILD' \; \
    && chgrp -R ${USERNAME} "${XFCE_WORK_DIR}" \
    && chmod -R g+ws "${XFCE_WORK_DIR}"

# line used to invalidate all git clones
ARG DOWNLOAD_DATE
ENV DOWNLOAD_DATE="${DOWNLOAD_DATE}"
ARG MAIN_BRANCH='master'
ENV MAIN_BRANCH="${MAIN_BRANCH}"
# useful for affecting compilation
ARG CFLAGS='-O2 -pipe'
ENV CFLAGS="${CFLAGS}"

WORKDIR "${XFCE_WORK_DIR}"
RUN /container/scripts/build-packages.sh

# copy in the scripts
COPY --chown="${USERNAME}" container/scripts /container/scripts
COPY --chown="${USERNAME}" container/pkglist.txt /container/pkglist.txt
RUN ln -s /container/scripts/build-packages.sh /usr/local/bin/build-packages

# Install _all_ languages for testing
# RUN ${PACMAN} -Syu --noconfirm \
#  && ${PACMAN} -S transifex-client xautomation intltool \
#     opencv python-google-api-python-client \
#     python-oauth2client --noconfirm --needed

# RUN /container_scripts/build_time/create_automate_langs.sh

# Group all repos here
# RUN install -dm755 --owner=${USERNAME} /git

# Rather use my patched version
# TODO: Create an AUR package for ldtp2
# RUN cd git \
#  && git clone -b python3 https://github.com/schuellerf/ldtp2.git \
#  && cd ldtp2 \
#  && sudo pip3 install -e .

# clean the install cache
# RUN runuser -u ${USERNAME} -- ${PACMAN} -Sc --noconfirm

# COPY behave /behave_tests

# RUN mkdir /data

# COPY xfce-test /usr/bin/

# RUN chmod a+x /usr/bin/xfce-test && ln -s /usr/bin/xfce-test /xfce-test

# COPY --chown=${USERNAME} .tmuxinator "${USERHOME}/.tmuxinator"

# COPY --chown=${USERNAME} extra_files/mimeapps.list "${USERHOME}/.config/"

# RUN install -dm755 --owner=${USERNAME} "${USERHOME}/Desktop"

# RUN ln --symbolic /data "${USERHOME}/Desktop/data"

# RUN ln --symbolic "${USERHOME}/version_info.txt" "${USERHOME}"/Desktop

# switch to the test-user
USER "${USERNAME}"

WORKDIR "${USERHOME}"

RUN exit 0

# CMD [ "/container_scripts/entrypoint.sh" ]
