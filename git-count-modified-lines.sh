#!/usr/bin/env bash
# Minimalist script to print the number of new and deleted lines of every modified files in a git repository
# It helps to know how big the changes are before commiting them...
#
# (C) Lilian BESSON
# http://perso.crans.org/besson/bin/git-count-modified-lines.sh

echo -e "${yellow}${u}Modified files${U} in this git repository ...${white}"
git status --porcelain | grep '^ \?M' | sed s/'^ \?M '/'  '/

files=$(git status --porcelain | grep '^ \?M' | sed s/'^ \?M '/''/)

for f in $files; do
    echo -e "\n${blue}For the file${white} '${black}${u}${f}${U}${white}' :"

    nbplus=$(git diff --no-color | cat | grep -o '^+' | wc -l)
    echo -e "  + ${green}${nbplus}${white} ${magenta}new lines${white} ..."

    nbminus=$(git diff --no-color | cat | grep -o '^-' | wc -l)
    echo -e "  - ${red}${nbminus}${white} ${cyan}deleted lines${white} ..."
done

echo -e "${reset}${white}"
