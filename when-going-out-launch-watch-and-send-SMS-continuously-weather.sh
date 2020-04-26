#!/usr/bin/env bash
#
# Launch this script when leaving, so your laptop continuously sends you SMS with data about the weather.
#
# Author: Lilian BESSON
# Email: Lilian.BESSON[AT]crans[DOT]org
# Web version: http://perso.crans.org/besson/bin/when-going-out-launch-watch-and-send-SMS-continuously-weather.sh
# Web version (2): https://bitbucket.org/lbesson/bin/src/master/when-going-out-launch-watch-and-send-SMS-continuously-weather.sh
# Date: 2020-04-24 17:48
#
# $ when-going-out-launch-watch-and-send-SMS-continuously-weather.sh 15
#
# will send the current weather and weather forecast every 15 minutes
#

echo "Je surveille la maison pour toi, jeune héros."

watch --interval \
    $(("${1:-15}*60")) \
    'FreeSMS.py "Météo actuelle à Rennes :\
    \n\n\
    $(wa_nocolor.sh "Weather in Rennes, France" | tee /tmp/when-going-out-launch-watch-and-send-SMS-continuously-weather.sh_log.txt | head -n13 | tail -n11 | head -n6)\
    Prédiction météo :\
    \n\n\
    $(cat /tmp/when-going-out-launch-watch-and-send-SMS-continuously-weather.sh_log.txt | head -n13 | tail -n4)\
    \n\n\
    (date : $(date))\
    "'
clear
