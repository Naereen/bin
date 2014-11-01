#!/usr/bin/env /bin/bash
#
# Author: Lilian BESSON
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Date: 21-10-2014
#
# A first try to automatize the selection of the "next"
# episode in your current TV serie.
#
# Requires VLC 2.0+.
# vrun is not yet included (http://besson.qc.to/bin/vrun)
#
# A bash completion file is available (http://besson.qc.to/bin/series.sh.bash_completion)
#
version='0.4'

# If possible, use ~/.color.sh (http://besson.qc.to/bin/.color.sh)
[ -f ~/.color.sh ] && ( . ~/.color.sh ; clear )

previous="no"
next="no"
last="yes"

#
# command line options
#
for i in "$@"; do
 case "$i" in
 -h|--help|help)
   echo -e "$green`basename $0`$white --help | [options]"
   echo -e ""
   echo -e "Play the correct next (or last or previous) episode of your current TV show."
   echo -e ""
   echo -e "${u}Requirements:${U}"
   echo -e "    1. The program reads a file '${blue}~/current${white}', to look to the directory where that TV show is stored."
   echo -e "    2. Then it reads a '${blue}current_sXXeYY${white}' file on that directory, to know the current season and episode number."
   echo -e "       (if none is there, it assumes ${magenta}season XX=01${white} and ${magenta}episode YY=01${white})"
   echo -e "    3. And then it read a file on directory '${blue}Season_XX/${white}' of the form '${blue}*EYY*.[avi,..]${white}'."
   echo -e ""
   echo -e "${u}Help:${U}"
   echo -e "    ${yellow}help$white	to print this help message (and quit)."
   echo -e ""
   echo -e "${u}Options:${U}"
   echo -e "    ${yellow}next$white	play the next one."
   echo -e "    ${yellow}previous$white	play the previous one."
   echo -e "    ${yellow}last$white	play the last one (default)."
   echo -e ""
   echo -e "Copyrights: (c) Lilian Besson 2011-2014."
   echo -e "Released under the term of the GPL v3 Licence."
   echo -e "In particular, `basename $0` is provided WITHOUT ANY WARANTY."
   exit 0
  ;;
 -n|--next|n|next)	next="yes"; echo -e "${cyan} option next found."; last="no"
  ;;
 -p|--previous|p|previous)	previous="yes"; echo -e "${cyan} option previous found."; last="no"
  ;;
 -l|--last|l|last)	last="yes"
  ;;
 *)
  ;;
 esac
done

echo -e "${yellow}.: Lilian BESSON presents :.$white$reset"
echo -e "Automatic next episode player, v${version}.$white$reset"

# Detection of VLC 2.0+
#( vlc --version 2>/dev/null | grep VLC.*2\.0\.[0-9]*.* >/dev/null && echo -e "$green - vlc 2.0+	is in your $"PATH" :)$reset$white" ) || \
# echo -e "$red Error:$white vlc 2.0+ is not in your $"PATH

# Detection of vrun
#( vrun help | grep "VLM commands" >/dev/null && echo -e "$green - vrun		is in your $"PATH" :)$reset$white" ) || \
# echo -e "$red Error:$white vrun is not in your $"PATH

#
# Current Folder detection.
#
dflt="current_s01e01"

echo -e "Reading ~/current to see the current watched folder..."
current_path="`cat ~/current || echo -e \"$red Error: no ~/current file, using default current_path...$white\" >/dev/stderr`"
# FIXME
current_path="${current_path:-/media/Disque Dur - Naereen/Multimedia/Séries/A VOIR/Stargate SG1/}"

#
# Go to the current folder
#
cd "$current_path" || \
 ( echo -e "${red} Error:$white the folder $u$current_path$U ${red}is not available...$reset$white" ; exit 1 )

echo -e "${blue}I am now in $magenta'`pwd -P`'$white\n"

#
# Find meta data about the possible next episode(s).
#
currents=`find . -type f -iname current_'*'`
[ "0$?" != "00" ] && echo -e "${red} Error:$white no ${black}current_$white file have been found...$reset$white"

for cu in ${currents:-$dflt}; do

 echo -e "${blue}I found '$magenta$cu$white' as possible ${black}current_$white file."

 cu2=`echo $cu | tr A-Z a-z`
 cu2=${cu2#./current_}
 # dont care, lowercase every letters
 echo -e "sSSeEE	---> $u$cu2$U"

 d=${cu2#s}; d=${d%e[0-9]*}
 echo -e "Season :	$d"

 e=${cu2#s[0-9]*e}
 #echo "e=$e"
 e=${e#0*}
 #echo "e=$e"
 #
 # Options.
 #
  # Handling previous one
 if [ "$previous" = "yes" ]; then
  if [ $e -gt 10 ]; then
   e=$(( e - 1 ))
  else
   e=0$(( e - 1 ))
  fi
  echo -e "${cyan} Playing the previous one.$white"
 fi

  # Handling next one
 if [ "$next" = "yes" ]; then
  if [ $e -ge 9 ]; then
   e=$(( e + 1 ))
  else
   e=0$(( e + 1 ))
  fi
  echo -e "${cyan} Playing the next one.$white"
 fi

  # Handling last one
 if [ "$last" = "yes" ]; then
  if [ $e -ge 10 ]; then
   e=$e
  else
   e=0$e
  fi
  echo -e "${cyan} Playing the last one.$white"
 fi

  # If negative, -> 01
 [ ${e#0} -le 0 ] && e=01

 echo -e "Episode:	$e"

 #possibles=`find . -type f -wholename '*'$d'*'/'*'s$d'*'e$e'*'`
 #possibles=`find . -type f -wholename '*'$d'*'/'*'[sS]$d'*'[eE]$e'*'`
 possibles=`find . -type f -wholename '*'$d'*'/'*'$d'*'$e'*' | grep "\(avi\|mp4\|mkv\|AVI\|flv\|wma\)"`

 [ "0$?" != "00" ] && \
  ( echo -e "${red} Error: no next files found for this $black$current_$white file." ; exit 2 )

 [ "0$possibles" = "0" ] && \
  ( echo -e "${red} Error: $"possibles" is empty: no next files for this $black$current_$white file." ; exit 3 )

 echo -e "---> ${blue}I found '${magenta}$possibles$white' as possible next episode(s)."

 # meta=`cat $cu`
 # [ 0"$meta" = "0" ] && echo -e "${reset}No time start data in $magenta$cu$reset... Starting from the beginning.$reset$white"

 # PROPOSAL: on pourrait sauvegarder la position de la lecture, afin de pouvoir reprendre exactement là où on en était.
 # À utiliser: format dernierFichierLu.1h02m23s.position
 # ==> 1*3600 + 02*60 + 23 = 3743s
 # ==> vlc --start-time 3743 dernierFichierLu.avi

 echo "Playing..."
 vlc --fullscreen --no-random --play-and-exit --quiet "$possibles" 2>/tmp/series.sh.log
 echo "Played."

 nextcu="./current_s${d}e${e}"

 #if [ "$next" = "yes" ]; then
 [ "$cu" != "nextcu" ] && mv "$cu" "$nextcu"
 echo -e "${green}OK: the episode have been read, new one is $magenta$nextcu$white"
 #fi

done

echo -e "${yellow} .: Contact naereen[@]crans[.]org for any questions, proposal or bug :.$reset$white"
## END ##
