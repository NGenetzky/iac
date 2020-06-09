
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
# cloud-init
####

cloud-init: cloud-init/meta-data cloud-init/user-data

# sudo apt-get install genisoimage
nocloud.iso: cloud-init ## Create iso for cloud-init
	mkisofs \
		-joliet -rock \
		-volid "cidata" \
		-output nocloud.iso \
			cloud-init/meta-data \
			cloud-init/user-data

####
# cloud-init
################################################################################