#!/usr/bin/env bash
# author: Lilian BESSON
# email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# date: 05-11-2015
# web: https://bitbucket.org/lbesson/bin/src/master/youtube-playlist.sh
#
# A small script to download every song from a YouTube playlist,
# based on [youtube-dl](http://yt-dl.org/), which is awesome,
# but weirdly fails to download a simple playlist.
#
# My script asks confirmation before any action, so nothing is deleted or moved
# without warning you before (can be disabled by passing the CLI '--batch' option).
#
# Example:
# $ youtube-playlist.sh https://www.youtube.com/playlist?list=PLPtDOWi65kraB9AgUkcN9NkwIsiT6NRnb
# --> will download every 86 songs from that playlist.
# $ youtube-playlist.sh PL589D19730F7CDB2F PL67184C9F3B209EF4
# --> will download all the songs from these two YouTube playlists.
#
# Requires wget and [youtube-dl](http://yt-dl.org/),
# and my [smoothnameone.sh](https://bitbucket.org/lbesson/bin/src/master/smoothnameone.sh) to slugify the folder names
# Uses [Smooth_Name.sh](https://bitbucket.org/lbesson/bin/src/master/Smooth_Name.sh)
# also if possible to slugify the names of the downloaded songs.
#
# This script is used by youtube-albums to download every playlists
# from one band (cf. https://bitbucket.org/lbesson/bin/src/master/youtube-albums.sh)
#
# Licence: GPL v3
#
version='1.1'
LANG='fr'

# Destination of the HTML file (a unique, to avoid conflict if running several instances of youtube-playlist.sh at the same time)
# out="${tempfile}"
out="/tmp/youtube-playlist.tmp$$.html"
if [ "${1}" = "--batch" ]; then
    READ="echo -e 'Nothing asked to the user : batch mode (option --batch).'"
    shift
else
    READ="read"
fi
icon=$(ls -H /usr/share/icons/*/*/*/*music*svg 2>/dev/null|uniq|head -n1)

dlplaylist() {
    echo -e "${white}Trying to download the playlist : '${blue}${1}${white}'..."
    # Try to download it according to the args passed to the script
    wget "${1}" -O "${out}" || wget "https://www.youtube.com/playlist?list=${1}" -O "${out}"

    # Then parsing it and downloading every songs
    number=$(for j in $(grep -o "watch?v=[a-zA-Z0-9_-]*" "${out}"  | sed s/'watch?v='// | uniq); do echo "$j"; done | wc -l)
    echo -e "I found ${green}${number}${white} different songs in this playlist, is it correct ?"
    echo -e "(${magenta}[Enter]${white} to continue, ${magenta}[Ctrl+C]${white} to cancel)."
    $READ || exit

    # Ask for confirmation
    echo -e "Just to be sure, I am showing you the downloading commands I will execute : (${magenta}[Enter]${white} to see)."
    $READ || exit
    for j in $(grep -o "watch?v=[a-zA-Z0-9_-]*" "${out}"  | sed s/'watch?v='// | uniq); do
        echo -e youtube-dl --no-overwrites --retries 60 --continue -o "%(title)s.%(ext)s" --extract-audio --console-title --audio-format=mp3 -w -- "$j"
    done

    echo -e "Are you OK with these downloading commands ? (${magenta}[Enter]${white} if OK)."
    $READ || exit

    # Create the directory
    title=$(grep "<title>" "${out}" | head | sed s/"<title>"// | sed s/"^[ ]*"//)
    echo -e "Apparently, the playlist's title is : '${yellow}${title}${white}'. Are you OK with it ? (${magenta}[Enter]${white} if OK)."
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
    for j in $(grep -o "watch?v=[a-zA-Z0-9_-]*" "${out}"  | sed s/'watch?v='// | uniq); do
        time youtube-dl --no-overwrites --retries 60 --continue -o "%(title)s.%(ext)s" --extract-audio --console-title --audio-format=mp3 -w -- "$j" || echo "$j" >> tofetch_youtube-dl.url
    done

    # Change the name of every songs
    echo -e "Apparently, I am done downloading. Can I try to smooth the name of every files I got ? (${magenta}[Enter]${white} if OK)."
    $READ || exit
    Smooth_Name.sh --batch --onlyfiles

    echo -e "Bybye :)"
}
# Enf of dlplaylist()

#######
# Start
echo -e "${0} have been called with the arguments (after processing the options) : ${blue}$*${white}." | tee -a /tmp/youtube-playlist.log

for i in "$@"; do
    echo -e "Calling the function ${magenta}'dlplaylist'${white} for the argument ${u}'${i}'${U} (on pwd = $(pwd))..." | tee -a /tmp/youtube-playlist.log
    dlplaylist "$i" && \
        notify-send --expire-time=3000 --icon=${icon} "youtube-playlist.sh" "Download of the YouTube playlist ${i} well done"
    echo -e "Done for ${magenta}'dlplaylist'${white} on ${u}'${i}'${U}..." | tee -a /tmp/youtube-playlist.log
done
