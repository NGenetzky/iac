.PHONY: \
	bootstrap \
	ping \
	Z_LAST_PHONY # So the lines above can all end with backslash

bootstrap:
	ansible-playbook -K playbooks/bootstrap.yml
ping:
	ansible -m ping all
