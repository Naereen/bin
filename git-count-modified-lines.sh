#!/usr/bin/env bash
# Minimalist script to print the number of new and deleted lines of every modified files in a git repository
# It helps to know how big the changes are before commiting them...
#
# (C) Lilian BESSON
# http://perso.crans.org/besson/bin/git-count-modified-lines.sh

# Are we in a git repo?
git rev-parse --is-inside-work-tree &>/dev/null
if [[ $? != 0 ]]; then
    echo -e "${red}Not a git repository.${white}"
    exit 1
fi

prefix="$(git rev-parse --show-prefix)"
p="$(pwd)/"
maingit="${p%$prefix}"

cd "${maingit}" &>$null

# Start
echo -e "${yellow}${u}Modified files${U} in this git repository ...${white}"
files=$(git status --porcelain | grep '^ \?MM\?' | sed s/'^ \?MM\? '/''/)

for f in $files; do
    if [ -f "$f" ]; then
        echo -e "  ${f}"
    fi
done

for f in $files; do
    if [ -f "$f" ]; then
        echo -e "\n${blue}For the file${white} '${black}${u}${f}${U}${white}' :"

        nbplus=$(git diff --no-color -- "$f" | cat | grep -o '^+' | wc -l)
        echo -e "  + ${green}${nbplus}${white} ${magenta}new lines${white} ..."

        nbminus=$(git diff --no-color -- "$f" | cat | grep -o '^-' | wc -l)
        echo -e "  - ${red}${nbminus}${white} ${cyan}deleted lines${white} ..."
    fi
done

cd "${p}" &>$null
echo -e "${reset}${white}"
