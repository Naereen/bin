#!/bin/bash
#	.bash_aliases for GNU Bash v4+
#	(c) 2011-2014 Lilian BESSON
#		ENS de Cachan & Cr@ns
#	http://www.dptinfo.ens-cachan.fr/~lbesson
#	http://perso.crans.org/besson
#		On Bitbucket:
#	http://bitbucket.org/lbesson/home/

# A try with erase line.
LS_ECHO()
{
 printf " ${blue}${u} Listing${reset} \$*..."
 sleep 0.5
 printf "${el}..."
 for i in $*
 do
  printf "${green}$i${reset}..."
  sleep 0.05
  printf "${el}..."
 done
 printf "${red}Done !${reset}"
}
#	Commandes mv :
alias mv='/bin/mv -i'

#	Commandes ls avec diverses options :
# The 'ls' family (this assumes you use the GNU ls)

la() {
 arg=`history | tail -n1 | sed s/'^.*la '/''/`
 if [[ X"$@" = X ]]; then
   echo -e "Contenu du dossier $reset${u}`pwd`$U$white ${magenta}[option -A]$white"
 else
   echo -e "Liste des fichiers pour $reset$u$arg$U$white ${magenta}[option -A]$white"
 fi
 /bin/ls --color=auto -A "$@"
}

l() {
 arg="`history | tail -n1 | sed s/'^.*l '/''/`"
 if [[ X"$@" = X ]]; then
   echo -e "Contenu du dossier $reset${u}`pwd`$U$white ${magenta}[option -hCF]$white"
 else
   echo -e "Liste des fichiers pour $reset$u$arg$U$white ${magenta}[option -hCF]$white"
 fi
 /bin/ls --color=auto -hCF "$@"
}

lnc() {
 arg="`history | tail -n1 | sed s/'^.*l '/''/`"
 if [[ X"$@" = X ]]; then
   echo -e "Contenu du dossier $reset${u}`pwd`$U$white ${magenta}[option -hCF]$white"
 else
   echo -e "Liste des fichiers pour $reset$u$arg$U$white ${magenta}[option -hCF]$white"
 fi
 /bin/ls --color=never -hCF "$@"
}

# To print directory
alias lD='find . -maxdepth 1 -type d'

alias ll='/bin/ls --color=auto -larth'
alias lt='/bin/ls --color=auto -lSrha'
alias ltime='/bin/ls --color=auto -time-style=+%D | grep `date +%D`'
alias lx='/bin/ls --color=auto -lXB' # sort by extension
alias lk='/bin/ls --color=auto -lSr' # sort by size
alias lc='/bin/ls --color=auto -lcr' # sort by change time
alias lu='/bin/ls --color=auto -lur' # sort by access time
alias lr='/bin/ls --color=auto -lR' # recursive ls
alias lm='/bin/ls --color=auto -al | less' # pipe through 'more'

alias tree='tree -Csuh' # nice alternative to 'ls'

# Shortcuts.
alias cp='/bin/cp -iv'

alias h='history'
alias which='type -all'
alias ..='cd ..'
alias ....='cd ../..'
alias path='echo -e ${PATH//:/\\n}'

#	Commande dut : 'du' Trie. dush : total du dossier courant.
alias dut='/usr/bin/du -kx | egrep -v "\./.+/" | sort -n'
alias dush='/usr/bin/du -sh'
alias du='/usr/bin/du -kh'
alias df='/bin/df -h -l -t ext3 -t ext4 -t fuseblk -t vfat'

#	Commandes avec GNU-Nano :
alias nano='nano --tabsize=8 --softwrap --suspend --const --smooth --rebindkeypad --boldtext --multibuffer  --preserve --backup --historylog --nonewlines --quickblank --wordbounds --undo'
alias nano='xtitle "(`date`<$USER@$HOSTNAME>:[`pwd`]> { GNU Nano 2.3.2 }" ; nano'

# Un meilleur make, qui remonte dans le dossier jusqu'à trouver un bon Makefile
MAKE="make -w"

mymake() {
 old=$(pwd)"/"
 echo -e "Looking for a valid ${magenta}Makefile${white} from ${blue}${old}/${white} :"
 c="."
 while [ ! -f ${old}${c}/Makefile ]; do
  echo -e "${red}${old}${c}/Makefile${white} is not there, going up ..."
  c="../${c}"
  cd "$c"
  [ `pwd` = "/" ] && break
  #read
 done
 if [ -f ${old}${c}/Makefile ]; then
  echo -e "${green}${old}${c}/Makefile${white} is there, I'm using it :"
  $MAKE --file="${old}${c}/Makefile" $@
  cd "$old"
 else
  cd "$old"
  echo -e "${red}${old}${c}/Makefile${white} is not there and I'm in '/' I cannot go up ..."
  return 2
 fi
}
# alias make='xtitle "Making $(basename "`pwd -P`")..." ; mymake'
alias make='mymake'

#	Ajout de securite sur la commande 'rm' :
alias delete='echo -e "Supression avec une seule confirmation ?" && /bin/rm -I'
alias rm='/bin/rm -vi'

alias _cd_old='cd'
CD() {
p="`pwd`"
p2="`pwd -P`"
if [ "X$*" = "X" ]
then
	args="$HOME"
else
	args="$*"
fi
if [ "X$p" = "X$p2" ]
then
	echo -e "Vous ${yellow}quittez${white} le dossier ${blue}'$p'${white}.\n\tDirection ==> ${green}$args${white}"
	_cd_old "$args"
else
	echo -e "Vous ${red}quittez${white} le dossier ${yellow}'$p'${white}.\n\t/!\\ Chemin ${red}relatif${white}, car le vrai est ${blue}'$p2'${white}.\n\tDirection ==> ${green}$args${white}"
	_cd_old "$args"
fi
}

alias cd..="CD .."
alias cdBack='CD "${OLDPWD:=$PWD}"'
alias cdP='cd "`pwd -P`"'
alias cd="CD"

#	Commandes avec SSH :
alias ssh='/usr/bin/ssh -X -C'

#	Des commandes auxquelles on rajoute des messages inutiles :
mkdir() {
 echo -e "Le système va essayer de créer le dossier $@..."
 /bin/mkdir -p "$@"
}

# Use CP instead (http://besson.qc.to/bin/CP)
alias scp='echo -e "La copie (par SSH) du/des fichier(s) demande(s) vers la cible demandee ${u}|ou|${U} depuis le serveur demande va debuter..." && scp'

