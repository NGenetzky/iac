################################################################################
# util-makefile
####

# Force shell to bash. Get path to parent directory of this file.
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
# vagrant
####

validate:  ## validates the Vagrantfile
	vagrant validate
lint:  validate ## validates the Vagrantfile
.PHONY: validate lint

up:  ## starts and provisions the vagrant environment
	vagrant up --provider=libvirt
.PHONY: up

provision: ## provisions the vagrant machine
	vagrant provision
.PHONY: provision

ssh: ## connects to machine via SSH
	vagrant ssh
enter: ssh ## connects to machine via SSH
.PHONY: ssh enter

suspend: ## suspends the machine
	vagrant suspend

destroy: ## stops and deletes all traces of the vagrant machine
	vagrant destroy
rm: destroy ## stops and deletes all traces of the vagrant machine
.PHONY: destroy rm

####
# vagrant
################################################################################