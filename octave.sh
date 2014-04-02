#!/bin/bash

# Un lanceur amélioré pour GNU Octave.
# Permet de faire débuter ses scripts par '#!/chemin/vers/.octave.sh'
#  Il est conçu pour être utilisé sur Ubuntu, avec Octave 3+

# Écrit par Lilian BESSON
#  Naereen Corp. (c) 2013
# v1 mar. 05 févr. 2013 23:09:11 CET 


Date=`date`
Pwd=`pwd -P`
green='\033[01;32m'

echo -e "${green}Lancement d'Octave dans $Pwd...\033[0m"

xtitle ".: Octave (-q -V --traditional --persist) 3.2.4 on $Pwd. $Date, by $USER@$HOSTNAME :."

octave --silent --verbose --traditional --persist "$@" ##2> /tmp/octave.sh.log.m
reponse="$?"
##pygmentize -f terminal256 -g /tmp/octave.sh.log.m

if [ ! "X$reponse" = "X0" ]; then
 green='\033[01;31m'
fi

echo -e "Octave 3.2.4 on $Pwd. It was launched $Date, by $USER@$HOSTNAME \n${green}>>> OUT (return code $reponse)"
exit $reponse
# DONE
