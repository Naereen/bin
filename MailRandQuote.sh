#!/usr/bin/env bash
# Author: Lilian BESSON
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Web version: http://besson.qc.to/bin/MailRandQuote.sh
# Web version (2): https://bitbucket.org/lbesson/home/src/master/bin/MailRandQuote.sh
# Date: 10-03-2013
#
# A small script to do send one random quote, by email. Can easily be automatized,
# with gnome-schedule for example. My computer is sending a random quote every hour ;)
#
# Requires: .quotes.txt (http://besson.qc.to/bin/.quotes.txt)
# Requires: mail_html.py (http://besson.qc.to/bin/mail_html.py)

echo -e "${clear}${yellow}.: Lilian Besson presents :."
echo -e "${cyan}MailRandQuote.sh, v1.0${reset}"

quotes="${quotes:-$HOME/.quotes.txt}"
echo -e "${black}Using $quotes to look for quotes.${reset}"

randquote () 
{ 
    if [ -f "$quotes" ]; then
        shuf "$quotes" | head -n 1;
    else
        if [ -f "$HOME/motd" ]; then
            cat ~/motd;
        else
            echo -e "No citation, ~/motd is not there, and \$quotes is not set.";
        fi;
    fi
}

MailRandQuote () {
##	/home/lilian/bin/mail_html.py
##	$HOME/bin/mail_html.py
	quote=$(randquote)
	content="<big><b>`echo $quote | sed s_'--'_'</b>--\n<i>'_`</i></big>"
	( $HOME/bin/mail_html.py "$content" "RandQuote" "$@" && date \
	 && notify-send "MailRandQuote" \
	) 2>&1 | tee $(tempfile)
}

MailRandQuote "$@"
