
.PHONY: \
	ping \
	requirements.yml \
	up \
	# End of PHONY

ping:
	ansible -m ping all
# default is above

requirements.yml:
	ansible-galaxy install -r "requirements.yml"
up:
	vagrant up
provision:
	vagrant provision
