# Makefile to send this to Zam
SHELL=/usr/bin/env /bin/bash

all:	signs bin bin.zip

bin:
	cd ~ ; make bin
bin.zip:
	cd ~ ; make bin.zip

send:	send_zamok
send_zamok:
	CP --exclude=.git ./ ${Szam}bin/

signs:
	gpg --armor --detach-sign --yes --no-batch --use-agent .bashrc
	gpg --armor --detach-sign --yes --no-batch --use-agent .bash_aliases
