#!/usr/bin/env bash
# author: Lilian BESSON
# email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# date: 09-12-2014
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
version='1.3'
LANG='fr'
log=/tmp/$(basename $0).log

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
allfolder=`find . -type d -iname [A-Za-z]'*'`
allfolder="${allfolder//' '/%20}"

for folder in ${allfolder}; do
    folder="${folder//'%20'/ }"
    # folder="${folder#./}"
    newfolder="$(smoothnameone.sh "${folder}")"
    echo -e "${green}Working with the directory ${u}'${folder}'${U}.${white}"
    echo mv -vi "${folder}" "${newfolder}"
    $MV "${folder}" "${newfolder}"
    folder="${newfolder}"

    # Change content
    allfile=`find "${folder}"/ -type f`
    # allfile=`find "${folder}"/ -type f -iname '*'.mp3 -o -iname '*'.avi -o -iname '*'.mkv -o -iname '*'.wma -o -iname '*'.srt -o -iname '*'.png -o -iname '*'.jpg -o -iname '*'.jpeg -o -iname '*'.txt -o -iname '*'.mp4`
    allfile="${allfile//' '/%20}"

    for file in ${allfile}; do
    # for file in *.mp3; do
        file="${file//'%20'/ }"
        # file="${file#./}"
        echo -e "${black}Working with the file ${magenta}${u}'${file}'${U}${white}."
        # echo $MV "$file" "$(smoothnameone.sh "$file")"
        if [ "X$onlyfiles" = "Xtrue" ]; then
            $MV "$file" "$(smoothnameone.sh --file "$file")" 2>>$log
            # Réf: http://abs.traduc.org/abs-5.3-fr/ch19.html#ioredirref
        else
            $MV "$file" "$(smoothnameone.sh "$file")" 2>>$log
        fi
    done
done


# END
