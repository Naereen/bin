#!/usr/bin/env bash
# author: Lilian BESSON
# email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# date: 11-10-2014
# web: https://bitbucket.org/lbesson/bin/src/master/youtube-albums.sh
#
# A small script to download every album/playlist from a Youtube page, based on [youtube-dl](http://yt-dl.org/),
# which is awesome, but fails to every music track from a Youtube page.
#
# Example : https://www.youtube.com/channel/UCCR7DJUk70fWSs05WIujdiw/playlists?sort=dd&shelf_id=3579731707244514300&view=50 will download every Neil Diamond albums.
#
# Requires [youtube-playlist.sh](https://bitbucket.org/lbesson/bin/src/master/youtube-playlist.sh).
# Uses [Smooth_Name.sh](https://bitbucket.org/lbesson/bin/src/master/Smooth_Name.sh) also if possible.
#
# Licence: GPL v3
#
version='0.1'
LANG='fr'

clear
# Destination of the HTML file
out="/tmp/youtube-albums.tmp.html"
if [ "${1}" = "--batch" ]; then
    READ="echo -e 'Nothing asked to the user : batch mode (option --batch).'"
    shift
else
    READ="read"
fi
icon=$(ls -H /usr/share/icons/*/*/*/*music*svg 2>/dev/null|uniq|shuf|head -n1)

echo -e "${white}Trying to download the albums : '${blue}${1}${white}'..."
# Try to download it according to the args passed to the script
wget "${1}" -O "${out}" || wget "https://www.youtube.com/channel/${1}/playlists" -O "${out}"

# Then parsing it and downloading every playlists
number=$(for j in $(grep -o "playlist?list=[a-zA-Z0-9_-]*" "${out}"  | sed s/'playlist?list='// | uniq); do echo "$j"; done | wc -l)
echo -e "I found ${green}${number}${white} different playlists in this Youtube page, is it correct ?"
echo -e "(${magenta}[Enter]${white} to continue, ${magenta}[Ctrl+C]${white} to cancel)."
$READ || exit

# Ask for confirmation
echo -e "Just to be sure, I am showing you the downloading commands I will execute : (${magenta}[Enter]${white} to see)."
$READ || exit
for j in $(grep -o "playlist?list=[a-zA-Z0-9_-]*" "${out}"  | sed s/'playlist?list='// | uniq); do
    echo -e youtube-playlist.sh --batch "$j"
    # echo -e youtube-dl -o "%(title)s.%(ext)s" --extract-audio --console-title --audio-format=mp3 -w "$j"
done

echo -e "Are you OK with these downloading commands (using ${u}youtube-playlist.sh${U}) ? (${magenta}[Enter]${white} if OK)."
$READ || exit

# Create the directory
title=$(grep "<title>" "${out}" | head | sed s/"<title>"// | sed s/"^[ ]*"// | sed s/" – Sujet"// | sed s/" - Topic"// )
echo -e "Apparently, the channel/author title is : '${yellow}${title}${white}'. Are you OK with it ? (${magenta}[Enter]${white} if OK)."
$READ || exit

newdir="$(smoothnameone.sh "$title")"
echo -e "There I will try to make and use the (new) directory : '${blue}${newdir}${white}'. Are you OK with it ? (${magenta}[Enter]${white} if OK)."
$READ || exit
mkdir "${newdir}"

# « I'm going it ! »
cd "${newdir}" || exit
echo -e "Now, I am in the directory ${blue}`pwd`${white}, and this is good."

# Start downloading !
echo -e "OK, so I can start the downloading command I showed you : (${magenta}[Enter]${white} to see)"
for j in $(grep -o "playlist?list=[a-zA-Z0-9_-]*" "${out}"  | sed s/'playlist?list='// | uniq); do
    time youtube-playlist.sh --batch "$j" && \
        notify-send --expire-time=3000 --icon=${icon} "youtube-albums.sh" "Download well done for the album ${j} (by the artist ${title})."
done

# Change the name of every songs
echo -e "Apparently, I am done downloading. Can I try to smooth the name of every files I got ? (${magenta}[Enter]${white} if OK)."
$READ || exit
time Smooth_Name.sh --batch

# Generate the HTML/js player
echo -e "Apparently, I am done downloading and smoothing names. Can I try to generate a HTML/js player for all these albums ? (${magenta}[Enter]${white} if OK)."
$READ || exit
time generatejplayer.sh

notify-send --expire-time=3000 --icon=${icon} "youtube-albums.sh" "Download well done for all the albums ${j} of the artist ${title}.\nThere is now $(find ./${newdir}|wc -l) new tracks, for a total of $(du -kh ./${newdir}|tail -n1| grep -o -m1 "^[0-9][,0-9]*[KMG]\?").\n → Well done :)"
echo -e "Bybye :)"
# END
