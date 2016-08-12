#!/usr/bin/env bash
# Author: Lilian BESSON, (C) 2015-oo
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Date: 12-08-2016.
# Web: https://bitbucket.org/lbesson/bin/src/master/mymake.sh
#
# A top-recursive 'make' command, with two awesome behaviors.
#
# Usage: mymake.sh ARG1 ARG2 ...
#   - A better make command, which goes up in the folder, until it finds a valid Makefile file.
#   - Additionally, it keeps looking as long as no rule has been found.
#
# Licence: MIT Licence (http://lbesson.mit-license.org).
#
#
version="0.7"
returncode="0"  # If success, return 0

# More details at http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o pipefail
# Use https://bitbucket.org/lbesson/bin/src/master/.color.sh to add colors in Bash scripts
. ~/.color.sh

# options
JustVersion="false"
JustBashCompletion="false"

for i in "$@"; do
    case "$i" in
        --noansi | --noANSI )
            . ~/.nocolor.sh
            shift
        ;;
        --version )
            JustVersion="true"
            shift
        ;;
        -npq )
            JustBashCompletion="true"
        ;;
    esac
done

# Copyrights
echo -e "${cyan}$(basename "$0") v${version} : copyright (C) 2016 Lilian Besson${white}"
if [ "X${JustVersion}" = "Xtrue" ]; then
    echo -e "  ${black}You can find it online (https://bitbucket.org/lbesson/bin/src/master/mymake.sh)${white}"
    echo -e "  ${black}This is free software, and you are welcome to redistribute it under certain conditions.${white}"
    echo -e "  ${black}This program comes with ABSOLUTELY NO WARRANTY; for details see http://lbesson.mit-license.org${white}"
    "${makePath}" --version
    exit 1
fi

# Working variables
LogFile="$(tempfile)"
mv "${LogFile}" "${LogFile}_mymake.log"
LogFile="${LogFile}_mymake.log"
# echo -e "DEBUG LogFile = ${LogFile}"

# Try to detect automatically the location of the make binary
makePath="$(type make | awk ' { print $3 } ')"
# But if it failed, use the default one
makePath="${makePath:-/usr/bin/make}"

OriginalPath="$(pwd)/"

# The big loop: as long as we fail because there is no valid rule, go up
FailBecauseNoValidRule="true"

while [ "X$FailBecauseNoValidRule" = "Xtrue" ]; do
    FailBecauseNoValidRule="false"
    # Second loop: a long as there is no valid 'Makefile' file, go up
    old="$(pwd)/"
    xtitle "make $* - (in ${old})"
    echo -e "Looking for a valid ${magenta}Makefile${white} from ${blue}${old}${white} :"
    c=""
    while [ ! -f "${old}${c}Makefile" ]; do
        echo -e "${red}${old}${c}Makefile${white} is not there, going up in the parent folder ... Current directory: $(pwd)"
        c="../${c}"
        cd ..  # FIXED We should just go up once.
        [ "$(pwd)" = "/" -o "$(pwd)" = "${HOME}" ] && break  # DEBUG avoid infinite loops!
    done
    # We found a valid Makefile or we already called 'break'...
    NameOfMakefile="$(readlink -f "${old}${c}Makefile")"  # Find his real name

    # Now using it to execute make
    if [ -f "${old}${c}Makefile" ]; then
        echo -e "${green}${NameOfMakefile}${white} is there, I'm using it :"
        echo -e "Calling... ${black}'" time /usr/bin/make -w --file="${NameOfMakefile}" "$@" "'${white}..."
        if [ "X${JustBashCompletion}" != "Xtrue" ]; then
            # Use this trick '3>&1 1>&2 2>&3' from http://serverfault.com/a/63708
            time "${makePath}" -w --file="${NameOfMakefile}" "$@" \
                3>&1 1>&2 2>&3 \
                | tee "${LogFile}"
            # FIXED this pipe disabled color on stdout of programs that detect pipes (sphinx, my ansicolortags script, grep etc...)
        else
            time "${makePath}" -w --file="${NameOfMakefile}" "$@" \
                2>&1 | tee "${LogFile}"
        fi
        returncode="$?"

        # XXX This is very specific, maybe there is a better way to detect it ?
        # Not with the returned error code of /usr/bin/make at least...
        grep 'make: \*\*\* No rule to make target' "${LogFile}" &>/dev/null
        grepreturncode="$?"
        if [[ "X${grepreturncode}" = "X0" ]]; then
            echo -e "${red}Failed because there is no rule${white} to make the target '${yellow}$*${white}' in the current Makefile (${green}${NameOfMakefile}${white}) ..."
            [ "$(pwd)" = "/" -o "$(pwd)" = "${HOME}" ] && break  # avoid infinite loops!
            FailBecauseNoValidRule="true"
            c="../${c}"
            cd ..  # FIXED We should just go up once.
            echo -e "${magenta}Going up in the parent folder...${white} Current directory: $(pwd)"
            # [ "$(dirname $(pwd))" = "/" ] && break  # DEBUG avoid infinite loops!
        else
            # No notifications if make has been called by the bash auto-completion function (options '-npq -C'...) or if it failed because no rule
            if [ "X${JustBashCompletion}" != "Xtrue" ]; then
                if [ "X${returncode}" = "X0" ]; then
                       notify-send --icon=terminal "$(basename "$0") v${version}" "make '$*' worked, in the folder '$(readlink -f "${old}${c}")' from '$(readlink -f "${OriginalPath}")' :-)"
                else
                   notify-send --icon=error "$(basename "$0") v${version}" "make '$*' failed ,in the folder '$(readlink -f "${old}${c}")' from '$(readlink -f "${OriginalPath}")' ..."
                fi
            fi
        fi
    else
        # If we did not find any valid Makefile
        echo -e "${red}${NameOfMakefile} is not there and I'm in '/' or '${HOME}'... I cannot go up anymore${white}"
        exit 3
    fi
done

exit "${returncode}"
# End of mymake.sh