#	Liste des processus lances par d'autres utilisateurs sur la machine :
alias ProcessusAutre='ps aux  --sort=-%cpu | grep -m 11 -v `whoami`'

#	Une commande /*geek*/ pour afficher une video en ASCII ... en console !
alias VideoAscii='mplayer -vo caca'

#	Pour convertir des fichiers textes :
alias dos2unix='recode dos/CR-LF..l1'
alias unix2win='recode l1..windows-1250'
alias unix2dos='recode l1..dos/CR-LF'

#	Pour installer directement :
alias Installer='echo -e "Recherche des paquets demandés... Veuillez rentrer votre mot de passe :"; sudo apt-get install'

#	Pour prononcer un son :
alias Prononcer='espeak -s 170 -v french --stdin'

# Avec nautilus
alias nautici='echo -e "Ouverture de Nautilus dans le repertoire courant [${blue}`pwd`${white}]... en cours de traitement..." && nautilus "`pwd`" &> /dev/null &'

# Support de l'outil LEDIT pour un meilleur toplevel ocaml.
alias leditocaml='ledit -x -h ocaml_history.ml ocaml'
alias leocaml='rlwrap -t dumb --file=/home/lilian/keyword_mocaml_rlwrap.txt --renice --remember -Acm -aPassword: -pGreen --break-chars "(){}[],+-=&^%$#@\"" --histsize 3000000 -H ocaml_history.ml ledit -x -u -l $COLUMNS -h ocaml_history.ml ocaml'
alias rlocaml='ledit -x -u -l $COLUMNS -h mocaml_history.ml rlwrap -t dumb -z count_in_prompt --file=/home/lilian/keyword_mocaml_rlwrap.txt --renice --remember -Acm  -aPassword: -pGreen --break-chars "(){}[],+-=&^%$#@\"" --histsize 3000000 ocaml'

alias mocaml='rlwrap -t dumb --file=/home/lilian/keyword_mocaml_rlwrap.txt --renice --remember -Acm -aPassword: -pGreen --break-chars "(){}[],+-=&^%$#@\"" --histsize 3000000 -H mocaml_history.ml  ledit -x -u -l $COLUMNS -h mocaml_history.ml ocaml'
alias mocaml_noANSI='rlwrap -t dumb --file=/home/lilian/keyword_mocaml_rlwrap.txt --renice --remember -Acm -aPassword: -pGreen --break-chars "(){}[],+-=&^%$#@\"" --histsize 3000000 -H mocaml_history.ml ledit -x -u -l $COLUMNS -h mocaml_history.ml /home/lilian/.mocaml/launch_noANSI.sh'
alias modebugcaml='rlwrap -t dumb --file=/home/lilian/.mocaml/modebugcaml_list_of_commands --renice --remember -Acm -aPassword: -pGreen --break-chars "(){}[],+-=&^%$#@\"" --histsize 3000000 -H mocamlDebug_history.log ledit -x -u -l $COLUMNS -h mocamlDebug_history.log ocamldebug'

# Interpréter les fichiers. Bien mieux que 'ocaml file1.ml file2.ml'.
iocaml() {
 for i in $@; do
  cat "$i" >> /tmp/iocaml.ml
  echo -e "(** OCaml on ${i}:1:1 *)" >> /tmp/iocaml.log
  /usr/bin/ocaml graphics.cma < "$i" 2>&1 | tee -a /tmp/iocaml.log | sed s{//toplevel//{"$i"{ | pygmentize -l ocaml -P encoding=`file -b --mime-encoding "$i"`
 done
}

##########################################################################################
## Generalisation : la commande moWrap "prompt" <commande> [args]
#	permet de rentrer dans le toplevel <commande> avec les arguments optionnels [args], en definissant le prompt comme etant
#	 'N<prompt> ' avec N le numero de l'entree.
ExtensionOfApps ()
{
case "$1" in
python*)
	echo -e "py"
	;;
*caml*)
	echo -e "ml"
	;;
*gcc*|*c++*)
	echo -e "c"
	;;
*nvcc*)
	echo -e "cu"
	;;
*sh*)
	echo -e "sh"
	;;
*perl*)
	echo -e "pl"
	;;
*matlab*|*octave*)
	echo -e "m"
	;;
*gnuplot*)
	echo -e "plot"
	;;
*)
	echo -e "log"
	;;
esac
}

moWrap()
{
	prompt="$1"
	shift
	echo -e "Lancement de la commande [$*] avec une edition de ligne de commande amelioree."
	~/.rlwrap_prompt_custom.sh "$prompt"
	extension=`ExtensionOfApps "$1"`
	rlwrap -t dumb -z /tmp/rlwrap_prompt_custom__custom --renice --remember -Acm -aPassword: -pGreen --break-chars "(){}[],+-=&^%\$#@\"" --histsize 3000 -H ${1}_history.$extension ledit -x -u -l $COLUMNS -h ${1}_history.$extension $*
}

########################################################################
# Outil pygmentize : permet une coloration syntaxique dans la console
case $TERM in
*dumb*|*term*)
	CAT_COLOR="terminal256"
	export CAT_COLOR="terminal256"
	;;
*)
	CAT_COLOR="terminal"
	export CAT_COLOR="terminal"
	;;
esac

alias catColor='pygmentize -f $CAT_COLOR -g'

ExportColorLaTeX(){
  pygmentize -f latex -P encoding=utf8 -o $1.tex $1
}

ExportColorLaTeXFull(){
  pygmentize -f latex -P encoding=utf8 -O full -o $1.full.tex $1
}

########################################################################
export RLWRAP_HOME='/home/lilian/'
export RLWRAP_EDITOR='nano --autoindent --tabsize=8 --softwrap --suspend --const --smooth --rebindkeypad --boldtext --multibuffer  --preserve'

voirImage() {
 for image in "$@"; do
  echo -e "L'image '${image}' va etre affichee en ASCII."
  if [ -f "${image}" ]; then
   convert "${image}" jpg:- | jp2a -b -f --colors -
  fi;
 done
}

# Ajout d'une bash complétion comme ça, en une ligne !
# TODO: à étendre !
complete -f -X '!*.@(gif|GIF|jp?(e)g|pn[gm]|PN[GM]|ico|ICO)' voirImage

xtitle() {
 echo -e "${reset}Setting title to $@..." >> /tmp/xtitle.log
 echo -e "${cyan}Setting title to ${white}${u}$@${U}...${reset}${white}"
 if [ -x /usr/bin/xtitle ]; then
  /usr/bin/xtitle "$@"
 fi
}

