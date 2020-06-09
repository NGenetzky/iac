
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

cloudinitsrc: cloud-init/meta-data cloud-init/user-data

# sudo apt-get install genisoimage
mkisofs: cloudinitsrc
	mkisofs \
		-joliet -rock \
		-volid "cidata" \
		-output cloud-init.iso \
			cloud-init/meta-data \
			cloud-init/user-data
.PHONY: mkisofs

# sudo apt install cloud-image-utils
cloud-localds: cloudinitsrc
	cloud-localds --verbose \
		cloud-init.iso \
		cloud-init/user-data \
		cloud-init/meta-data
.PHONY: cloud-localds

# TODO: Not sure if any advantage of one or the other.
iso: cloud-localds ## Create iso for cloud-init
.PHONY: iso

####
# cloud-init
################################################################################