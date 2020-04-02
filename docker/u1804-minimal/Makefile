IMAGE_NAME ?= ngenetzky/u1804
CONTAINER_NAME ?= ngenetzky/u1804
VERSION ?= latest

################################################################################
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
################################################################################

.PHONY: help
.DEFAULT_GOAL := help

# Build the container
build: ## Build the container
	docker build -t "$(IMAGE_NAME):$(VERSION)" ./

run: ## Run container
	docker run -it "$(IMAGE_NAME):$(VERSION)" /bin/bash -l
bash: ## Run container
	docker run -it "$(IMAGE_NAME):$(VERSION)" /bin/bash -l
zsh: ## Run container
	docker run -it "$(IMAGE_NAME):$(VERSION)" /usr/bin/zsh -l

stop: ## Stop a running container
	docker stop $(CONTAINER_NAME)

remove: ## Remove a (running) container
	docker rm -f $(CONTAINER_NAME)

remove-image-force: ## Remove the latest image (forced)
	docker rmi -f $(IMAGE_NAME):$(VERSION)