# Autre outils pratiques
Regler_son(){
 xtitle "(`date`<$USER@$HOSTNAME>:[`pwd`]> { AlsaMixer v1.0.25 }" || true
 clear; alsamixer; clear
}

Wavemon(){
 xtitle "(`date`<$USER@$HOSTNAME>:[`pwd`]> { `wavemon -v | head -n1` }" || true
 clear; wavemon; clear
}

# alias captureEcran='scrot --delay 3 --count --quality 100 "captureEcran_$USER@$HOSTNAME[display=$DISPLAY]_%Y-%m-%d_%H-%M-%S_\$wx\$h.jpg"'
captureEcran() {
	sleep 3s
	xfce4-screenshooter -r -d 5 || gnome-screenshot -i
	clear
}

alias EditXMLConf='dconf-editor &'
alias manH='man -Helinks'
alias Byobu='byobu -A -D -RR -fa -h 150000 -l -O -U'
alias Byobu-tmux='byobu-tmux -2 -q -u'

alias py2html='pyhtmlizer --stylesheet=http://perso.crans.org/besson/pyhtmlizer.css'

# Ecrans de veilles
alias MatrixVeille='cmatrix -b -f -s -u 9'

# Screensaver (very CPU expensive) in texts mods, using libcaca examples (cacademo or cacafire)
alias cacademoTerminal='OLDDISPLAY=$DISPLAY; DISPLAY=""; cacademo; DISPLAY=$OLDDISPLAY'
alias cacafireTerminal='OLDDISPLAY=$DISPLAY; DISPLAY=""; cacafire; DISPLAY=$OLDDISPLAY'

alias Btime='/usr/bin/time'

lessColor() {
 for i in $*; do
  pygmentize -P encoding=`file -b --mime-encoding "$i"` -f $CAT_COLOR -g "$i" | less -r || \
  echo -e "${red}[ERROR]${yellow} LessColor failed to read $u$i$U ...${white}" > /dev/stderr
 done
}

## Emuler l'appuis sur les touches de volumes (ne fonctionne temporairement plus)
alias SoundMute='echo -e KeyStrPress XF86AudioMute KeyStrRelease XF86AudioMute | xmacroplay $DISPLAY > /dev/null >& /dev/null'
alias SoundUp='echo -e KeyStrPress XF86AudioRaiseVolume KeyStrRelease XF86AudioRaiseVolume | xmacroplay $DISPLAY > /dev/null >& /dev/null'
alias SoundDown='echo -e KeyStrPress XF86AudioLowerVolume KeyStrRelease XF86AudioLowerVolume | xmacroplay $DISPLAY > /dev/null >& /dev/null'
alias RaiseSound='echo -e KeyStrPress XF86AudioRaiseVolume KeyStrRelease XF86AudioRaiseVolume | xmacroplay $DISPLAY > /dev/null >& /dev/null'
alias LowerSound='echo -e KeyStrPress XF86AudioLowerVolume KeyStrRelease XF86AudioLowerVolume | xmacroplay $DISPLAY > /dev/null >& /dev/null'

# Variable utiles pour faire des scp et des rsync **facilement**
export SDPT='lbesson@ssh.dptinfo.ens-cachan.fr'
export SZAM='besson@zamok.crans.org'
##export SVO='besson@vo.crans.org'
##export SCML='besson@ssh.cmla.ens-cachan.fr'
export Sdpt='lbesson@ssh.dptinfo.ens-cachan.fr:~/public_html/'
export Szam='besson@zamok.crans.org:~/www/'
export toprint="${Szam}dl/.p/toprint/"
##export Svo='besson@vo.crans.org:~/'
export Sjarvis='~/Public/'

# Un outil pour les messages du jour
alias motd='changemotd.sh --print'
chmotd() {
 if [ "X$DISPLAY" = "X" ]; then
  echo -e "Using : dialog."
  changemotd.sh --new-dialog
 else
  echo -e "Using : zenity."
  changemotd.sh --new-zenity
 fi
}

LessColor() { pygmentize -f $CAT_COLOR -g $* | less -r; }

# Un meilleur 'scp'. Ne fonctionne pas avec tous les serveurs, car la cible **doit** avoir rsync aussi.
# NOTE: fonctionne aussi en local (et donne un avancement et propose une compression, meme en local).
# alias CP='/usr/bin/rsync --verbose --times --perms --compress --human-readable --progress --archive'
# Deprecated: use http://besson.qc.to/bin/CP instead (with colours!)

DOCXtoPDF() { for i in $*; do echo -e "$i ----[abiword]----> ${i%.docx}.pdf"; abiword "$i" --to="${i%.docx}.pdf"; echo -e $?; done }

# Alias pour executer localement des commandes crans. Deprecated: je ne suis plus cableur.
# alias who2b='ssh vo "who2b"'
# alias whokfet='ssh zamok "whokfet"'
# alias whos='ssh zamok "whos"'

# Netoyer les fichiers temporaires (sauvegarde, python, ou emacs)
alias rmPyc='rm -f *.py[co] && echo "Local Python compiled files (*.pyc and *.pyo) have been deleted..."'
alias rmt='rm -fv *~ .*~ *.py[co] \#*\#'

