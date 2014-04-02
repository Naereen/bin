#!/bin/sh
#
# (c) Lilian BESSON, 2011-13
# http://besson.qc.to/

# To simplify synchronisation
# This script is released on the public domain under the term of the GPL v3
#  License. Feel free to use it, to modify it, and to redistribute it !

alias CP='/usr/bin/rsync --verbose --times --compress --human-readable --progress'

at="@"
Szam="besson${at}zamok.crans.org:~/www/"
Sdpt="lbesson${at}ssh.dptinfo.ens-cachan.fr:~/public_html/"

echo "Synchronisation : begining...."

echo "Now with ssh.dptinfo...."

#echo '1. CP -r ~/cours1m1/* "${Sdpt}cours1m1/"'
#CP -r ~/cours1m1/* "${Sdpt}cours1m1/"
#echo ''

echo '2. CP -r ~/cours2m1/* "${Sdpt}cours2m1/"'
CP -r ~/cours2m1/* "${Sdpt}cours2m1/"
echo ''

echo '3. CP -r ~/stage/* "${Sdpt}stage/"'
CP -r ~/stage/* "${Sdpt}stage/"
echo ''


echo "Now with zamok...."

#echo '1. CP -r ~/cours1m1/* "${Szam}cours1m1/"'
#CP -r ~/cours1m1/* "${Szam}cours1m1/"
#echo ''

echo '2. CP -r ~/cours2m1/* "${Szam}cours2m1/"'
CP -r ~/cours2m1/* "${Szam}cours2m1/"
echo ''

echo '3. CP -r ~/stage/* "${Szam}stage/"'
CP -r ~/stage/* "${Szam}stage/"
echo ''

echo "Synchronisation is done.... good !"
# DONE