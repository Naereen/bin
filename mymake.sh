#!/usr/bin/env bash
# Author: Lilian BESSON, (C) 2015-oo
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Date: 11-08-2016.
# Web: https://bitbucket.org/lbesson/bin/src/master/mymake.sh
#
# A top-recursive 'make' command.
#
# Usage: mymake.sh ARG1 ARG2 ...
# A better make command, which goes up in the folder, until it finds a valid Makefile file.
#
# Licence: MIT Licence (http://lbesson.mit-license.org).
#
# DONE: Improved mymake.sh to keep looking recursively in the parent folder if a rule is not found in the current Makefile
# https://bitbucket.org/lbesson/bin/issues/4/improve-mymakesh-to-keep-looking
#
version="0.4"
returncode="0"

# More details at http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o pipefail
# Use https://bitbucket.org/lbesson/bin/src/master/.color.sh to add colors in Bash scripts
. ~/.color.sh

# options
NOANSI='false'
JUSTVERSION='false'
JUSTBASHCOMPLETION='false'

LOGFILE="$(tempfile)"
mv "${LOGFILE}" "${LOGFILE}_mymake.log"
LOGFILE="${LOGFILE}_mymake.log"

# Try to detect automatically the location of the make binary
MAKEPATH="$(type make | awk ' { print $3 } ')"
# But if it failed, use the default one
MAKEPATH="${MAKEPATH:-/usr/bin/make}"

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
        -npq )
            #"${MAKEPATH}" "$@"
            #exit $?
            JUSTBASHCOMPLETION='true'
        ;;
    esac
done

# Copyrights
echo -e "${cyan}$(basename "$0") v${version} : copyright (C) 2016 Lilian Besson${white}" #>/dev/stderr
if [ "X${JUSTVERSION}" = "Xtrue" ]; then
    echo -e "  ${black}You can find it online (https://bitbucket.org/lbesson/bin/src/master/mymake.sh)${white}" #>/dev/stderr
    echo -e "  ${black}This is free software, and you are welcome to redistribute it under certain conditions.${white}" #>/dev/stderr
    echo -e "  ${black}This program comes with ABSOLUTELY NO WARRANTY; for details see http://lbesson.mit-license.org${white}" #>/dev/stderr
    "${MAKEPATH}" --version
    exit 1
fi

# The big loop: as long as we fail because there is no valid rule, go up
FailBecauseNoValidRule=true
while [ "X$FailBecauseNoValidRule" = "Xtrue" ]; do
    FailBecauseNoValidRule=false
    # Second loop: a long as there is no valid 'Makefile' file, go up
    old="$(pwd)/"
    xtitle "make $* - (in ${old})"
    echo -e "Looking for a valid ${magenta}Makefile${white} from ${blue}${old}${white} :"
    c=""
    while [ ! -f "${old}${c}Makefile" ]; do
        echo -e "${red}${old}${c}Makefile${white} is not there, going up in the parent folder ..."
        c="../${c}"
        cd "${c}"
        [ "${PWD}" = "/" -o "${PWD}" = "${HOME}" ] && break  # DEBUG avoid infinite loops!
    done
    # We found a valid Makefile or we already called 'break'...
    nameofmakefile="$(readlink -f "${old}${c}Makefile")"  # Find his real name
    # Now using it to execute make
    if [ -f "${old}${c}Makefile" ]; then
        echo -e "${green}${nameofmakefile}${white} is there, I'm using it :"
        echo -e "Calling... ${black}'" time /usr/bin/make -w --file="${nameofmakefile}" "$@" "'${white}..."
        time "${MAKEPATH}" -w --file="${nameofmakefile}" "$@" \
            2>&1 | tee "${LOGFILE}"
        returncode="$?"
        # No notifications if make has been called by the bash auto-completion function (options '-npq -C'...)
        if [ "X${JUSTBASHCOMPLETION}" != "Xtrue" ]; then
	   if [ "X${returncode}" = "X0" ]; then
               notify-send --icon=terminal 'mymake.sh' "make '$*', succeed in the folder '$(readlink -f "${old}${c}")' :-)"
	   else
	       notify-send --icon=error 'mymake.sh' "make '$*', failed in the folder '$(readlink -f "${old}${c}")' ..."
	   fi
	fi
        # XXX This is very specific, maybe there is a better way to detect it ?
        # Not with the returned error code of /usr/bin/make at least...
        grep 'make: \*\*\* No rule to make target' "${LOGFILE}" &>/dev/null
        if [[ "X$?" = "X0" ]]; then
            echo -e "${red}Failed because there is no rule${white} to make the target '${yellow}$@${white}' in the current Makefile (${green}${nameofmakefile}${white}) ..."
            FailBecauseNoValidRule=true
            c="../${c}"
            cd "${c}"
            echo -e "${magenta}Going up in the parent folder...${white} Current directory: $(pwd)"
            # [ "${PWD}" = "/" -o "${PWD}" = "${HOME}" ] && break  # DEBUG avoid infinite loops!
        else
            # echo "The rule was found."
            cd "${old}"
        fi
    else
        # If we did not find any valid Makefile
        echo -e "${red}${nameofmakefile} is not there and I'm in '/' or '${HOME}'... I cannot go up anymore${white}"
        cd "${old}"
        exit 3
    fi
done

exit "${returncode}"
# End of mymake.sh