rmTilde() {
 if [ X"$1" != X"" ]; then
  for i in $@; do
   #d="`basename \"$i\"`" # ? inutile ?
   d="$i"
   rm -vf "$d"/*~ "$d"/.*~ "$d"/*.py[co] \#*\#
  done
  echo "Fichiers temporaires (*~ .*~) bien supprimes."
 else
  rm -vf *~ .*~ *.py[co] \#*\# && echo "Fichiers temporaires (*~ .*~) bien supprimes."
 fi
}

alias rmt=rmTilde
alias rm~="rmTilde *"

# Netoyer les fichiers temporaires crees par LaTeX (pdflatex et hevea)
alias rmLaTeX='for i in *.tex; do echo "Pour $i:" ; for j in "${i%tex}dvi" "${i%tex}htoc" "${i%tex}frompdf[0-9]*.png" "${i%tex}bbl" "${i%tex}blg" "${i%tex}brf" "${i%tex}tms" "${i%tex}tid" "${i%tex}lg" "${i%tex}idv" "${i%tex}vrb" "${i%tex}toc" "${i%tex}snm" "${i%tex}nav" "${i%tex}htmp" "${i%tex}synctex.gz" "${i%tex}aux" "${i%tex}log" "${i%tex}tmp" "${i%tex}idx" "${i%tex}aux" "${i%tex}out" "${i%tex}haux" "${i%tex}hidx"; do mv -vf "$j" /tmp/ 2>/dev/null; done; echo -e "Fichiers `ls --color=always --format=horizontal ${i%tex}html ${i%tex}pdf` : conserves..."; done'

# A super pdflatex
tex2pdf() {
 ( pdflatex "$@" && pdflatex "$@" ) \
 || (clear ; chktex "$@" ; alert )
}
TEX2PDF() {
 ( pdflatex "$@" && pdflatex "$@" | tee /tmp/tex2pdf.log) \
 || (clear ; chktex "$@" ; alert )
 out="$(grep -m1 -o "Output written on .*.pdf" /tmp/tex2pdf.log | grep -o "[^ ]*.pdf")" ;
 [ "$(PDFCompress --help)" != "" ] && PDFCompress "$out"
}

# N'afficher que les processus lances par l'utilisateur courant dans htop.
alias Htop='htop -u $USER'

# Pour afficher la temperature.
alias TempDisk='echo -e "Hard drive temperature : ${green}$((`sudo hddtemp --numeric --wake-up /dev/disk/by-label/SYSTEM`))${white} °C."'

# Affiche la taille du repertoire courant. Peut etre long a calculer !
alias TailleCourante='LS_ECHO -e "*"; echo -e "${el}Taille du repertoire ${u}courant${U} : \033[01;31m`du -sh \"\`pwd -P\`\"`\033[01;37m"'

# eteint simplement l'ecran !
alias VeilleEcranNoir='xset dpms force standby'
alias VeilleEcranNoirContinue='watch --interval=1 "echo -e \"Screen is sleeping, Ctrl+C, ^C to cancel.\" ; xset dpms force standby"'

alias IpAdresses='ifconfig | grep "inet adr:"'

# Nouveau jouet : cat /proc/acpi/...
alias Version='cat /proc/version'

# Check today content of Google Calendar
alias CheckGoogleCalendar='google calendar today | grep "`date \"+%d\"`" && google --cal="Cours" calendar today | grep "`date \"+%d\"`"'

# Gobby Server
alias SOBBY='sobby -p 6522 --password 120193 --autosave-file=/home/lilian/.gobby.savefile --autosave-interval=10'
# Via monip.org
alias AdressIP='wget --tries=5 --quiet --output-document=/tmp/monip.org.html monip.org && html2text /tmp/monip.org.html' # | pygmentize -f terminal -g

# Efface les fichiers temporaires dus a un Mac qui a monte le disque
alias EffacePresenceAPPLE='find -type d -name *Apple* -exec rm -vrI {} \;'
# Affiche tous les programmes dans le $PATH.
alias LS_PATH='ls ${PATH//:/ }'

LOG_Colored(){
	$* 2> /tmp/LOG_Colored.log
	printf "${reset}${el}\a"
	catColor /tmp/LOG_Colored.log
}

# Shortend to git
alias GitChanged='clear ; git status | grep --color=always "modified" | less -r'
alias GitDeleted='clear ; git status | grep --color=always "deleted" | less -r'
alias GitAdded='clear ; git status | grep --color=always "added" | less -r'
alias GitStatus='clear ; git status | less -r'
alias Status='clear ; git status | less -r'

# Run all test embedded in docstring, in the module $1
alias DocTest='python -m doctest -v'

# Make colorgcc an remplacement for GCC (all makefiles use CC usually)
export CC="colorgcc"

alias diff="colordiff"

# For PyLint
export PYLINTHOME="$HOME"

alias CowThink='cowthink -W 160 -f /usr/share/cowsay/cows/moose.cow'

# For tar compression.
alias TarXZ='tar -Jcvf'
alias TarGZ='tar -zcvf'
alias TarBZ2='tar -jcvf'
# For tar un-compression
alias untar='echo -e "Desarchivage du fichier archive tar en cours ..." && tar xfv'
alias untar_gz='echo -e "Desarchivage du fichier archive tar.gz en cours ..." && tar xzfv'
alias untar_bz2='echo -e "Desarchivage du fichier archive tar.bz2 en cours..." && tar xjfv'
alias untar_xz='echo -e "Desarchivage du fichier archive tar.xz en cours..." && tar xJfv'
alias unTarXZ='tar -Jxvf'
alias unTarGZ='tar -zxvf'
alias unTarBZ2='tar -jxvf'
alias unTarTBZ='tar -xjvf'

##################################################################
#  Use grep to look for TODO or FIXME or FIXED                   #
#   or HOWTO or XXX or DEBUG, or WARNING balises in code         #
GrepBalises() {
 echo -e "GrepBalises >>> Looking for specials developpement balises in files ${blue}$@${white}."
 notfound=""
 for balise in 'TODO' 'FIXME' 'FIXED' 'HOWTO' 'XXX' 'DEBUG' 'WARNING'
 do
   res=`grep --color=always -n "$balise" $@`
   if [ "m$?" != "m1" ]
   then
    echo -e "${magenta}  For the balise $balise :${default}"
    echo -e "${res}" # | pygmentize -f terminal256 -g # -l
   else
    notfound="${notfound}${balise}, "
    echo -e "${red} $balise not found in files..." >> /tmp/GrepBalises.log
   fi
 done

 if [ "X$notfound" = "X" ]; then
  echo -e "${white}GrepBalises >>> ${green} Done${white}. (on files $@)."
 else
  echo -e "${white}GrepBalises >>> ${red} Balises $notfound not found :("
  echo -e "${white}GrepBalises >>> Done. (on files $@)."
 fi
}

# Super ack-grep
alias Grep='ack-grep -ri -H --sort-files'

# Other aliases
# from http://abs.traduc.org/abs-5.3-fr/apk.html

# tailoring 'less'
export PAGER=less
export LESSCHARSET='latin1'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'

## Use this if lesspipe.sh exists.
##export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
export LESS=' -r -F -B -i -J -w -W -~ -K -d -w -W -m -X -u -r'

###-P"%t?%f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-..." -e'
# FIXME ?

# alias htop='xtitle "(`date`<$USER@$HOSTNAME>:[`pwd`]> { htop v1.0.1 }"; htop'
# alias pychecker='xtitle "Pychecker running on $PWD..."  && pychecker -# 1000 -t -9 -v -g -n -a -I -8 -1 -A -S self --changetypes -6 -q -m -c -f '

# Wrapper around current interpreters;
alias ocaml='xtitle "OCaml 4.01.0 on `pwd -P`. `date`" ; ocaml'
alias python='xtitle "Python 2.7.6 on `pwd -P`. `date`" ; python'
alias bpython='xtitle "BPython 2.7.6 on `pwd -P`. `date`" ; bpython'
alias octave='xtitle ".: Octave (-q -V --traditional --persist) 3.2.4 on `pwd -P`. `date` -- $USER@$HOSTNAME :." ; octave --silent --verbose --traditional --persist'

manTitle(){
    for i ; do
        xtitle The $(basename $1|tr -d .[:digit:]) manual
        command man "$i"
    done
}

#-----------------------------------
# File & strings related functions:
#-----------------------------------

# Find a file with a pattern in name:
function ff()
{ find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe()
{ find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }

# find pattern in a set of filesand highlight them:
function fstr()
{
    OPTIND=1
    local case=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
        i) case="-i " ;;
        *) echo "$usage"; return;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    local SMSO=$(tput smso)
    local RMSO=$(tput rmso)
    find . -type f -name "${2:-*}" -print0 |
    xargs -0 grep -sn ${case} "$1" 2>&- | \
    sed "s/$1/${SMSO}\0${RMSO}/gI" | more
}

function cuttail() # Cut last n lines in file, 10 by default.
{
    nlines=${2:-10}
    sed -n -e :a -e "1,${nlines}!{P;N;D;};N;ba" $1
}

function lowercase()  # move filenames to lowercase
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname==${file%/*} ;;
        *) dirname=.;;
        esac
        nf=$(echo $filename | tr A-Z a-z)
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}

function capitalize()  # move filenames to Capitalize
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname==${file%/*} ;;
        *) dirname=.;;
        esac
	premierelettre=${filename:0:1}
	pl=$(echo $premierelettre | tr a-z A-Z)
	nf=${pl}${filename:1}
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}

function swap()         # swap 2 filenames around
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

function my_ps()
{ ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

function pp()
{ my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

function my_ip() # get IP adresses
{
    MY_IP=$(/sbin/ifconfig | awk '/inet adr:/ { print $2 } ' | \
sed -e s/addr://)
}

function ii()   # get current host related info
{
  echo -e "\nYou are logged on ${red}$HOSTNAME ($HOSTNAME_WIFI)"
  echo -e "\nAdditionnal information:${reset}${white} " ; uname -a
  echo -e "\n${red}Users logged on:${reset}${white} " ; w -h
  echo -e "\n${red}Current date :${reset}${white} " ; date
  echo -e "\n${red}Machine stats :${reset}${white} " ; uptime
  echo -e "\n${red}Memory stats :${reset}${white} " ; free
  my_ip 2>&- ;
  echo -e "\n${red}Local IP Address :${reset}${white}" ; echo ${MY_IP:-"Not connected"}
  echo
}

###############################################################################
# FOR Python
export PYTHONSTARTUP="$HOME/.pythonrc"
#export PYTHONOPTIMIZE=	# no optimization.
#export PYTHONVERBOSE=	# no verbose adds.
export PYTHONWARNINGS="ignore"
# # For a non global installation of Python 3.3 (or higher).
# export PYTOHN3_3HOME="$HOME/.local/python3/bin/"

# alias python3.3="xtitle 'Python 3.3 (custom build) on `pwd -P`. `date`' && ${PYTOHN3_3HOME}python3.3"
# alias pyvenv-3.3="${PYTOHN3_3HOME}pyvenv-3.3"
# alias 2to3-3.3="${PYTOHN3_3HOME}2to3-3.3"
# alias pydoc3.3="${PYTOHN3_3HOME}pydoc3.3"

# Many differents mutt :

mutt(){
 xtitle "(`date`<$USER@$HOSTNAME>:[`pwd`]> { Mutt 1.5.21 } : for localhost"
 /usr/bin/mutt-patched "$@"
 [ -f yes ] && rm -f yes
}

mutt-crans(){
 xtitle "(`date`<$USER@$HOSTNAME>:[`pwd`]> { Mutt 1.5.21 } : for crans.org"
 clear ; /usr/bin/mutt-patched -F ~/.mutt/crans.muttrc "$@" && clear
 [ -f yes ] && rm -f yes
}

mutt-ens(){
 xtitle "(`date`<$USER@$HOSTNAME>:[`pwd`]> { Mutt 1.5.21 } : for ens-cachan.fr"
 clear ; /usr/bin/mutt-patched -F ~/.mutt/ens.muttrc "$@" && clear
 [ -f yes ] && rm -f yes
}

mutt-noagent-crans(){
 xtitle "(`date`<$USER@$HOSTNAME>:[`pwd`]> { Mutt 1.5.21 } : for crans.org"
 clear ; /usr/bin/mutt-patched -F ~/.mutt/crans.noagent.muttrc "$@" && clear
 [ -f yes ] && rm -f yes
}

mutt-noagent-ens(){
 xtitle "(`date`<$USER@$HOSTNAME>:[`pwd`]> { Mutt 1.5.21 } : for ens-cachan.fr"
 clear ; /usr/bin/mutt-patched -F ~/.mutt/ens.noagent.muttrc "$@" && clear
 [ -f yes ] && rm -f yes
}

# Others
puDB(){
 xtitle "PuDB: on $@ (in the directoy `pwd`)"
 /usr/bin/pudb "$@"
}

PuDB(){
 /usr/bin/gnome-terminal --window --maximize --hide-menubar --active --title="PuDB: on  on $@ (in the directoy `pwd`)" -e "/usr/bin/pudb $@"
}

# Supprimer les meta-donnees des images jpeg et png
alias CleanPicturesR='echo "Erasing EXIF infos...." && exiftool -v2 -recurse -fast -overwrite_original_in_place -all= * | tee "exiftool__$$_`date "+%H_%M_%S"`".log && echo "All EXIF infos have been erased :)"'
alias CleanPictures='echo "Erasing EXIF infos...." && exiftool -v2 -fast -overwrite_original_in_place -all= * | tee "exiftool__$$_`date "+%H_%M_%S"`".log && echo "All EXIF infos have been erased :)"'
alias CleanJPEG='exiftool -all= *.jpg *.png *.gif *.JPG .*.jpg .*.png .*.gif .*.JPG && echo "Donnees EXIF supprimees :)"'

## A less for PDF files
lessPDF() {
for f in "$@"
do
	pdftotext -r 200 -layout -eol unix -enc UTF-8 -raw "$f" && less -f -J "${f%.pdf}.txt"
done
}

# FIXME
eval "$(/bin/lesspipe)"

# Man visual
Man() { yelp "man:$@" ; }

#  Le script suivant permet de decompresser un large eventail de types de fichiers compresses. Il vous suffira juste de taper quel que soit le type d'archive :
extract() {
  echo -e "$reset${neg}Extracting $1...$reset"
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xvjf "$1"    ;;
      *.tar.gz)    tar xvzf "$1"    ;;
      *.tar.xz)    tar xvJf "$1"    ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xvf "$1"     ;;
      *.tbz2)      tar xvjf "$1"    ;;
      *.tbz)       tar xvjf "$1"    ;;
      *.tgz)       tar xvzf "$1"    ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *.xz)        unxz "$1"        ;;
      *.exe)       cabextract "$1"  ;;
      *)           echo "'$1': unrecognized file compression" ;;
    esac
  else
    echo "'$1' seems to not be a valid archive file, sorry."
  fi
}

# Experimental (marche désormais moins bien)
LatexFormula() {
 # tente d'afficher les arguments interpretes comme une formule LaTeX
 wget --quiet http://numberempire.com/equation.render?"$@" -O /tmp/LatexFormula_$$.jpg
 display -title "$@" /tmp/LatexFormula_$$.jpg
}

alias GnomeVEILLE='gnome-session-quit --power-off'

alias CheckHomePage_crans='wget -q http://perso.crans.org/besson/index_fr.html -O - | grep "Mis.*jour"'
alias CheckHomePage_dpt='wget -q http://www.dptinfo.ens-cachan.fr/~lbesson/index_fr.html -O - | grep "Mis.*jour"'
alias CheckHomePage_jarvis='wget -q http://jarvis.crans.org/index_fr.html -O - | grep "Mis.*jour"'

alias GenP="base64 < /dev/urandom | tr -d +/ | head -c 18; echo"

# Pour checker les soucis de droits.
alias MoinsOwner='chmod -vR o-w ./ | tee /tmp/.script_droit_owner.log'
alias MoinsGroup='chmod -vR g-w ./ | tee /tmp/.script_droit_group.log'
alias MOINS='( MoinsOwner ; MoinsGroup) | grep -v symbolique | grep modif'
alias M=MOINS

alias CheckPerms='find ./ -type d -perm /022'

alias PlusROwner='chmod -vR o+r ./ | tee /tmp/.script_droit_Rowner.log'
alias PlusRGroup='chmod -vR g+r ./ | tee /tmp/.script_droit_Rgroup.log'
alias PLUS='( PlusROwner ; PlusRGroup) | grep -v symbolique | grep modif'

# SuperMake
# alert=notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e 's/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//')"
SuperMake(){
 echo -e "${cyan}Making $@...${white}"
 xtitle ".: Making '$@' in '$PWD' :."
# time /usr/bin/make $@ | tee /tmp/SuperMake.log && alert || vrun pause
 ( time /usr/bin/make $@ && alert || vrun pause ) | tee /tmp/SuperMake.log
}

ViewHTML() {
for i in "$@"; do
 echo -e "Trying to see the file $i"
 curl --insecure "$i" 2> /tmp/ViewHTML.$$.log | html2text | pygmentize -f terminal -l rst
done
}

alias MacAdress='ifconfig | grep "HWaddr [0-9a-f:]*"'

# For Git
alias Push='clear; git push && git gc'
alias Pull='clear; git gc && git pull && git gc'
# alias Status='clear; git status'
alias Commit='clear; git commit -m'
alias Add='git add'

# For vrun:
alias GetUri="vrun status | grep file | sed s/'( new input: '/''/ | sed s/' )'/''/"
alias Next='vrun next && clear ; tmp1=`vrun get_title`; tmp2=`vrun status|head -n1`; echo -e "$u$tmp2$reset${white}\n${green} (→) Playing${white}: $neg$tmp1$Neg"'
alias Prev='vrun prev && clear ; tmp1=`vrun get_title`; tmp2=`vrun status|head -n1`; echo -e "$u$tmp2$reset${white}\n${green} (←) Playing${white}: $neg$tmp1$Neg"'
alias Pause='vrun pause && clear ; tmp1=`vrun get_title`; tmp2=`vrun status|head -n1`; echo -e "$u$tmp2$reset${white}\n${green} (:) Was Playing${white}: $neg$tmp1$Neg"'
alias Play='vrun play && clear ; tmp1=`vrun get_title`; tmp2=`vrun status|head -n1`; echo -e "$u$tmp2$reset${white}\n${green} (>) Now Playing${white}: $neg$tmp1$Neg"'

# Irssi
alias irc='screen irssi'

# TMUX create a new session ONLY if no other session is already running
alias TMUX='tmux -2 -q -u attach-session || tmux -2 -q -u'

# For GPG
GpgSign(){ gpg --armor --detach-sign --yes --no-batch --use-agent "$@";}
GpgVerify(){ gpg --verify --no-batch --use-agent "$@";}
GpgEncrypt(){ gpg --encrypt --yes --no-batch --use-agent -r "$EMAIL" "$@";}
GpgDecrypt(){ gpg --decrypt --yes --no-batch --use-agent "$@";}

# Pour que ssh-add ne memorise la passphrase que pendant 30 minutes
alias ssh-add='ssh-add -t 1800'

# Pour que youtube-dl recupere seulement l'audio, et en MP3 s'il vous plait
alias youtube-mp3='youtube-dl -o "%(title)s.%(ext)s" --extract-audio --console-title --audio-format=mp3 -w'
alias youtube='youtube-dl -o "%(title)s.%(ext)s" --extract-audio --console-title -k --audio-format=mp3 -w'
alias youtube-video='youtube-dl -o "%(title)s.%(ext)s" --console-title -w'

# Pour recuperer les droits d'un fichier en octal
alias getmod='/usr/bin/stat -c "%a"'

# Pour trouver les pages des pdfs du dossier courrant
alias pdfpages="find . -name '*.pdf' -exec pdfinfo {} \; | egrep '^Pages'"
# et pour les sommer
alias pdfpagessum='pdfpages | awk "{print \$2}" | paste -sd+ | bc'

alias watch='watch -b -d -e'

# Do a job, only for a certain amount of time
# Exemple : DoForATime 60 my-very-long-command-that-can-not-terminate
DoForATime(){
 log=/tmp/DoForATime`date "+%Hh-%Mm-%Ss"`.log
 TIMEOUT=$1
 shift
 echo -e "${reset}Launching $@, in $PWD, for $TIMEOUT seconds only." | tee "$log"
 echo -e "$white"
 "$@"  & { sleep ${TIMEOUT}; eval 'kill -9 $!' &>> "$log"; }
}

# Remove all .git/ directories in subdir of the current dir.
# Use carefully!
rmGit() {
 for f in `find . -type d -name ".git"`; do
  echo -e "$blue$u$f$U$white: delete ?"
  rm -rvI "$f"
 done
 ret="`find . -type d -name \".git\" -print0`"
 if [ "0$ret" = "0" ]; then
  echo -e "${green}DONE$white : all .git/ directory(ies) have been deleted!"
 else
  echo -e "${red}ERROR$white : some .git/ directory(ies) are still there : $ret"
 fi
}

# A test to improve reactivity of Bash when used into a nautilus terminal ?
pstree() {
 /usr/bin/pstree -a -h -s -c -U "$@"
}
PStree() {
 /usr/bin/pstree -a -h -s -c -U "$@" | less -r
}

sshtmux() {
if [ "Z$TMUX" = "Z" ]; then
 echo -e "${blue}Using tmux on remote server.$white"
 ( /usr/bin/ssh -X -C -t "$@" "tmux -2 -q -u attach-session || tmux -2 -q -u" ) || ( alert ; echo -e "${red}Error, connection to $@ closed." )
else
 echo -e "${red}Not using tmux on remote server. Unset \$TMUX to force this.$white"
 /usr/bin/ssh -X -C -t "$@" || ( alert ; echo -e "${red}Error, connection to $@ closed." )
fi
}

# Raccourcis avec ssh
alias sshzamok='sshtmux besson@zamok.crans.org'
alias sz='sshzamok'
alias sshvo='sshtmux besson@vo.crans.org'
alias sshdpt='sshtmux lbesson@ssh.dptinfo.ens-cachan.fr'
alias sd='sshdpt'
alias s22='sshtmux dptinfo22'

# Navigateur en console
alias elinks='elinks -verbose 0'

# Compresse les pdfs du dossiers (better to use ~/bin/PDFCompress)
# pdfCompress(){
#  echo -e "${black}Compressing .pdf files in ./${white}"
#  [ "`ls *.pdf~ 2>/dev/null`" != "" ] && /bin/mv -f -v *.pdf~ /tmp/
#  for i in *.pdf; do
#   echo -e "${blue}For the file ${green}$i${white}..."
#   /usr/bin/gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile="$i"~ "$i"
#   [ -f "$i"~ ] && ( /bin/cp "$i" /tmp/ ; ls -s "$i" "$i"~ ; /bin/mv -f -v "$i"~ "$i" )
#  done
#  /bin/rm -v -f gs_*
# }

# Short alias
Lock(){
echo -e "New use of Lock from `w`.\n\n Last: `last`.\n Date: `date`.\n\n" >> ~/.Lock.log
if [ "X`pidof gnome-screensaver`" != "X0" ]; then
 gnome-screensaver-command --lock
 xset dpms force standby
else
 cmatrix -b -f -s -u 9
 clear
 vlock --current
 xset dpms force standby
fi
}

################
# Make shortcuts
send_dpt(){
( make send_dpt 2>&1 | tee /tmp/make.log ) ; ( grep "Pas de règle" /tmp/make.log >/dev/null && echo -e "${red}Error: send_dpt not found.${white}" ; alert ) || echo -e "${green}Success :)${white}"
}

send_zamok(){
( make send_zamok 2>&1 | tee /tmp/make.log ) ; ( grep "Pas de règle" /tmp/make.log >/dev/null && echo -e "${red}Error: send_zamok not found.${white}" ; alert ) || echo -e "${green}Success :)${white}"
}

randquote(){
 if [ -f "$quotes" ]
 then
  shuf "$quotes" | head -n 1
 elif [ -f "$HOME/motd" ]
 then
  cat ~/motd
 else
  echo -e "No citation, ~/motd is not there, and \$quotes is not set."
 fi
}

## RandQuote(){ zenity --title="Rand Quote" --timeout=30 --window-icon="~/.link.ico" --info --text="<big><b>`randquote | sed s_'--'_'</b>--\n<i>'_`</i></big>" }

## alias MailRandQuote='mail_ghost.py "`randquote`" "RandQuote"'
alias CalendarRandQuote='google calendar add "`randquote`"'

# With nginx
Nginx_Access() { watch tail -n 10 /var/log/nginx/access.log || alert; }
Nginx_Error() { watch tail -n 10 /var/log/nginx/error.log || alert; }
Nginx_Start() {
 echo -e "${blue} Last changes on ~/nginx.conf on local git repository :${reset}"
 git diff ~/nginx.conf
 echo -e "${blue} Last changes on ~/nginx.conf compared with /etc/nginx/nginx.conf :${reset}"
 diff ~/nginx.conf /etc/nginx/
 echo -e "${red} Copying ~/nginx.conf to /etc/nginx ...${reset}"
 sudo cp -i ~/nginx.conf /etc/nginx/
 p="$(pidof nginx)"
 if [ "X$p" = "X" ]; then
  echo -e "${red} Starting nginx...${reset}"
  sudo nginx
 else
  echo -e "${red} Restarting nginx...${reset}"
  sudo nginx -s reload
 fi
  echo -e "${red} PIDs or command line of ${cyan}${u}nginx${U}${reset} :"
  echo "$(pidof nginx)"
}

# With Munin
Munin_Start() {
 echo -e "${blue} Last changes on ~/munin.conf on local git repository :${reset}"
 git diff ~/munin.conf
 echo -e "${blue} Last changes on ~/munin.conf compared with /etc/munin/munin.conf :${reset}"
 diff ~/munin.conf /etc/munin/
 echo -e "${red} Copying ~/munin.conf to /etc/munin ...${reset}"
 sudo cp -i ~/munin.conf /etc/munin/
 p="$(ps aux |grep "[a-z/]*perl.*munin[a-z-]*$")"
 if [ "X$p" = "X" ]; then
  echo -e "${red} Starting munin...${reset}"
  sudo service munin start
  sudo service munin-node start
 else
  echo -e "${red} Restarting munin...${reset}"
  sudo service munin restart
  sudo service munin-node restart
 fi
  echo -e "${red} PIDs or command line of ${cyan}${u}munin${U}${reset} :"
  echo "$(ps aux |grep "[a-z/]*perl.*munin[a-z-]*$")"
}

Munin_UpdateMunstrap(){
  cd ~/.local/etc/munin/munstrap/
  # git pull
  cdBack
}

# Shortcut : long command &>$null& is shorten that &>/dev/null& :)
export null="/dev/null"

#alias EmploisDuTemps='elinks http://agreg.cmla.ens-cachan.fr/'
EmploisDuTemps() {
 day=$((`date +%d | grep -o [1-9].*` - `date +%w` + 1))
 if [ $day -lt 10 ]; then day=0$day; fi
 echo "http://agreg.cmla.ens-cachan.fr/Agregphp/edt.php?option=in&sem=`date +%y-%m`-$day"
 elinks "http://agreg.cmla.ens-cachan.fr/Agregphp/edt.php?option=in&sem=`date +%y-%m`-$day"
}

# Use it like 'send_.. ${Szam}bin/' or 'send_.. ~/Dropbox/'
alias send_bashrc_bashalias='CP ~/.bashrc ~/.bash_aliases ~/.bashrc.asc ~/.bash_aliases.asc'

# Shortcut. FIXME available ONLY if 'n' is not a command.
function n() { nano "$@" || alert; }
function t() { htop || alert; }

# Get the latest QC strip ;)
alias GetQC='wget `wget http://questionablecontent.net/ -O - | grep -o "http://www.questionablecontent.net/comics.*[0-9]*.*\(png\|jpg\|jpeg\|gif\)"`'

# Print the current read/watched TV shows or movies
Currents() {
  for i in ~/current*; do
      dir="$(cat "$i")"
      echo -e "\n$u$black~/$(basename "$i")$U$white\t ---> \t$blue${dir}$white"
      serie="$(basename "${dir}")"
      cu=$( find "${dir}" -type f -iname current'*' 2>/dev/null || echo -e "Disque Dur Externe ['${u}/media/Disque Dur - Naereen/${U}']: ${red}pas branché${white}." >/dev/stderr)
      cu2="$(echo "$(basename "$cu")" | tr A-Z a-z)"
      cu2=${cu2#current_}
      # echo -e "sSSeEE  ---> $u$cu2$U"
      d=${cu2#s}; d=${d%e[0-9]*}
      # echo -e "Season :  $d"
      e=${cu2#s[0-9]*e}
      e=${e#0*}
      if [[ "${d}${e}" != "" ]]; then
        echo -e "For « ${u}${cyan}${serie}${white}${U} », the last watched episode is ${Black}${red}Season ${d:-?}${white}, ${magenta}Episode ${e:-?}${Default}${white}."
      fi
  done
}

alias UPDATE='( clear ; sudo apt-get update ; sudo apt-get upgrade ; sudo apt-get autoremove ; sudo apt-get clean ; sudo apt-get autoclean ) || alert | tee /tmp/apt.log'

# To avoid painfull &>$null& at the end of some commands
evince() { ( /usr/bin/evince "$@" || /usr/bin/firefox "$@" ) &> /dev/null & }
eog() { ( /usr/bin/eog "$@" || /usr/bin/ristretto "$@" ) &> /dev/null & }
firefox() { ( /usr/bin/firefox "$@" || /usr/bin/elinks "$@" ) &> /dev/null & }
vlc() { /usr/bin/vlc --random "$@" &> /dev/null & }
linphone() { /usr/bin/linphone "$@" &> /dev/null & }
libreoffice() { ( /usr/bin/libreoffice "$@" || /usr/bin/abiword "$@" ) &> /dev/null & }

# Better .rst → .html and .md → .html (simpler)
alias rst2html='rst2html -v -t --no-generator -l fr --cloak-email-addresses '
alias markdown='python -m markdown -e utf8 -v '

alias bd='. bd -s'

# The best way to use it is by typing a command, canceling it, and then with 'ExplainShell !!'
# Or directly: 'ExplainShell grep -C 2 -n -m 10 grep .bash_history' for example
ExplainShell() { /usr/bin/firefox http://explainshell.com/explain?cmd="${*// /%20}" &>/dev/null & }

