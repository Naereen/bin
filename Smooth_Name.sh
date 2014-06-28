#!/usr/bin/env bash
# author: Lilian BESSON
# email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# date: 28-06-2014
# web: https://bitbucket.org/lbesson/bin/Smooth_Name.sh
#
# A small script to rename all files in a directory semi-automatically.
# The main purpose is to smooth filenames in order for generatejplayer to work more nicely.
#
# Warning: the files are renamed (ie. move in place) with no control : it might NOT work.
#
# Licence: GPL v3
#
version='0.1'
LANG='fr'

# */*.mp3 */*/*.mp3 */*/*/*.mp3 */*/*/*/*.mp3

renameMP3 () {
    for i in *.mp3; do
        echo -e "${green}Working with the file ${u}'${i}'${U}.${white}"
        mv -vf "$i" "${i// /_}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//_-_/__}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//\~/_}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//,/_}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//\&/and}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//é/e}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//è/e}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//ê/e}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//à/a}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//ù/u}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//\'/}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//\(/_}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//\)/_}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//\[/_}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//\]/_}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//@/}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//-_ /_}"
    done
    for i in *.mp3; do
        mv -vf "$i" "${i//___/_}"
    done
}

# find . -type d -exec renameMP3 {} \;

renameMP3

# END