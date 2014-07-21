#!/usr/bin/env bash
# author: Lilian BESSON
# email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# date: 20-07-2014
# web: https://bitbucket.org/lbesson/bin/src/master/youtube-playlist.sh
#
# A small script to download every song from a Youtube playlist, based on [youtube-dl](http://yt-dl.org/),
# which is awesome, but fails to download a simple playlist.
#
# Example : https://www.youtube.com/playlist?list=PL589D19730F7CDB2F will download every 86 songs.
#
# Uses [Smooth_Name.sh](https://bitbucket.org/lbesson/bin/src/master/Smooth_Name.sh) also if possible.
#
# Licence: GPL v3
#
version='0.1'
LANG='fr'

# Destination of the HTML file
out="/tmp/youtube-playlist.tmp.html"

echo -e "${white}Trying to download the playlist : '${blue}${1}${white}'..."
# Try to download it according to the args passed to the script
wget "${1}" -O "${out}" || wget "https://www.youtube.com/playlist?list=${1}" -O "${out}"

# Then parsing it and downloading every songs
number=$(for j in $(grep -o "watch?v=[a-zA-Z0-9_-]*" /tmp/l.html  | sed s/'watch?v='// | uniq); do echo "$j"; done | wc -l)
echo -e "I found ${green}${number}${white} different songs in this playlist, is it correct ?"
echo -e "(${magenta}[Enter]${white} to continue, ${magenta}[Ctrl+C]${white} to cancel)."
read || exit

# Ask for confirmation
echo -e "Just to be sure, I am showing you the downloading commands I will execute : (${magenta}[Enter]${white} to see)."
read || exit
for j in $(grep -o "watch?v=[a-zA-Z0-9_-]*" /tmp/l.html  | sed s/'watch?v='// | uniq); do
    echo -e youtube-dl -o "%(title)s.%(ext)s" --extract-audio --console-title --audio-format=mp3 -w "$j"
done

echo -e "Are you OK with these downloading commands ? (${magenta}[Enter]${white} if OK)."
read || exit

# Create the directory
title=$(grep "<title>" /tmp/l.html | head | sed s/"<title>"// | sed s/"^[ ]*"//)
echo -e "Apparently, the playlist's title is : '${yellow}${title}${white}'. Are you OK with it ? (${magenta}[Enter]${white} if OK)."
read || exit

newdir="$(smoothnameone.sh "$title")"
echo -e "There I will try to make and use the (new) directory : '${blue}${newdir}${white}'. Are you OK with it ? (${magenta}[Enter]${white} if OK)."
read || exit
mkdir "${newdir}"

# « I'm going it ! »
cd "${newdir}" || exit
echo -e "Now, I am in the directory ${blue}`pwd`${white}, and this is good."

# Start downloading !
echo -e "OK, so I can start the downloading command I showed you : (${magenta}[Enter]${white} to see)"
for j in $(grep -o "watch?v=[a-zA-Z0-9_-]*" /tmp/l.html  | sed s/'watch?v='// | uniq); do
    youtube-dl -o "%(title)s.%(ext)s" --extract-audio --console-title --audio-format=mp3 -w "$j"
done

# Change the name of every songs
echo -e "Apparently, I am done downloading. Can I try to smooth the name of every files I got ? (${magenta}[Enter]${white} if OK)."
read || exit
Smooth_Name.sh

# END