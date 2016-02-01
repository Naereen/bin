#!/usr/bin/env bash
# Author: Lilian BESSON, (C) 2015-oo
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Date: 12-01-2016.
# Web: https://bitbucket.org/lbesson/bin/src/master/mymake.sh
#
# A top-recursive 'make' command.
#
# Usage: mymake.sh ARG1 ARG2 ...
# A better make command, which goes up in the folder, until it finds a valid Makefile file.
#
# Licence: MIT Licence (http://lbesson.mit-license.org).
version="0.2"

# More details at http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
# Use https://bitbucket.org/lbesson/bin/src/master/.color.sh to add colors in Bash scripts
. ~/.color.sh

# Add here options
NOANSI='false'
JUSTVERSION='false'
MAKEPATH='/usr/bin/make'

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
echo -e "${cyan}$(basename "$0") v${version} : copyright (C) 2016 Lilian Besson${white}" >/dev/stderr
echo -e "${black}You can find it online (https://bitbucket.org/lbesson/bin/src/master/mymake.sh)${white}" >/dev/stderr
echo -e "${black}This is free software, and you are welcome to redistribute it under certain conditions.${white}" >/dev/stderr
echo -e "${black}This program comes with ABSOLUTELY NO WARRANTY; for details see http://lbesson.mit-license.org${white}" >/dev/stderr
[ "X${JUSTVERSION}" = "Xtrue" ] && exit 1


# The function
old="$(pwd)/"
xtitle "make $* - (in ${old})"
echo -e "Looking for a valid ${magenta}Makefile${white} from ${blue}${old}${white} :"
c=""
while [ ! -f "${old}${c}Makefile" ]; do
    echo -e "${red}${old}${c}Makefile${white} is not there, going up ..."
    c="../${c}"
    cd "${c}"
    [ "$(pwd)" = "/" ] && break
done

# New using it to execute make
if [ -f "${old}${c}Makefile" ]; then
    echo -e "${green}${old}${c}Makefile${white} is there, I'm using it :"
    echo -e "Calling... ${black}'" time /usr/bin/make -w --file="${old}${c}Makefile" "$@" "'${white}..."
    echo -e "Then if success calling... ${black}'" notify-send --icon=make 'mymake.sh' "\"make '$*', done in the folder '${old}${c}.\"" "'${white}..."
    # read  # DEBUG
    time "${MAKEPATH}" -w --file="${old}${c}Makefile" "$@" && \
        notify-send --icon=make 'mymake.sh' "make '$*', done in the folder '${old}${c}."
    cd "${old}"
else
    cd "${old}"
    echo -e "${red}${old}${c}Makefile${white} is not there and I'm in '/'... I cannot go up anymore"
    return 2
fi

# End of mymake.sh
