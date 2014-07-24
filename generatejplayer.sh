#!/usr/bin/env bash
#
# Author: Lilian BESSON
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Date: 23-04-2013
# Web version: http://besson.qc.to/bin/generatejplayer.sh
# Web version (2): https://bitbucket.org/lbesson/bin/src/master/generatejplayer.sh
#
# Auto generate an 'index.html' page to show and play music with jplayer.
#
# A demo is here : http://besson.qc.to/generatejplayer.sh
# Last version is here : http://besson.qc.to/bin/generatejplayer.sh
# with stylesheets and templates is here : http://besson.qc.to/bin/generatejplayer/
#
version='1.6'

GeneratejPlayer() {
	# Go to the directory.
	p="`pwd`"
	if [ -d "$*" ]; then cd "$*"; fi

	pathtobechanged="$(pwd)"
	pathtobechanged="${pathtobechanged// /%20}"
	echo -e "Working for the directory ${cyan} : ${pathtobechanged}${white}."

	# Header
	currentdir="`basename \"\`pwd -P\`\"`"
	currentdir="${currentdir#./}"
	cat ~/bin/generatejplayer/header.html \
	 | sed s{VERSION{"$version"{ \
	 | sed s{CURRENTDIR{"$currentdir"{ \
	 | sed s_DATE_"`date +\" %d %b %Y, à %Hh:%Mm:%Ss\"`"_ > index.html

	# Listing of music (and playlist) (with jquery.jplayer.js)
	targets=`find . -maxdepth 1 -type f -iname '*'.mp3 -o -iname '*'.ogg -o -iname '*'.wav -o -iname '*'.wma 2>/dev/null`
	taille="$(du -c -h *.mp3 2>/dev/null| tail -n 1 | grep -o -m 1 "^[0-9][,0-9]*[KMG]\?")"
	echo -e "Total size for all musics (*.mp3) = $taille."

	if [ "X${targets//'%20'/}" != "X" ]; then
		 # Jplayer Header
		 cat ~/bin/generatejplayer/jplayerheader.html >> index.html
		 targets="${targets//' '/%20}"
		 targets="${targets//'&'/&amp;}"
		 nombre=`echo $targets | tr A-Z a-z | grep -o "\(mp3\|ogg\|wav\|wma\)" | wc -l`

		 # header.html ends with an open <script> balise
		 echo -e "console.log(\"[INFO] content add by generatejplayer.js starts now.\");" >> index.html
		 # # echo -e "\$(document).ready(function() {" >> index.html

		 # Generate the playlist.
		 for i in $targets; do
		 	  artist=""
			  ibetter="${i//'%20'/ }"
		 	  ibetter="${ibetter//'&amp;'/&}"
		 	  # # Find the title.
		 	  # # title="`exiftool -b -Title \"${ibetter}\"`"
		 	  # # title="${title:-$ibetter}"
		 	  title="${ibetter}"
		 	  # # Find the author / artist.
		 	  # # artist="`exiftool -b -Artist \"${ibetter}\"`"
		 	  artist="${artist:-Unknown}"
		 	  # # Find the year.
		 	  # # year="`exiftool -b -Year \"${ibetter}\"`"
		 	  if [ "X${year//' '/}" != "X" ]; then
		 	  	artist="${artist} (in ${year:-?})"
		 	  	year=", year: \"${year}\""
		 	  fi
		 	  # Pretty print the title
			  title=${title//_/ }
			  extension=${title: -3}
			  title="${title%$extension}"
			  # title="${title%.mp3}"
			  # FIXME just mp3 for now, others not supported yet
			  # title="${title%.wav}"
			  # title="${title%.wma}"
			  # title="${title%.ogg}"
			  title="${title#./}"
			  # A try: it is useless to keep 'Unknow'
			  if [ "X$artist" = "XUnknown" ]; then
			  	  artist=""
			  else
			 	  artist=", artist:\"${artist}\""
			  fi
			  # FIXME: we add the key mp3 and value ${i}, but maybe the file is not in mp3 ? I'm trying to solve this
			  # OK: this adds wma:"url" but it still does not work !
			  if [ "X$extension" = "Xmp3" ]; then
				  echo -e "myPlaylist.add({${extension}:\"${i}\", title:\"${title}\"${artist}, free:true});" >> index.html
				  echo -e "Adding ${u}${i}${U}, title: ${blue}${title}${white}${black}${artist}${white}${magenta}${year}${white}"
			  fi
		 done

		 # echo -e "}); // Close the '\$(document).ready(function() {' body." >> index.html
		 echo -e "</script><noscript>Javascript est requis pour cet exemple." >> index.html

		 # Print the list of files.
		 echo -e "<h2>(Javascript est désactivé!)</h2>" >> index.html
		 if (( nombre > 1 )); then
			 echo -e "<br><hr><h2>Liste des morceaux (au nombre de $nombre) : ($taille) </h2>" >> index.html
		 elif (( nombre == 1 )); then
			 echo -e "<br><hr><h2>Liste du morceau : ($taille) </h2>" >> index.html
		 fi
		 echo -e "<ul class=\"gallery\">" >> index.html

		 for i in $targets; do
			  title=${i//'%20'/ }
			  title=${title//_/ }
			  title="${title%.mp3}"
			  title="${title%.ogg}"
			  title="${title%.wav}"
			  title="${title%.wma}"
			  title="${title#./}"
			  echo -e "<li><a href=\"${i}\" title=\"${title}\">${i//'%20'/ }</a></li>" >> index.html
		 done
		 echo -e "</ul><br>" >> index.html
		 echo -e "</noscript>" >> index.html
	fi

	# Listing of sub directories
	targets=`find . -maxdepth 1 -type d -iname '*'[A-Za-z]'*' 2>/dev/null`

	targets=${targets//' '/%20}
	targets="${targets//'&'/&amp;}"
	echo -e $red$targets$white > /dev/stderr

	if [ "X$targets" != "X" ]; then

		nombre=`echo $targets | grep -o ./ | wc -l`
		taille="$(du -c -h ./ | tail -n 1 | grep -o -m 1 "^[0-9][,0-9]*[KMG]\?")"
		echo -e "Total size for the directory ./ = $taille."

		if (( nombre > 0 )); then
			echo -e "<br><hr><br><div class=\"subdirs\" style=\"color: white\"><h2>Liste des sous-dossiers (au nombre de $nombre, $taille) :</h2>" >> index.html
		else
			echo -e "<br><hr><br><div class=\"subdirs\" style=\"color: white\"><h2>Un sous-dossier ($taille) :</h2>" >> index.html
		fi

		echo -e "<span style=\"font-size: 130%\"><ul>" >> index.html
		echo -e "<li><a href=\"../index.html\" title=\"Dossier parent !\">..</a> (dossier parent)</li>" >> index.html

		# For every sub directories
		for d in $targets; do
		 	dossier="${d//'%20'/ }"
			dossier=${dossier//'&amp;'/&}

			taille="$(du -c -h "${dossier}/" | tail -n 1 | grep -o -m 1 "^[0-9][,0-9]*[KMG]\?")"
			echo -e "Total size for the sub-directory "${dossier}/" = $taille."

		 	subphotos=`find "${dossier}" -maxdepth 1 -type f -iname '*'.mp3 -o -iname '*'.ogg -o -iname '*'.wav -o -iname '*'.wma 2>/dev/null`
		 	nombrephotos=`echo $subphotos | tr A-Z a-z | grep -o "\(mp3\|ogg\|wav\|wma\)" | wc -l`
		 	subdirs=`find "${dossier}" -maxdepth 1 -type d -iname '*'[A-Za-z]'*' 2>/dev/null`
		 	nombredirs=`echo $subdirs | grep -o ./ | wc -l`
		 	nombredirs=$(( nombredirs / 2 )) # does not count itself ? FIXME

			dossier="${dossier%/}"
			dossier="${dossier#./}"
			dossier="${dossier//_/ }"

			d="${d}/index.html"

		 	# Adapt what to print according to the number of subdirs and photos
			if (( nombrephotos > 1 )); then
				if (( nombredirs > 1 )); then
		 			echo -e "<li><a href=\"${d}\">${dossier}</a> (${nombrephotos} chansons, ${nombredirs} sous-dossiers, $taille)</li>" >> index.html
		 		elif (( nombredirs == 1 )); then
		 			echo -e "<li><a href=\"${d}\">${dossier}</a> (${nombrephotos} chansons, 1 sous-dossier, $taille)</li>" >> index.html
		 		else
		 			echo -e "<li><a href=\"${d}\">${dossier}</a> (${nombrephotos} chansons, $taille)</li>" >> index.html
		 		fi
		 	elif (( nombrephotos == 1 )); then
				if (( nombredirs > 1 )); then
		 			echo -e "<li><a href=\"${d}\">${dossier}</a> (1 chanson, ${nombredirs} sous-dossiers, $taille)</li>" >> index.html
		 		elif (( nombredirs == 1 )); then
		 			echo -e "<li><a href=\"${d}\">${dossier}</a> (1 chanson, 1 sous-dossier, $taille)</li>" >> index.html
		 		else
		 			echo -e "<li><a href=\"${d}\">${dossier}</a> (1 chanson, $taille)</li>" >> index.html
		 		fi
		 	else
				if (( nombredirs > 1 )); then
		 			echo -e "<li><a href=\"${d}\">${dossier}</a> (${nombredirs} sous-dossiers, $taille)</li>" >> index.html
		 		elif (( nombredirs == 1 )); then
		 			echo -e "<li><a href=\"${d}\">${dossier}</a> (1 sous-dossier, $taille)</li>" >> index.html
		 		fi
		 	fi

		 	echo -e "For ${u}${dossier}${U}: ${yellow}${nombrephotos}${white} chansons, ${magenta}${nombredirs}${white} subdirs."

		 	#echo -e "<li><a href=\"${d}/\" title=\"Descendre dans ce dossier !\">${title}/index.html</a></li>" >> index.html
			# FIXME here we force the destination to be ${d}/index.html
		done
		echo -e "</ul></span></div><br>" >> index.html
	fi

	# To include pictures like AlbumArtSmall.jpg, AlbumCover.jpg, Folder.jpg (FIXME still experimental)
	pictures=`find ./ -maxdepth 1 -type f  -iname Folder'*'.jpg -o -iname Album'*'.jpg 2>/dev/null`
	echo -e "${cyan}Potential AlbumArt: ${yellow}${u}${pictures}${U}${white}..."
	# Find the images
	for image in $pictures; do
		metadata=`identify "$image"`
		size=`expr "$metadata" : ".*\( [0-9]\+x[0-9]\+\)"`
		size="${size# }"
		image=${image//' '/%20}
		echo -e "${magenta}Size for the AlbumArt ${cyan}${image}: ${yellow}${u}${size}${U}${white}..."
	done
	# Add the last one. FIXME update height widht according to the right size.
	echo -e "<br><hr><div class=\"FolderImage\" style=\"text-align: center\">\
		\n\t<img src=\"./${image}\" height=\"225\" width=\"255\" alt=\"Folder Image default value\"/></div>" >> index.html

	# Conclude
	echo -e "<script type=\"text/javascript\">" >> index.html
	echo -e "console.log(\"[INFO] content add by generatejplayer.js stops now.\");" >> index.html

	# Footer starts with a JS line and then a closed </script> balise
	pathtobechanged="$(pwd)"
	pathtobechanged="${pathtobechanged#/home/lilian/Music/}"
	cat ~/bin/generatejplayer/footer.html \
	 | sed s{PATHTOBECHANGED{"$pathtobechanged"{ \
	 >> index.html
	# PATHTOBECHANGED

	pathtobechanged="$(pwd)"
	pathtobechanged="${pathtobechanged// /%20}"
	echo -e "index.html have been generated in ${cyan} : ${pathtobechanged}${white}."

	# Come back.
	cd "$p"
}

# Find every folder. Warning: in a folder like / or /home/user/ the script can run for a VERY LONG TIME !
# FIXED
pathtobechecked="$(pwd)"
pathtobechecked="${pathtobechecked#/home/lilian/Music/}"
if [ ! /home/lilian/Music/"${pathtobechecked}" = "$(pwd)" ]; then
	echo -e "${red} Warning: seems to be launched from elsewhere than ${u}/home/lilian/Music/${U} (and that's bad).${white}"
	read -t 10 -p "Cancel ? [Y/n] " ANSWER
	case "$ANSWER" in
	 	n*)
			echo -e "${red}Not cancelling...${white}"
	 		;;
	 	*)
			echo -e "${red}Cancelling...${white}"
			exit 1
	 		;;
	 esac
fi

targets=`find . -type d`
targets=${targets//' '/%20}
echo -e "${blue}${targets}${white}"

# TO find every concerned directory
for i in $targets; do
	direction=${i//'%20'/ }
	echo -e "For the directory ${blue}'${direction}'${white}........."

	( time GeneratejPlayer "${direction}" ) 2>&1 | tee "${direction}/generatejplayer.log"
	grep -a "^real[0-9a-z \t\.]*" "${direction}/generatejplayer.log" > "${direction}/generatejplayer.time"
	# Coloring the log.
	cat "${direction}/generatejplayer.log" \
		| sed s_"./"_"http://./"_ \
		| sed s_"/home/lilian/Music/"_"http://127.0.0.1/music/"_ \
		| ansi2html -a \
		| sed s_"http://./"_"./"_ \
		| sed s_"http://./"_"./"_ \
		| sed s_"http://.http://"_"http://"_ \
		| sed s_"http://.http://"_"http://"_ \
		> "${direction}/generatejplayer.html"
	cp "${direction}/index.html" "${direction}/index.html~"
	cat "${direction}/index.html~" \
		| sed s_TIMESPENT_"`cat \"${direction}/generatejplayer.time\"`"_ \
		> "${direction}/index.html"
done

# END