alias Tor='~/.local/tor-browser_fr/start-tor-browser'

alias kaamelott='vlc --random /host/Users/Lilian/Videos/Séries/Kaamelott/ >/dev/null 2>/dev/null &'
alias scrubs='vlc --random /host/Users/Lilian/Videos/Séries/Scrubs/ >/dev/null 2>/dev/null &'

NewPostBlog() {
	cd ~/blog/_posts/
	d="$(date "+%F")-"
	t="${1// /-}"
	t="$(echo $t | tr A-Z a-z)"
	t="$(echo $t | iconv -c -s -f utf8 -t ascii)"
	f="${d}${t}.md"
	read -p "subl ${f} : OK ?"
	if [ -f "${f}" ]; then mv -vf "${f}" "$(tempfile)".md; fi
	cat ~/blog/posts_base.md \
		| sed s/TITLE/"$1"/ \
		| sed s/DATE/"$(date "+%F %T")"/ \
		> "${f}"
	subl "${f}":8:1
}

alias dropbox='( dropbox start ; alert ) &>/dev/null&'

alias veille='date >> /tmp/veille.log ; ( gnome-session-quit --power-off || xfce4-session-logout || (Lock ; gksudo pm-suspend) )'
alias veille2='date >> /tmp/veille.log ; Lock ; dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Suspend'

