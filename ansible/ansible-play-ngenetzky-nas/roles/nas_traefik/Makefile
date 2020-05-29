# Makefile

################################################################################
# util-makefile
####

SHELL := /bin/bash
DIR := $(shell echo $(shell cd "$(shell  dirname "${BASH_SOURCE[0]}" )" && pwd ))

# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Show Makefile help message
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.PHONY: help

####
# util-makefile
################################################################################

.DEFAULT_GOAL := help

################################################################################
# ansible roles with docker
####

VENV := ${DIR}/../../build/virtualenv/
ANS_PLAY := ${VENV}/bin/ansible-playbook

lint: ## syntax check and ansible-lint playbook
	${ANS_PLAY} --syntax-check playbooks/*
	${VENV}/bin/ansible-lint --exclude build/ playbooks/*
.PHONY: lint

up_plan: ## playbook 'up.yml' dry-run
	${ANS_PLAY} -CD playbooks/up.yml
.PHONY: up_plan

up: ## playbook 'up.yml'
	${ANS_PLAY} -D playbooks/up.yml
.PHONY: up


# Possible list of possible targets.

# up: ## Start all or c=<name> containers in foreground
# start: ## Start all or c=<name> containers in background
# stop: ## Stop all or c=<name> containers
# status: ## Show status of containers
# restart: ## Restart all or c=<name> containers
# logs: ## Show logs for all or c=<name> containers
# ps: status ## Show status of containers
# remove: rm ## Remove stopped containers
# .PHONY: rm
# rm: ## Remove stopped containers

####
# ansible roles with docker
################################################################################
