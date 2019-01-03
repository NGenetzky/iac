#!/bin/bash

# default
python --version > python-version.txt 2>&1
pip freeze --user > pip-user.requirements.txt
pip freeze > pip.requirements.txt

# 2
python2 --version > python2-version.txt 2>&1
pip2 freeze --user > pip2-user.requirements.txt
pip2 freeze > pip2.requirements.txt

# 3
python3 --version > python3-version.txt 2>&1
pip3 freeze --user > pip3-user.requirements.txt
pip3 freeze > pip3.requirements.txt
