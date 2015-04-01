#!/usr/bin/env bash
# author: Lilian BESSON
# email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# date: 01-05-2015.
# web: https://bitbucket.org/lbesson/bin/src/master/rename_dirname.sh
#
# Rename every picture in a directory based on the name of directory (not recursive).
#
# Note: Will ask confirmation before doing it.
# 
# Example: rename_dirname.sh pdf
# Example: rename_dirname.sh JPG
#  will rename each PDF or JPEG file in the current dir.
#
# Licence: GPLv3 (http://perso.crans.org/besson/LICENSE.html)
#

ext="${1:-JPG}"

smallext="$( echo "${ext}" | tr A-Z a-z )"
destext="${2:-$smallext}"

echo -e "${yellow}rename_dirname.sh${white} working with the extension ${red}${ext}${white} ${yellow}and the destination extension ${red}${destext}${white}."

namedir="$( smoothnameone.sh "$(basename "$(pwd)")" )"
echo -e "${magenta}Working in the directory ${white}${u}${namedir}${reset}.${white}"

nb=$( find . -maxdepth 1 -iname '*'."${ext}" | wc -l )
echo -e "${blue}I found ${u}${nb}${U} file(s) of this extension ${ext}.${white}"

declare -i n

# First we print what will be executed
echo -e "${green}I am showing you the operations I want to do:${white}"

n=0
for myfile in $( find . -maxdepth 1 -iname '*'."${ext}" ); do
    n=n+1
    dest="${namedir}__${n}.${destext}"
    if [ -f "${dest}" ]; then
        echo -e "${red}The destination file ${u}${dest}${U} already exists, we move it to /tmp/.${white}"
        echo mv -vf "${dest}" /tmp/
    fi
    echo mv -vi "${myfile}" "${dest}"
done

echo -e "${green}Are you happy about these operations?${white}"
echo "Enter to continue, Ctrl+C to exit now "
read || exit

echo -e "${blue}OK? Lets go :)${white}"

n=0
for myfile in $( find . -maxdepth 1 -iname '*'."${ext}" ); do
    n=n+1
    dest="${namedir}__${n}.${destext}"
    if [ -f "${dest}" ]; then
        echo -e "${red}The destination file ${u}${dest}${U} already exists, we move it to /tmp/.${white}"
        mv -vf "${dest}" /tmp/
    fi
    mv -vi "${myfile}" "${dest}"
done

echo -e "${green}Done :)${white}"
