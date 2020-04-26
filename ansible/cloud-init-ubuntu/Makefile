# Makefile

################################################################################
# util-makefile
####

SHELL := /bin/bash
# The directory of this Makefile
DIR := $(shell echo $(shell cd "$(shell  dirname "${BASH_SOURCE[0]}" )" && pwd ))

# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Show Makefile help message
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.PHONY: help

.DEFAULT_GOAL := help
####
# util-makefile
################################################################################

################################################################################
# docker-compose-makefile
#
# References:
# - https://github.com/krom/docker-compose-makefile
####

#
# constants
#
DOCKER_COMPOSE := docker-compose
DOCKER_COMPOSE_FILE := $(DIR)/docker-compose.yml
C_SINGLE_DEFAULT=main

#
# arguments
#

## c=<name> or if c='' then all services
c :=
c_single := $(if $(c),$(c),$(C_SINGLE_DEFAULT))

## u='--user UID:GID' or if u='' then use user set by image.
# u := --user '$(shell id -u):$(shell id -g)'
u := 

#
# targets
#

.PHONY: console
console: ## Start bash login shell in new container
	docker-compose run \
		--entrypoint '/bin/sh' \
		$(u) \
		$(c_single) \
		-l

.PHONY: enter
enter: ## Start bash login shell in existing container
	docker-compose exec \
		$(u) \
		$(c_single) \
		'/bin/sh' -l

.PHONY: build
build: ## Build or rebuild all services or c=<name> service
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) build

.PHONY: rm
rm: ## Remove stopped containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) rm

.PHONY: config
config: ## Validate and view the Compose file
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) config

####
# docker-compose-makefile
################################################################################

################################################################################
# ansible-playbook makefile
#
####

ANSIBLE_PLAYBOOK := docker-compose run --rm $(u) -v "$(DIR):/ansible/playbooks" $(c_single)

## pb='playbook' or default to pb='main.yml'
pb := main.yml

playbook: ## Execute playbook inside docker
	@$(ANSIBLE_PLAYBOOK) $(pb)
.PHONY: playbook