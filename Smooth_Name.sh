#!/usr/bin/env bash
# author: Lilian BESSON
# email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# date: 20-07-2014
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
version='1.1'
LANG='fr'

# Change sub-directory
all=`find . -type d -iname [A-Za-z]'*'`
all="${all//' '/%20}"

for i in ${all}; do
    i="${i//'%20'/ }"
    echo -e "${green}Working with the directory ${u}'${i}'${U}.${white}"
    echo mv -vi "$i" "$(smoothnameone.sh "$i")"
    mv -vi "$i" "$(smoothnameone.sh "$i")"
done

# Change content
all=`find . -type f -iname '*'.mp3 -o -iname '*'.avi -o -iname '*'.mkv -o -iname '*'.wma -o -iname '*'.srt -o -iname '*'.png -o -iname '*'.jpg -o -iname '*'.jpeg -o -iname '*'.txt`
all="${all//' '/%20}"

for i in ${all}; do
# for i in *.mp3; do
    i="${i//'%20'/ }"
    echo -e "${black}Working with the file ${white}${u}'${i}'${U}${black}."
    # echo mv -vi "$i" "$(smoothnameone.sh "$i")"
    mv -vi "$i" "$(smoothnameone.sh "$i")"
done

# END