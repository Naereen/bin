#!/usr/bin/env bash
# Author: Lilian BESSON, (C) 2016-oo
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Date: 10-02-2016.
# Web: https://bitbucket.org/lbesson/bin/src/master/git-blame-last-commit.sh
#
# List the lines modified bthe last commit of a git repository.
#
# Usage: git-blame-last-commit.sh [FILES]
#
# Licence: MIT Licence (http://lbesson.mit-license.org).
version="0.1"

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
# set -euo pipefail
. ~/.color.sh

# Add here options
NOANSI='false'
JUSTVERSION='false'
for i in "$@"; do
    case "$i" in
        --noansi )
            NOANSI='true'
            . ~/.nocolor.sh
            shift
            ;;
        --version )
            JUSTVERSION='true'
            shift
            ;;
    esac
done

# Copyrights and options
echo -e "${green}$0 v${version} : copyright (C) 2016 Lilian Besson"
echo -e "You can find it online (https://bitbucket.org/lbesson/bin/src/master/git-blame-last-commit.sh)"
echo -e "This is free software, and you are welcome to redistribute it under certain conditions."
echo -e "This program comes with ABSOLUTELY NO WARRANTY; for details see http://lbesson.mit-license.org${white}"
[ "X${JUSTVERSION}" = "Xtrue" ] && exit 0


# Requires git-extras
echo -e "\n${magenta}Working in the git repository${white}${u}$(git summary | grep project)${U}."
# Find the 8-car hash of the last commit
commitid="$(git log|head -n1|less|sed 's/commit //'| sed -r "s:\x1B\[[0-9;]*[mK]::g")"
# Show the blame
git blame "$*" | grep --color=always "${commitid:0:8}" | less -r

# This is better
echo -e "\n\n${black}Using ${green}'git show HEAD'${black}:${white}"
# git show HEAD | less -r
git show HEAD


# End of git-blame-last-commit.sh
