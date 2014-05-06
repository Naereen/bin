#!/bin/bash
#	.bashrc for GNU Bash v4+
#	(c) 2011-2014 Lilian BESSON
#		ENS de Cachan & Cr@ns
#	http://www.dptinfo.ens-cachan.fr/~lbesson
#	http://perso.crans.org/besson
#		On Bitbucket:
#	http://bitbucket.org/lbesson/home/
#
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
#[ -z "$PS1" ] && return
# Pour les shells non interactif (sous emacs, avec rcp, ...)
# on ne charge pas le .bashrc
[ -z "$PS1" -o "$TERM" = dumb ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups
#:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend
# pour sauvegarder les commandes de plusieurs lignes (\ ) en une seule
# shopt -s cmdhist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000
# Memoriser le timestamp d'execution de la commande
export HISTTIMEFORMAT='%F %T - '

# Hack pour que $COLUMNS contienne le nombre de colonne du terminal
# Sinon, le prompt kikoo risque de deborder/etre trop court
COLUMNS=$(tput cols)
LINES=$(tput lines)
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

#-------------------------------------------------------------
# Automatic setting of $DISPLAY (if not set already)
# This works for linux - your mileage may vary.... 
# The problem is that different types of terminals give
# different answers to 'who am i'......
# I have not found a 'universal' method yet
#-------------------------------------------------------------

function get_xserver ()
{
    case $TERM in
        xterm )
            XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' ) 
            # Ane-Pieter Wieringa suggests the following alternative:
            # I_AM=$(who am i)
            # SERVER=${I_AM#*(}
            # SERVER=${SERVER%*)}

            XSERVER=${XSERVER%%:*}
            ;;
        aterm | rxvt)
        # find some code that works here.....
            ;;
    esac  
}

if [ -z ${DISPLAY:=""} ]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) ||
          ${XSERVER} == "unix" ]]; then
        DISPLAY=":0.0"          # Display on local host
    else                
        DISPLAY=${XSERVER}:0.0  # Display on remote host
    fi
fi

export DISPLAY

#---------------
# Some settings
#---------------
# Disable options:
shopt -u mailwarn
unset MAILCHECK       # I don't want my shell to warn me of incoming mail

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:h"
##export HISTIGNORE="&:bg:fg:ll:h:l:ls:la"

#-------------------------------------------------------------

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$> '
else
    PS1='\[\e[01;32m\](\t)${debian_chroot:+($debian_chroot)}\[\e[01;34m\]\u\[\e[01;37m\]@\[\e[01;36m\]\h\[\e[01;37m\]#\[\e[01;31m\]${LINENO}\[\e[01;37m\][\w]\$> '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title
case "$TERM" in
xterm*|rxvt*|screen*)
#     PS1="\[\e[27;24;23;06;2m\]\[\e]0;${debian_chroot:+($debian_chroot)}(\d -- \t)<\u@\h:[\w]> {\sv\v}\a\]$PS1"
# FIXME le premier marche pas dans les tty[1-6]
     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}(\d -- \t)<\u@\h:[\w]> {\sv\v}\a\]$PS1"
    ;;
*)
    ;;
esac

# PS2 : message du prompt quand la ligne n'est pas terminee :
PS2=${PS1%'> '}'>and?> '

# Man pages
export MANPATH=$MANPATH:/usr/share/man:/usr/local/man:"$HOME"/.local/python3/share/man/:"$HOME"/.local/ocaml4/man/

export PAGER=less
export EDITOR=/bin/nano
## export VISUAL=/usr/bin/gedit
export VISUAL=/bin/nano
export BROWSER=/usr/bin/firefox

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r "$HOME"/.dircolors && eval "$(dircolors -b "$HOME"/.dircolors)" || eval "$(dircolors -b)"
    # Aliases
    alias ls='ls -hF --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# "$HOME"/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f "$HOME"/.bash_aliases ]; then
    . "$HOME"/.bash_aliases
else
    echo -e "No $HOME/.bash_aliases file ..."
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
else
    echo -e "No /etc/bash_completion file ..."
fi

