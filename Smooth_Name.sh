#!/usr/bin/env bash
# author: Lilian BESSON
# email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# date: 18-11-2014
# web: https://bitbucket.org/lbesson/bin/src/master/Smooth_Name.sh
#
# A small script to rename all files in a directory semi-automatically.
# The main purpose is to smooth filenames in order for generatejplayer to work more nicely.
#
# WARNING: the files are renamed (ie. move in place) with no control : it might NOT work.
#
# Requires [smoothnameone.sh](https://bitbucket.org/lbesson/bin/src/master/smoothnameone.sh)
#
# Licence: GPL v3
#
version='1.2'
LANG='fr'

if [ "${1}" = "--batch" ]; then
    echo -e "Nothing asked to the user : batch mode (option --batch)."
    MV="mv -vf"
    shift
elif [ "${1}" = "--test" ]; then
    echo -e "Just a test (option --test)."
    MV="echo mv -vf"
    shift
elif [ "${1}" = "--onlyfiles" ]; then
    echo -e "Working only on files (option --onlyfiles)."
    MV="mv -vf"
    onlyfiles="true"
    shift
else
    MV="mv -vi"
fi

# Change sub-directory
all=`find . -type d -iname [A-Za-z]'*'`
all="${all//' '/%20}"

for i in ${all}; do
    i="${i//'%20'/ }"
    # i="${i#./}"
    echo -e "${green}Working with the directory ${u}'${i}'${U}.${white}"
    echo mv -vi "$i" "$(smoothnameone.sh "$i")"
    $MV "$i" "$(smoothnameone.sh "$i")"
done

# Change content
all=`find . -type f -iname '*'.mp3 -o -iname '*'.avi -o -iname '*'.mkv -o -iname '*'.wma -o -iname '*'.srt -o -iname '*'.png -o -iname '*'.jpg -o -iname '*'.jpeg -o -iname '*'.txt -o -iname '*'.mp4`
all="${all//' '/%20}"

for i in ${all}; do
# for i in *.mp3; do
    i="${i//'%20'/ }"
    # i="${i#./}"
    echo -e "${black}Working with the file ${magenta}${u}'${i}'${U}${white}."
    # echo $MV "$i" "$(smoothnameone.sh "$i")"
    if [ "X$onlyfiles" = "Xtrue" ]; then
        $MV "$i" "$(smoothnameone.sh --file "$i")"
    else
        $MV "$i" "$(smoothnameone.sh "$i")"
    fi
done

# END
