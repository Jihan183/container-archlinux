FROM archlinux:latest
LABEL maintainer="noblechuk5[at]web[dot]de"
LABEL name="xfce-test"
LABEL version="0.1"
LABEL description="ArchLinux environment for hacking on xfce-test"

ARG DISPLAY
ENV DISPLAY="${DISPLAY:-:2}"
ARG TRAVIS
ENV TRAVIS="${TRAVIS:-false}"

ARG USERSHELL
ENV USERSHELL="${USERSHELL:-zsh}"

# base packages
RUN pacman -Syu base-devel git ${USERSHELL} --noconfirm --needed

ARG CONTAINER_BASE
ENV CONTAINER_BASE="${CONTAINER_BASE:-/container/xfce}"

WORKDIR "${CONTAINER_BASE}"

# Setup the test user
ARG USER_NAME
ENV USER_NAME="${USER_NAME:-xfcetest}"
ENV USER="${USER_NAME}"
ENV USER_ID=100
ENV USERHOME="/home/${USER_NAME}"

COPY --chown="${USER_ID}" container/scripts "${CONTAINER_BASE}/scripts"
COPY --chown="${USER_ID}" container/etc "${CONTAINER_BASE}/etc"
COPY --chown="${USER_ID}" container/pkglist.txt "${CONTAINER_BASE}/pkglist.txt"
RUN ln -s "${CONTAINER_BASE}/scripts/build-packages.sh" /usr/local/bin/build-packages
RUN ln -s "${CONTAINER_BASE}/scripts/install-packages.sh" /usr/local/bin/install-packages

RUN scripts/create-user.sh

# for makepkg
ENV PACKAGER="${USER_NAME} <xfce4-dev@xfce.org>"
ENV BUILDDIR=/var/cache/makepkg-build/
RUN install -dm755 --owner="${USER_NAME}" ${BUILDDIR}

# install the local AUR database for hosting xfce packages
RUN scripts/create-local-aur.sh

# build pacman helper
ARG PACMAN_HELPER
ENV PACMAN_HELPER="${PACMAN_HELPER:-yay}"
ARG PACMAN_HELPER_URL="https://aur.archlinux.org/${PACMAN_HELPER}.git"
ENV PACMAN="${PACMAN_HELPER}"
RUN scripts/pkg-utils.sh

# install more packages required for the next few steps
# RUN runuser -u ${USER_NAME} -- ${PACMAN} -S python-behave gsettings-desktop-schemas --noconfirm --needed

# needed for LDTP and friends
# RUN /usr/bin/dbus-run-session /usr/bin/gsettings set org.gnome.desktop.interface toolkit-accessibility true
ENV XFCE_WORK_DIR="${CONTAINER_BASE}/git"
COPY --chown="${USER_ID}" xfce/repo "${XFCE_WORK_DIR}"
RUN chmod -R g+ws "${XFCE_WORK_DIR}"

# line used to invalidate all git clones
ARG DOWNLOAD_DATE
ENV DOWNLOAD_DATE="${DOWNLOAD_DATE:-2021-04-15 00:00:00}"
ARG MAIN_BRANCH
ENV MAIN_BRANCH="${MAIN_BRANCH:-master}"
# useful for affecting compilation
ARG CFLAGS
ARG CPPFLAGS
ENV CFLAGS=" ${CFLAGS:--O2 -pipe}"

# build and install all packages
RUN scripts/build-packages.sh
RUN scripts/install-packages.sh

# Install _all_ languages for testing
# RUN ${PACMAN} -Syu --noconfirm \
#  && ${PACMAN} -S transifex-client xautomation intltool \
#     opencv python-google-api-python-client \
#     python-oauth2client --noconfirm --needed

# RUN /container_scripts/build_time/create_automate_langs.sh

# Group all repos here
# RUN install -dm755 --owner=${USER_NAME} /git

# Rather use my patched version
# TODO: Create an AUR package for ldtp2
# RUN cd git \
#  && git clone -b python3 https://github.com/schuellerf/ldtp2.git \
#  && cd ldtp2 \
#  && sudo pip3 install -e .

# clean the install cache
# RUN runuser -u ${USER_NAME} -- ${PACMAN} -Sc --noconfirm

# COPY behave /behave_tests

# RUN mkdir /data

# COPY xfce-test /usr/bin/

# RUN chmod a+x /usr/bin/xfce-test && ln -s /usr/bin/xfce-test /xfce-test

# COPY --chown=${USER_NAME} .tmuxinator "${USERHOME}/.tmuxinator"

# COPY --chown=${USER_NAME} extra_files/mimeapps.list "${USERHOME}/.config/"

# RUN install -dm755 --owner=${USER_NAME} "${USERHOME}/Desktop"

# RUN ln --symbolic /data "${USERHOME}/Desktop/data"

# RUN ln --symbolic "${USERHOME}/version_info.txt" "${USERHOME}"/Desktop
RUN sudo runuser -u "${USER_NAME}" -- ln -s "${CONTAINER_BASE}" "${USERHOME}/container"

# switch to the test-user
USER "${USER_NAME}"

WORKDIR "${USERHOME}"

ENTRYPOINT "${CONTAINER_BASE}/scripts/entrypoint.sh"
