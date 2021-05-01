SHELL ?= /bin/bash
DOCKER ?= $(shell which docker 2> /dev/null)
XFCE_TEST_IMAGE ?= xfce-test/xfce-test-archlinux:devel
LOCAL_XFCE ?= ${HOME}/Dev/xfce-workdir

.PHONY: docker-cmd
docker-cmd:
ifndef DOCKER
	$(error "docker command not found")
endif

.PHONY: git-cmd
git-cmd:
ifeq ($(shell which git 2> /dev/null),)
	$(error "git command not found")
endif

.PHONY: get-container
get-container: docker-cmd
	@if ! ${DOCKER} inspect --type image ${XFCE_TEST_IMAGE} --format '{{.ID}}' 2> /dev/null; then \
		${DOCKER} pull ${XFCE_TEST_IMAGE}; 														  \
	fi


.PHONY: start-container
start-container: export XFCE_TEST_IMAGE ?=
start-container: export LOCAL_XFCE ?=
start-container: get-container
	@./app/scripts/start.sh


.DEFAULT_GOAL := build-container
.PHONY: build-container
build-container: export XFCE_TEST_IMAGE ?=
build-container: docker-cmd
	@./app/scripts/build.sh


.PHONY: workdir
workdir: export LOCAL_XFCE ?=
workdir: git-cmd ${LOCAL_XFCE}
	@./app/scripts/setup-workdir.sh

