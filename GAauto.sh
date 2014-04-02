#!/usr/bin/env bash
# Author: Lilian BESSON
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Website: https://bitbucket.org/lbesson/home/src/master/bin/GAauto.sh
# Date: 28-02-2013
#
# A small script to add a one-pixel beacon image to every HTML files in a directory.
# Requires: AddGA.sh (http://besson.qc.to/bin/AddGA.sh)
#

clear

# Put here the default values for these variables
# h: domain name (mysite.com for instance)
# c: path corresponding to root of the website (/var/web/ or /home/superman/Public/ for instance
# key: your Google Analytics key (UA-461468-3 for instance)
#
h="localhost"
c="/"
key="UA-38514290-1"

# You can make a case analysis here, to be able the run the same script on different servers.
case "$HOSTNAME" in
	*jarvis*)
		h="jarvis"
		c="${PWD#/home/lilian/}"
		c="${c#Public}"
		;;
	*zamok*)
		h="perso.crans.org/besson/"
		key="UA-38514290-1"
		c="${PWD#/home/besson/}"
		c="${c#www}"
		;;
	*ssh*)
		h="www.dptinfo.ens-cachan.fr/~lbesson/"
		key="UA-38514290-2"
		c="${PWD#/import/lbesson/}"
		c="${c#public_html}"
		;;
	esac;

# Starting.
echo -e "${yellow}.: Lilian Besson presents :."
echo -e "${cyan}Adding Google Analytics beacon every where, v0.1${reset}"

echo -e "Working on the domain '${red}$h${white}' with default path '${red}$c${white}',"

n=$(find . -type f -iname '*'.html | wc -l)

echo -e "There is '${red}$n${white}' readable file(s) in the current dir, is that ok ? (it might take some time...)"
read -e -p "Continue ? [Ctrl+C to cancel now or after]"

find . -type f -iname '*'.html -exec AddGA.sh "$@" "${key}" "${c}" {} \; \
 | tee ~/GAauto.log \
 && echo -e "DONE :)" \
 || echo -e "ERROR :("