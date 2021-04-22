FROM archlinux:latest AS stage0
LABEL org.opencontainers.image.authors="noblechuk5[at]web[dot]de"
LABEL org.opencontainers.image.title="xfce-test-archlinux"
LABEL org.opencontainers.image.description="ArchLinux environment for hacking on xfce-test"
LABEL org.opencontainers.image.source = "https://github.com/xfce-test/container-archlinux"

ARG TRAVIS_CI
ARG ACTIONS_CI

ARG USER_SHELL
ENV USER_SHELL="${USER_SHELL}"

# identify who is running this build
RUN id

# base packages
RUN pacman -Syu base-devel git ${USER_SHELL} --noconfirm --needed

ARG CONTAINER_BASE
ENV CONTAINER_BASE="${CONTAINER_BASE}"

WORKDIR "${CONTAINER_BASE}"

# Setup the test user
ARG USER_NAME
ENV USER_NAME="${USER_NAME}"
ENV USER="${USER_NAME}"
ENV USER_ID=100
ENV USER_HOME="/home/${USER_NAME}"

COPY --chown="${USER_ID}" container/scripts/common.sh "${CONTAINER_BASE}/scripts/"
COPY --chown="${USER_ID}" container/etc "${CONTAINER_BASE}/etc"
COPY --chown="${USER_ID}" container/pkglist.txt "${CONTAINER_BASE}/pkglist.txt"

COPY --chown="${USER_ID}" container/scripts/create-user.sh "${CONTAINER_BASE}/scripts/"
RUN scripts/create-user.sh

# for makepkg
ENV PACKAGER="${USER_NAME} <xfce4-dev@xfce.org>"
ENV BUILDDIR=/var/cache/makepkg-build/
RUN install -dm755 --owner="${USER_NAME}" ${BUILDDIR}

# install the local AUR database for hosting xfce packages
COPY --chown="${USER_ID}" container/scripts/create-local-aur.sh "${CONTAINER_BASE}/scripts/"
RUN scripts/create-local-aur.sh

# build pacman helper
ARG PACMAN_HELPER
ENV PACMAN_HELPER="${PACMAN_HELPER}"
ARG PACMAN_HELPER_URL
ENV PACMAN_HELPER_URL="${PACMAN_HELPER_URL:-https://aur.archlinux.org/${PACMAN_HELPER}.git}"
ENV PACMAN="${PACMAN_HELPER}"
COPY --chown="${USER_ID}" container/scripts/pkg-utils.sh "${CONTAINER_BASE}/scripts/"
RUN scripts/pkg-utils.sh

ENV XFCE_WORK_DIR="${CONTAINER_BASE}/git"
COPY --chown="${USER_ID}" xfce/repo "${XFCE_WORK_DIR}"
RUN chmod -R g+ws "${XFCE_WORK_DIR}"

# line used to invalidate all git clones
ARG DOWNLOAD_DATE
ENV DOWNLOAD_DATE="${DOWNLOAD_DATE}"
ARG MAIN_BRANCH
ENV MAIN_BRANCH="${MAIN_BRANCH}"
# useful for affecting compilation
ARG CFLAGS
ARG CPPFLAGS
ENV CFLAGS="${CFLAGS}"

# build and install all packages
COPY --chown="${USER_ID}" container/scripts/build-packages.sh "${CONTAINER_BASE}/scripts/"
RUN ln -s "${CONTAINER_BASE}/scripts/build-packages.sh" /usr/local/bin/build-packages
RUN scripts/build-packages.sh

# setup machine-id
RUN touch /etc/machine-id

# install more packages required for the next few steps
# RUN runuser -u ${USER_NAME} -- ${PACMAN} -S python-behave gsettings-desktop-schemas --noconfirm --needed

# needed for LDTP and friends
# RUN /usr/bin/dbus-run-session /usr/bin/gsettings set org.gnome.desktop.interface toolkit-accessibility true

# Install _all_ languages for testing
# RUN ${PACMAN} -Syu --noconfirm \
#  && ${PACMAN} -S transifex-client xautomation intltool \
#     opencv python-google-api-python-client \
#     python-oauth2client --noconfirm --needed

# RUN /container_scripts/build_time/create_automate_langs.sh

# Rather use my patched version
# TODO: Create an AUR package for ldtp2
# RUN cd git \
#  && git clone -b python3 https://github.com/schuellerf/ldtp2.git \
#  && cd ldtp2 \
#  && sudo pip3 install -e .

# COPY behave /behave_tests

# RUN mkdir /data

# COPY xfce-test /usr/bin/

# RUN chmod a+x /usr/bin/xfce-test && ln -s /usr/bin/xfce-test /xfce-test

# COPY --chown=${USER_NAME} .tmuxinator "${USER_HOME}/.tmuxinator"

# COPY --chown=${USER_NAME} extra_files/mimeapps.list "${USER_HOME}/.config/"

# RUN install -dm755 --owner=${USER_NAME} "${USER_HOME}/Desktop"

# RUN ln --symbolic /data "${USER_HOME}/Desktop/data"

COPY container/etc/X11/xinit /etc/X11/xinit/
COPY container/etc/xdg/xfce4 /etc/xdg/xfce4/
COPY --chown="${USER_ID}" container/scripts/user-configs.sh "${CONTAINER_BASE}/scripts/"
RUN scripts/user-configs.sh

FROM archlinux:latest

COPY --from=stage0 / /

# switch to the test-user
USER "${USER_NAME}"

WORKDIR "${USER_HOME}"

COPY --chown="${USER_ID}" container/scripts/entrypoint.sh "${CONTAINER_BASE}/scripts/"
ENTRYPOINT [ "/bin/bash", "-c", "${CONTAINER_BASE}/scripts/entrypoint.sh ${@}", "--" ]
