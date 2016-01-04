#!/usr/bin/env bash
# __author__='Lilian Besson'
# __email__='lilian DOT besson AT normale DOT fr'
# __date__='monday 08/07/2013 at 14h:56m:39s '
# __webaddress__='http://perso.crans.org/besson/bin/CheckDownload_Pypi.sh'
# __license__='GPL v3'
#
# A simple script to count the number of downloads for a PyPi package
#


if [ "0$1" = "0" ]; then
 package='ANSIColors-balises'
else
 package="$1"
fi

echo -e "$reset${white}For the package $neg$package$Neg (hosted on ${u}https://pypi.python.org/pypi/$package${U}) :"

webquery=`wget https://pypi.python.org/pypi/"$package" -q -O - | \
 grep -Eo '<span>[0-9]*</span> downloads in the last.*'`

if [ "X$?" = "X0" ]; then
 echo -e "$webquery" | \
 sed s{'<span>'{' * '{ | \
 sed s{'</span>'{'\t'{
else
  echo -e "${red}No connection$reset$white"
  exit 18
fi
