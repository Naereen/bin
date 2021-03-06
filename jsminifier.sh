#!/usr/bin/env bash
# (C) Lilian BESSON, 2013-2017
# A minimalist cli client to the web service https://javascript-minifier.com
# Latest version of http://perso.crans.org/besson/bin/jsminifier.sh
#
clear

script=$1
if [ "X$script" = "X" ]; then
	echo -e "Which javacript to minify?"
	read script
fi

echo -e "Working with script=${script}."
echo -e "Sending a POST request to javascript-minifier.com, all right?"

desti="${script%.js}.min.js"
ans=no
while [ "X${ans:0:1}" != "XY" ] && [ -f "${desti}" ]; do
	echo -e "Destination file ${desti} is already there, erase it ? [Y/n]"
	read ans
	echo -e "Answer=${ans}"
	if [ "X${ans:0:1}" = "XY" ]; then
		echo -e "Ok erase it"
	else
		echo -e "Ok not erase it, please give me an other destination file :"
		read desti
	fi
done

echo -e "Output will be ${desti}. Are you sure ?"
read

#curl -X POST -s --data-urlencode "input=`cat ${script}`" https://javascript-minifier.com/raw > "${desti}" && \

curl -v -X POST -s --data-urlencode input@"${script}" https://javascript-minifier.com/raw > "${desti}" && \
chmod --preserve-root -c --reference="${script}" "${desti}" && \
ls --color=always -larth "${script}" "${desti}" && \
echo -e "${script} -> ${desti}: well compressed."

# END