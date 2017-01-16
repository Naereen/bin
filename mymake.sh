#!/usr/bin/env bash
# Author: Lilian BESSON, (C) 2015-oo
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Date: 06-11-2016.
# Web: https://bitbucket.org/lbesson/bin/src/master/mymake.sh
#
# A top-recursive 'make' command, with two awesome behaviors.
#
# Usage: mymake.sh ARG1 ARG2 ...
#   - A better make command, which goes up in the folder, until it finds a valid Makefile file.
#   - Additionally, it keeps looking as long as no rule has been found.
#   - An optional --FreeSMS option can be given, in which case a text message is sent when a job failed or succeed (like the notification)
#   - If the file ~/.use_FreeSMS_for_mymake is present, the option is turned on by default
#
# Licence: MIT Licence (http://lbesson.mit-license.org).
#
version="1.0"
returncode="0"  # If success, return 0
datestarting="$(date "+%T the %D")"

# More details at http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o pipefail
# Use https://bitbucket.org/lbesson/bin/src/master/.color.sh to add colors in Bash scripts
[ -f ~/.color.sh ] && . ~/.color.sh

# options
JustVersion="false"
JustBashCompletion="false"
Use_FreeSMS="false"
if [ -f ~/.use_FreeSMS_for_mymake ]; then
    echo -e "The file '${black}~/.use_FreeSMS_for_mymake${white}' has been found, turning on the option ${cyan}--FreeSMS${white} ..."
    Use_FreeSMS="true"
fi

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
        --FreeSMS )
            Use_FreeSMS="true"
            shift
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

# Do we need to turn down the FreeSMS plugin ?
if [ "X${Use_FreeSMS}" = "Xtrue" ]; then
    if type FreeSMS.py &>/dev/null; then
        echo -e "${cyan}Option '--FreeSMS' was found, and the program 'FreeSMS.py' is present : OK ...${white}"
    else
        Use_FreeSMS="false"
        echo -e "${red}Option '--FreeSMS' was found, but the program 'FreeSMS.py' is not present : I am disabling the FreeSMS option ...${white}"
    fi
fi

# Working variables
LogFile="$(tempfile)"
mv -f -- "${LogFile}" "${LogFile}_mymake.log"
LogFile="${LogFile}_mymake.log"

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
    xtitle "make $* - (in ${old})"  # set terminal title
    echo -e "Looking for a valid ${magenta}Makefile${white} from ${blue}${old}${white} :"
    c=""
    while [ ! -f "${old}${c}Makefile" ]; do  # No file
        echo -e "${red}${old}${c}Makefile${white} is not there, going up in the parent folder ... Current directory: $(pwd)"
        c="../${c}"
        cd ..
        # DEBUG avoid infinite loops!
        [ "$(pwd)" = "/" -o "$(pwd)" = "${HOME}" ] && break
    done
    # We found a valid Makefile or we already called 'break'...
    NameOfMakefile="$(readlink -f "${old}${c}Makefile")"  # Find his real name, e.g. simplies fake/bar/foo/../.. to fake/

    # Now using it to execute make
    if [ -f "${old}${c}Makefile" ]; then
        echo -e "${green}${NameOfMakefile}${white} is there, I'm using it :"
        echo -e "Calling... ${black}'" time /usr/bin/make -w --file="${NameOfMakefile}" "$@" "'${white}..."
        if [ "X${JustBashCompletion}" != "Xtrue" ]; then
            time "${makePath}" -w --file="${NameOfMakefile}" "$@" \
                3>&1 1>&2 2>&3 \
                | tee "${LogFile}"
            # FIXED this pipe disabled color on stdout of programs that detect pipes (sphinx, my ansicolortags script, grep etc...)
            # This trick '3>&1 1>&2 2>&3' swaps stdout and stderr: only stderr is piped to |tee so colors are still in stdout (from https://serverfault.com/a/63708)
        else
            time "${makePath}" -w --file="${NameOfMakefile}" "$@" \
                2>&1 | tee "${LogFile}"
        fi
        returncode="$?"
        datefinished="$(date "+%T the %D")"

        # XXX This is very specific, maybe there is a better way to detect it ?
        # Not with the returned error code of /usr/bin/make at least...
        grep 'make: \*\*\* No rule to make target' "${LogFile}" &>/dev/null
        grepReturnCode="$?"
        if [[ "X${grepReturnCode}" = "X0" ]]; then
            echo -e "${red}Failed because there is no rule${white} to make the target '${yellow}$*${white}' in the current Makefile (${green}${NameOfMakefile}${white}) ..."
            [ "$(pwd)" = "/" -o "$(pwd)" = "${HOME}" ] && break  # avoid infinite loops!
            FailBecauseNoValidRule="true"
            c="../${c}"
            cd ..  # FIXED We should just go up once.
            echo -e "${magenta}Going up in the parent folder...${white} Current directory: $(pwd)"
            # [ "$(dirname $(pwd))" = "/" ] && break  # DEBUG avoid infinite loops!
        else
            # No notifications if make was called by the bash auto-completion function (options '-npq -C'...) or if it failed because no rule
            if [ "X${JustBashCompletion}" != "Xtrue" ]; then
                if [ "X${returncode}" = "X0" ]; then
                    notify-send --icon=terminal "$(basename "$0") v${version}" "make on <i>'$*'</i>  <b>worked</b>, in the folder <i>'$(readlink -f "${old}${c}")'</i> from <i>'$(readlink -f "${OriginalPath}")'</i> <b>:-)</b>"
                    if [ "X${Use_FreeSMS}" = "Xtrue" ]; then
                        FreeSMS.py "[SUCCESS] make on '$*' *worked*, in the folder '$(readlink -f "${old}${c}")' :-)\\n\\n- Job started at '${datestarting}', finished at '${datefinished}'.\\n\\n- Sent by $(basename "$0") v${version}, using FreeSMS.py by Lilian Besson."
                    fi
                else
                    notify-send --icon=error "$(basename "$0") v${version}" "make on <i>'$*'</i>  <b>failed</b>, in the folder <i>'$(readlink -f "${old}${c}")'</i> from <i>'$(readlink -f "${OriginalPath}")'</i> ..."
                    if [ "X${Use_FreeSMS}" = "Xtrue" ]; then
                        FreeSMS.py "[FAILURE] make on '$*' *failed*, in the folder '$(readlink -f "${old}${c}")' :-(\\n\\n- Job started at '${datestarting}', finished at '${datefinished}'.\\n\\n- Sent by $(basename "$0") v${version}, using FreeSMS.py by Lilian Besson."
                    fi
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
