#!/usr/bin/env bash
# Author: Lilian BESSON, (C) 2015-oo
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Date: 02-01-2016.
# Web: https://bitbucket.org/lbesson/bin/src/master/mymake.sh
#
# A better 'make' command.
#
# Usage: mymake.sh ARG1 ARG2 ...
# A better make command, which goes up in the folder, until it finds a valid Makefile file.
#
# Licence: MIT Licence (http://lbesson.mit-license.org).
version="0.1"

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

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

# Copyrights
echo -e "${green}$0 v${version} : copyright (C) 2016 Lilian BESSON"
echo -e "You can find it online (https://bitbucket.org/lbesson/bin/src/master/mymake.sh)"
echo -e "This is free software, and you are welcome to redistribute it under certain conditions."
echo -e "This program comes with ABSOLUTELY NO WARRANTY; for details see http://lbesson.mit-license.org${white}"
[ "X${JUSTVERSION}" = "Xtrue" ] && exit 1


# The function
old="$(pwd)/"
xtitle "make $@ - (in ${old})"
echo -e "Looking for a valid ${magenta}Makefile${white} from ${blue}${old}${white} :"
c=""
while [ ! -f "${old}${c}Makefile" ]; do
    echo -e "${red}${old}${c}Makefile${white} is not there, going up ..."
    c="../${c}"
    cd "$c"
    [ "$(pwd)" = "/" ] && break
done
if [ -f "${old}${c}Makefile" ]; then
    echo -e "${green}${old}${c}Makefile${white} is there, I'm using it :"
    /usr/bin/make -w --file="${old}${c}Makefile" "$@"
    cd "$old"
else
    cd "$old"
    echo -e "${red}${old}${c}Makefile${white} is not there and I'm in '/'... I cannot go up anymore"
    return 2
fi

# End of mymake.sh