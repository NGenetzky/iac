
# reference: https://bananamafia.dev/post/docker-borg/
SHELL := /bin/bash
VERSION ?= latest

# The directory of this file
DIR := $(shell echo $(shell cd "$(shell  dirname "${BASH_SOURCE[0]}" )" && pwd ))

IMAGE_NAME ?= srvbox
CONTAINER_NAME ?= srvbox

# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# Build the container
build: ## Build the container
	./build.bash

run: ## Run container
	docker run \
		--name $(CONTAINER_NAME) \
		-d \
		-p '10122:22' \
		-p '10180:8888' \
		-v '/:/mnt/:ro' \
		-v "$(PWD):/home/ngenetzky/Downloads/" \
		$(IMAGE_NAME):$(VERSION)

stop: ## Stop a running container
	docker stop $(CONTAINER_NAME)

remove: ## Remove a (running) container
	docker rm -f $(CONTAINER_NAME)

remove-image-force: ## Remove the latest image (forced)
	docker rmi -f $(IMAGE_NAME):$(VERSION)

