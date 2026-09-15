DEST ?= $(HOME)/git/iac-private
IMAGE ?= iac-private-init:latest

.PHONY: generate
generate:
	./generate.sh --dest "$(DEST)"

.PHONY: lint
lint:
	ansible-playbook generate.yml --syntax-check
	ansible-lint roles/iac_private_scaffold

.PHONY: docker-build
docker-build:
	docker build -t "$(IMAGE)" .
