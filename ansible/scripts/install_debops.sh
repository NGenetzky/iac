#!/bin/sh
sudo apt install build-essential python3-virtualenv virtualenv python3-dev \
	                 libffi-dev libssl-dev libsasl2-dev libldap2-dev python3-pip
pip3 install debops[ansible]==1.2.0
