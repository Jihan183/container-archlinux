DOCKER ?= $(shell which docker 2> /dev/null)
XFCE_TEST_IMAGE ?= xfce-test/xfce-test-archlinux:devel
SHELL ?= /bin/bash

.PHONY: docker-cmd
docker-cmd:
ifndef DOCKER
	$(error "docker command not found")
endif

.PHONY: get-image
get-container: docker-cmd
	@if ! ${DOCKER} inspect --type image ${XFCE_TEST_IMAGE} --format '{{.ID}}' > /dev/null; then \
		${DOCKER} pull ${XFCE_TEST_IMAGE}; 														 \
	fi

.PHONY: start-container
start-container: export XFCE_TEST_IMAGE ?=
start-container: get-container
	@./app/scripts/start.sh

.PHONY: build-container
build-container: export XFCE_TEST_IMAGE ?=
build-container: docker-cmd
	@./app/scripts/build.sh
