FROM archlinux:latest
LABEL org.opencontainers.image.authors="noblechuk5[at]web[dot]de"
LABEL org.opencontainers.image.title="xfce-test-archlinux"
LABEL org.opencontainers.image.description="ArchLinux environment for hacking on xfce-test"
LABEL org.opencontainers.image.source = "https://github.com/xfce-test/container-archlinux"

ARG TRAVIS_CI
ARG ACTIONS_CI
ARG USER_SHELL
ARG XFCE_BASE
ARG USER_NAME
ARG PACMAN_HELPER
ARG PACMAN_HELPER_URL
ARG DOWNLOAD_DATE
ARG MAIN_BRANCH
ARG CFLAGS
ARG CPPFLAGS

# https://github.com/containers/buildah/issues/1503
ENV XFCE_BASE="${XFCE_BASE}"
ENV USER="${USER_NAME}"
ENV USER_ID=100
ENV USER_HOME="/home/${USER}/"
ENV PACKAGER="${USER_NAME} <xfce4-dev@xfce.org>"
ENV BUILDDIR=/var/cache/makepkg-build/
ENV PACMAN_HELPER="${PACMAN_HELPER}"
ENV PACMAN_HELPER_URL="${PACMAN_HELPER_URL:-https://aur.archlinux.org/${PACMAN_HELPER}.git}"
ENV PACMAN="${PACMAN_HELPER}"
ENV XFCE_GIT_DIR="${XFCE_BASE}/git/"
ENV CFLAGS="${CFLAGS}"
ENV CPPFLAGS="${CPPFLAGS}"

# identify who is running this build
RUN id && \
    pacman -Syu base-devel git ${USER_SHELL} --noconfirm --needed

WORKDIR "${XFCE_BASE}"

# copy in some useful file and setup a test user
COPY --chown="${USER_ID}" \
    container/scripts/common.sh \
    container/scripts/create-local-aur.sh \
    container/scripts/create-user.sh \
    container/scripts/entrypoint.sh \
    container/scripts/pkg-utils.sh \
    container/scripts/runtime.sh \
    ${XFCE_BASE}/scripts/
COPY --chown="${USER_ID}" xfce/repo "${XFCE_GIT_DIR}"
COPY --chown="${USER_ID}" container/etc/sudoers.d ${XFCE_BASE}/etc/sudoers.d/
COPY --chown="${USER_ID}" container/etc/pacman.conf.in ${XFCE_BASE}/etc/
COPY --chown="${USER_ID}" container/pkglist.txt ${XFCE_BASE}/
RUN scripts/create-user.sh

# setup aur and install pacman helper
RUN install -dm755 --owner="${USER}" ${BUILDDIR} && \
    scripts/create-local-aur.sh && \
    scripts/pkg-utils.sh

# build and install all xfce packages
COPY --chown="${USER_ID}" container/scripts/build-packages.sh "${XFCE_BASE}/scripts/"
RUN chmod -R g+ws "${XFCE_GIT_DIR}" && \
    ln -s "${XFCE_BASE}/scripts/build-packages.sh" /usr/local/bin/build-packages && \
    build-packages

# setup some useful runtime defaults for the user
COPY container/etc/X11/ /etc/X11/
COPY --chown="${USER_ID}" container/home/user/ "${USER_HOME}"
RUN scripts/runtime.sh

# switch to the test-user
USER "${USER}"
WORKDIR "${USER_HOME}"
ENTRYPOINT [ "/bin/bash", "-c", "exec ${XFCE_BASE}/scripts/entrypoint.sh \"${@}\"", "--" ]

# install more packages required for the next few steps
# RUN runuser -u ${USER} -- ${PACMAN} -S python-behave gsettings-desktop-schemas --noconfirm --needed

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

# COPY --chown=${USER} .tmuxinator "${USER_HOME}/.tmuxinator"

# COPY --chown=${USER} extra_files/mimeapps.list "${USER_HOME}/.config/"

# RUN install -dm755 --owner=${USER} "${USER_HOME}/Desktop"

# RUN ln --symbolic /data "${USER_HOME}/Desktop/data"
