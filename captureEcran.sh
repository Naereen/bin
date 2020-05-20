#! /usr/bin/env /bin/bash
#
# Author: Lilian BESSON
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Date: 28-10-2014
#
# A small script to make a screenshot, designed to be assigned to a specific button or combinaison of button on Linux (XUbuntu 14+).
#

notify-send "Capture d'écran" "3 secondes d'attente avant la capture d'écran..."
echo -e "Waiting 3s before taking a screenshot (with xfce4-screenshooter, or gnome-screenshot)."
sleep 3s
( xfce4-screenshooter -r -d 3 || gnome-screenshot -a -d 3 ) && \
    notify-send "Capture d'écran" "La capture d'écran a bien été effectuée."
clear

