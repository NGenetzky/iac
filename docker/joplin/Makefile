
# reference: https://bananamafia.dev/post/docker-borg/
SHELL := /bin/bash
VERSION ?= latest

# The directory of this file
DIR := $(shell echo $(shell cd "$(shell  dirname "${BASH_SOURCE[0]}" )" && pwd ))

IMAGE_NAME ?= joplin
CONTAINER_NAME ?= joplin

# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# Build the container
build: ## Build the container
	docker build --rm -t $(IMAGE_NAME) .

build-nc: ## Build the container without caching
	docker build --rm --no-cache -t $(IMAGE_NAME) .

run: ## Run container
	mkdir -p $(DIR)/data
	docker run -it --rm --name $(CONTAINER_NAME) \
	-v $(DIR)/data:/home/node/.config/joplin/ \
	$(IMAGE_NAME):$(VERSION)

stop: ## Stop a running container
	docker stop $(CONTAINER_NAME)

remove: ## Remove a (running) container
	docker rm -f $(CONTAINER_NAME)

remove-image-force: ## Remove the latest image (forced)
	docker rmi -f $(IMAGE_NAME):$(VERSION)

