# Makefile to send this to Zam
SHELL=/usr/bin/env /bin/bash

all:	signs send

send:	send_bashs send_zamok
send_zamok:
	CP-git ./ ${Szam}bin/
	# CP --cvs-exclude --exclude=.*log --exclude=.git --exclude-from=.gitignore ./ ${Szam}bin/

send_bashs:	signs
	CP-git --cvs-exclude ~/bin/.bash{rc,_aliases}* ~/
	# CP --cvs-exclude ~/bin/.bash{rc,_aliases}* ${Szam}bin/

signs:	sign_bashrc sign_bashalias
sign_bashrc:
	gpg --armor --detach-sign --yes --no-batch --use-agent .bashrc
sign_bashalias:
	gpg --armor --detach-sign --yes --no-batch --use-agent .bash_aliases