alias ETTelephoneMaison='linphone -c 0492202627@crans.org'
Appeler() {
	echo -e linphone -c "$1"@crans.org
	echo -e "Confirmez-vous l'appel au numéro $1 ?"
	read
	linphone -c "$1"@crans.org
}

function PROXY () {
  case $1 in
    off)
      rm -vf /tmp/startSocksProxy.list && echo -e "${green}PROXY is off.${white}"
      ;;
    on)
      startSocksProxy.sh && echo -e "${green}PROXY is on.${white}"
      ;;
    help|*)
      echo -e "PROXY on to activate the proxy, PROXY off to turn it off, PROXY help to print this help message."
      ;;
  esac
}

alias Success='zenity --info --title="Succés" --window-icon=success --timeout=120 --text="Opération réussie !\n La commande était : <i>$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')</i>."'

# Experimental Shortcuts
alias a='autotex'
alias p='PDFCompress'
alias f='firefox'
alias e='evince'

##############################################################################
#	(c) 2011-2014 Lilian BESSON
#		ENS de Cachan & Cr@ns
#	http://www.dptinfo.ens-cachan.fr/~lbesson
#	http://perso.crans.org/besson
#		On Bitbucket:
#	http://bitbucket.org/lbesson/home/
#
# Put a blank line after to autorize echo "alias newalias='newentry'" >> ~/.bash_aliases