# Placez vos fichiers de bash-completion custom dans "$HOME"/.bash_completion.d/
# ils seront charges par la ligne suivante
[ -d "$HOME"/.bash_completion.d/ ] && for f in "$HOME"/.bash_completion.d/*; do source $f; done

# Colors
escp="\033["
black="${escp}01;30m"
red="${escp}01;31m"
green="${escp}01;32m"
yellow="${escp}01;33m"
blue="${escp}01;34m"
magenta="${escp}01;35m"
cyan="${escp}01;36m"
white="${escp}01;37m"
# To erase the current line. (not print '\n' but ERASE trully).
export ERASE_LINE="\r\033[K"

[ -f "$HOME/.color.sh" ] && . "$HOME/.color.sh"

# Old PS1
PS1OLD="$PS1"
# A test to integrate $? in PS1
#  in red if $? is indicating an error on last command
PROMPT_COMMAND='ANSWER=$?; if [ $ANSWER = 0 ]; then PS1="${PS1OLD%> }\[\e[01;37m\]> "; else PS1="${PS1OLD%> }\[${red}\]+$ANSWER+\[\e[01;37m\]> "; printf "\a"; fi' #; history -a; history -n'

## Classic prompt command
# shopt -s histappend
# PROMPT_COMMAND="$PROMPT_COMMAND; history -a; history -n"

# A try to correct byobu's bad handling of changing title (FAIL)
#PROMPT_COMMAND="$PROMPT_COMMAND; printf \"\033]0; .: ($(date))<${USER}@$(hostname)>:[$(pwd)] ($(__ip_address t)) - ${PKG} :. \007\""

# Add to the $PATH
#:"$HOME"/.gnome2/nautilus-scripts/
export PATH="$HOME/bin/":$PATH:"$HOME/.local/bin/":"$HOME"/.ConkyWizardTheme/scripts/:"$HOME/bin/"
# Add "$HOME"/bin if needed (but only if needed, having one directory twice in $PATH is durty!

export RLWRAP_HOME="$HOME"

####################################################################
# Better gpg agent and stuffs ?
#export GPG_TTY=$(tty)
#if [ -f "${HOME}/.gpg-agent-info" ]; then
# . "${HOME}/.gpg-agent-info"
# export GPG_AGENT_INFO
# export SSH_AUTH_SOCK
#fi

# Be sure $HOSTNAME and $USER are well set
[ X"$HOSTNAME" = X ] && export HOSTNAME=`hostname`
[ X"$USER" = X ] && export USER=`whoami`

####################################################################
# automatic emails
alias Mail_LOG_in='mail_ghost.py "Automatically sent by the machine $HOSTNAME.crans.org when log-in.\n\nLast:`last`\n\nWho:`/usr/bin/w`\n\nDate:`date`\n" "[LOG] `who|tail -n1` : login."'
alias Mail_LOG_out='mail_ghost.py "Automatically sent by the machine $HOSTNAME.crans.org when log-out.\n\nLast:`last`\n\nWho:`/usr/bin/w`\n\nDate:`date`\n" "[LOG] `who|tail -n1` : logout."'

alias SHUTDOWN='mail_ghost.py "Automatically sent by the machine $HOSTNAME.crans.org when shutdown." "[LOG] ${USER}@${HOSTNAME} : shutdown"; mail_tel.py "Automatically sent by the machine $HOSTNAME.crans.org when shutdown." "[LOG] ${USER}@${HOSTNAME} : shutdown"; sudo shutdown now'
alias REBOOT='mail_ghost.py "Automatically sent by the machine $HOSTNAME.crans.org when reboot." "[LOG] ${USER}@${HOSTNAME} : reboot"; mail_tel.py "Automatically sent by the machine $HOSTNAME.crans.org when reboot." "[LOG] ${USER}@${HOSTNAME} : reboot"; sudo reboot now'
alias VEILLE='mail_ghost.py "Automatically sent by the machine $HOSTNAME.crans.org when fall asleep." "[LOG] ${USER}@${HOSTNAME} : going sleep"; GoingSleep.sh'
alias LOCK_NO_SLEEP='mail_ghost.py "Automatically sent by the machine $HOSTNAME.crans.org when going locked (but not asleep)." "[LOG] ${USER}@${HOSTNAME} : going locked"; GoingSleep.sh no'
alias Mail_LOG_save='mail.py "Automatically sent by the machine $HOSTNAME.crans.org when saving." "[LOG] ${USER}@${HOSTNAME} : save"'

case "`/usr/bin/who|tail -n1|grep -v tty[1-7]`" in
pts/*)
  # Send an email only if connecting from a remote computer.
  Mail_LOG_in
  ;;
tty[1-6]*)
  # Change color of terminal ?
  setterm -foreground green -bold -store
  ;;
esac

export COLORTERM=gnome-terminal

## Autorize colors in less
#alias less='less -r'
##less(){ ( /usr/bin/lesspipe "$@" | less -r ) || echo -e "${red}Error with less on $@"; }

## +----------------------+
## | Generation du prompt |
## +----------------------+

# Generation de la ligne de "-"
function gen_minus_line
{
    local i
    MINUS_LINE=""
    SAVE_COLUMNS=$COLUMNS
    for ((i = COLUMNS-23; i>0; i--)); do
	MINUS_LINE=$MINUS_CHAR$MINUS_LINE
    done
}

# Generation du prompt apres chaque commande
function prompt_command
{
    # Attention aux hacks pour que la couleur (et sa taille)
    #  soient evaluees au moment de l'affichage du prompt
    local pwd cyan violet jaune rouge vert bleu ERR DATE PROMPT DIR POST_DIR
    (( SAVE_COLUMNS == COLUMNS )) || gen_minus_line
    
    cyan='\[\e[1;36m\]'
    violet='\[\e[1;35m\]'
    jaune='\[\e[1;33m\]'
    rouge='\[\e[1;31m\]'
    vert='\[\e[1;32m\]'
    bleu='\[\e[1;34m\]'
    nocolor='\[\e[0m\]'
    
    pwd=${PWD/#"$HOME"/'$HOME'}
    if (( ${#pwd} + ${VCS_size} + 27 > COLUMNS )); then
 	    if (( COLUMNS >= 33 )); then
	        DIR='..'${pwd:${#pwd}+${VCS_size}+30-COLUMNS}
            POST_DIR='${MINUS_LINE:0:4-${#?}}'
	    else
	        DIR=$pwd
            POST_DIR=$MINUS_CHAR
	    fi
    else
	    DIR=$pwd
        POST_DIR='${MINUS_LINE:'${#pwd}+${VCS_size}+1'+${#?}}'
    fi
    DIR="< ${jaune}"$DIR"${cyan} >"
    ERR='[ \[\e[1;$((31+($?==0)*6))m\]$?'${cyan}' ]'$MINUS_CHAR
    DATE="( ${violet}\D{%H:%M:%S}${cyan} )"
    PROMPT="${rouge}\u${vert}@${bleu}\h ${vert}\$ ${nocolor}"
    PS1=$TITLE${cyan}$MINUS_CHAR$DATE$MINUS_CHAR$DIR$MINUS_CHAR$VCS_info${cyan}$POST_DIR$ERR'\n'$PROMPT
}

# On change le titre de la fenetre dynamiquement si on est sous X
if [[ $TERM = "xterm" ]]; then
    TITLE='\[\e];\u@\h:\w\a\]'
else
    TITLE=''
fi

## On regenere le prompt apres chaque commande
#PROMPT_COMMAND=prompt_command

# +-------------------+
# | Messages au debut |
# +-------------------+

if [[ $(uname) == Linux && ( $(locale charmap) == UTF-8) ]]; then
    # && $TERM != screen 
    MINUS_CHAR=─
    gen_minus_line
    datecolored="${reset} Bienvenue, ${blue}${USER}${white}@${cyan}${HOSTNAME}${reset}. Date: ${magenta}`/bin/date +\"%R, %A %d %B %Y\"`${reset}. Console: ${blue}${COLUMNS}${reset}x${green}${LINES}${reset}."
    datenotcolored=" Bienvenue, ${USER}@${HOSTNAME}. Date: `/bin/date +\"%R, %A %d %B %Y\"`. Console: ${COLUMNS}x${LINES}."
    redate=${datenotcolored//ê/e}
    redate=${redate//û/u}
    redate=${redate//é/e}
    redate=${redate//è/e}
    echo -e "\e[1;36m┬─${redate//?/─}──┬${MINUS_LINE:${#redate}-18}\n\
│ \e[1;37m$datecolored\e[1;31m \e[1;36m │\n\
└─${redate//?/─}──┘\e[0m"
else
    MINUS_CHAR=-
    gen_minus_line
    date=$(/bin/date +"%R, %A %d %B %Y")
    redate=${date//ê/e}
    redate=${redate//û/u}
    redate=${redate//é/e}
    redate=${redate//è/e}
    echo -e "\e[1;36m+-${redate//?/-}--+${MINUS_LINE:${#date}-18}\n\
| \e[1;37m$date\e[1;31m \e[1;36m |\n\
+-${redate//?/-}--+\e[0m"
    unset date
fi

# If this is an xterm print a colored home symbol
#case "$TERM" in
#*dumb*)
#    echo -e "${red}Connexion SSH : log envoye :) En cas d'urgence +33628412257 ou Lilian.BESSON[@]live.fr,[@]ens-cachan.fr,[@]crans.org. ([@] = @)"
#    ;;
#xterm*|rxvt*|linux*|screen*)
#    if [ $((COLUMNS > 171 )) = "1" -a "$TERM" = xterm ]; then
#	if [ -x /usr/bin/figlet ]; then
#         echo -e "${green}`figlet \"$USER @ $HOSTNAME\" -t -f big -k -c`${white}"
#        else
#         echo -e "${green}.:/ $USER @ $HOSTNAME \\:.${white}"
#        fi
#    elif [ $(locale charmap) != UTF-8 ]; then	
#    	echo -e " Bienvenue, ${blue}${USER}${white}@${cyan}${HOSTNAME}${white}. Console: ${blue}${COLUMNS}${white}x${green}${LINES}${white}."
#    else 
#        echo -e "nothing to say yet TODO FIXME :(" >> /tmp/bashrc.log
#    fi
#    ;;
#*)
#    echo -e " Bienvenue, ${blue}${USER}${white}@${cyan}${HOSTNAME}${white}. Console: ${blue}${COLUMNS}${white}x${green}${LINES}${white}."
#    if [ ! "X$?" = "X0" ]; then
#	if [ -x /usr/bin/figlet ]; then
#         echo -e "${green}`figlet \"$USER @ $HOSTNAME\" -t -f big -k -c`${white}"
#        else
#         echo -e "${green}.:/ $USER @ $HOSTNAME \\:.${white}"
#        fi
#    fi
#    echo -e "${white} "`date "+Nous sommes le ${blue}%A %d${yellow} %b${white}, et il est ${red}%H${white}h:${green}%M${white}m:${yellow}%S${white}s."`
#    ;;
#esac

# OPAM configuration. TOO SLOW !!!
if [ -d /home/lilian/.opam/ ]; then
  # echo "OPAM init..."
  . /home/lilian/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
  # echo -e "${el}"
fi

##############################################################################
# GPG Security, adapt the $GPGKEY to be the defaut Key you use (for mutt for example, or pypi)
export GPGKEY=C108F8A0
export DEBFULLNAME='Lilian Besson'
# Mail
DEBEMAIL=lbesson_@_ens-cachan.fr
export DEBEMAIL="${DEBEMAIL//_@_/@}"
EMAIL=besson_@_crans.org
export EMAIL="${EMAIL//_@_/@}"

export PYTHONSTARTUP="$HOME/.pythonrc"

# Random quotes
export quotes="$HOME/.quotes.txt"

function _exit()        # function to run upon exit of shell
{
 # Print a last message.
 if [ -f "$quotes" ]; then
  qu="$(shuf "$quotes" | head -n1)"
  echo -e "${reset}${i}${Bblack}${cyan}${qu:-"Je reviendrais..."}${reset}"
  # echo -e " ${white}${u}Random quote of the day${U} (from ${black}${quotes}${white}):\n ${blue}${qu}${white}"
 else
  qu=""
  printf "\a${ERASE_LINE}${Bblack}${u}${blink} \"En revoir, et merci bien pour le poisson !\" -- H2G2${reset}\n"
 fi
 # Determine from where the user was connected.
 case "`/usr/bin/who|tail -n1|grep -o \"\(tty[1-7]\|pts/[0-9]*\)\"`" in
 pts/*)
  # randquote
  # Mail_LOG_out
  echo -e "Automatically sent by the machine $HOSTNAME.crans.org when log-out.\n\nLast:`last`\n\nWho:`/usr/bin/w`\n\nDate:`date`\n" "[LOG] `who|tail -n1` : logout." >> "$HOME"/.pts.log
  ;;
 tty7*)
  # randquote
  notify-send "${USER}@${HOSTNAME} : logout" "Last command : `history | tail -n 1`."
  echo -e "${USER}@${HOSTNAME} : logout" "Last command : `history | tail -n 1`." >> "$HOME"/.tty7.log
  echo -e "Automatically sent by the machine $HOSTNAME.crans.org when log-out.\n\nLast:`last`\n\nWho:`/usr/bin/w`\n\nDate:`date`\n" "[LOG] `who|tail -n1` : logout." >> "$HOME"/.tty7.log
  ;;
 tty[1-6]*)
  Mail_LOG_out
  echo -e "${USER}@${HOSTNAME} : logout" "Last command : `history | tail -n 1`." >> "$HOME"/.tty123456.log
  echo -e "Automatically sent by the machine $HOSTNAME.crans.org when log-out.\n\nLast:`last`\n\nWho:`/usr/bin/w`\n\nDate:`date`\n" "[LOG] `who|tail -n1` : logout." >> "$HOME"/.tty123456.log
  ;;
 esac 
}
# Register the function.
trap _exit EXIT

# Message of the Day
if [ -f "$HOME/motd" ]; then
  [ "X`cat $HOME/motd`" = "X" ] && echo -e "No motd :(" > "$HOME/motd"
  echo -e " ${white}${u}Message du jour${U} (from ${black}$HOME/motd${white}):${blue}`cat $HOME/motd`${white}"
else
  [ -x /usr/local/bin/tpal ] && (echo -e " ${yellow}Random color art palette .....${reset}" ; tpal art) || echo -e "tpal is not in your \$PATH :("
fi

##############################################################################
#	(c) 2011-2014 Lilian BESSON
#		ENS de Cachan & Cr@ns
#	http://www.dptinfo.ens-cachan.fr/~lbesson
#	http://perso.crans.org/besson
#		On Bitbucket:
#	http://bitbucket.org/lbesson/home/
#
# Put a blank line after
#  to autorize echo "newentry" >> "$HOME"/.bashrc

export BYOBU_NO_TITLE=yes
