PWD = $(shell pwd)
IMAGE_NAME = $(shell basename ${PWD})
BASE_IMAGE = $(shell grep Dockerfile -e FROM | cut -d ' ' -f 2)
#DOCKER_SOCKET = /var/run/docker.sock
BUILD_ARGS = --rm

all: pull build test

pull:
	##
	## Pulling image updates from registry
	##
	for IMAGE in ${BASE_IMAGE}; \
		do docker pull $${IMAGE}; \
	done

build:
	##
	## Starting build of image ${IMAGE_NAME}
	##
	docker build ${BUILD_ARGS} --tag ${IMAGE_NAME} .

clean:
	##
	## Removing docker images .. most errors during this stage are ok, ignore them
	##
	for IMAGE in ${BASE_IMAGE}; \
		do docker pull $${IMAGE}; \
	done

.PHONY: all pull build clean
