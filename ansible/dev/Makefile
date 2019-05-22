
PLAY=ansible-playbook
# PLAY=ansible-playbook --check

.PHONY: \
	bootstrap \
	ping \
	playbooks/desktop-developer.yml \
	requirements.yml \
	Z_LAST_PHONY # So the lines above can all end with backslash

bootstrap:
	ansible-playbook -K playbooks/bootstrap.yml
ping:
	ansible -m ping all

playbooks/desktop-developer.yml:
	${PLAY} -K \
		playbooks/desktop-developer.yml
