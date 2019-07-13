
PLAY=ansible-playbook
# PLAY=ansible-playbook --check
LIMIT=dev

.PHONY: \
	bootstrap \
	ping \
	playbooks/desktop-developer.yml \
	playbooks/user-ngenetzky.yml \
	requirements.yml \
	Z_LAST_PHONY # So the lines above can all end with backslash

ping:
	ansible -m ping $(LIMIT)
requirements.yml:
	ansible-galaxy install -r 'requirements.yml'

playbooks/bookstrap.yml:
	${PLAY} -K \
		--limit $(LIMIT) \
		playbooks/bootstrap.yml
playbooks/desktop-developer.yml:
	${PLAY} -K \
		--limit $(LIMIT) \
		playbooks/desktop-developer.yml
playbooks/user-ngenetzky.yml:
	${PLAY} -K \
		--limit $(LIMIT) \
		playbooks/user-ngenetzky.yml
