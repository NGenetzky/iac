# Makefile

################################################################################
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
################################################################################

.PHONY: help
.DEFAULT_GOAL := help

#
# docker-compose passthrough targets
#

build: ## docker-compose build # Build the images
	docker-compose $@
up: ## docker-compose up # Start up the containers
	docker-compose $@
stop: ## docker-compose stop # Stop running containers
	docker-compose $@
rm: ## docker-compose rm # Remove (running) containers
	docker-compose $@
ps: ## docker-compose ps # List containers 
	docker-compose $@

#
# docker-compose targets
#

DOCKER_SERVICE_NAME="main"
console: ## Start bash login shell in new container
	docker-compose run \
		--entrypoint "/bin/bash" \
		"$(DOCKER_SERVICE_NAME)" \
		-l
enter: ## Start bash login shell in existing container
	docker-compose exec \
		"$(DOCKER_SERVICE_NAME)" \
		"/bin/bash" -l

#
# aliases
#

remove: rm ## Remove (running) containers
clean: rm ## clean. Clean up

