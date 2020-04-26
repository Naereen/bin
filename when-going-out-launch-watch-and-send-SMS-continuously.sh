#!/usr/bin/env bash
#
# Launch this script when leaving, so your laptop continuously sends you SMS with data about itself.
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
watch --interval $(("${1:-15}*60")) 'FreeSMS.py "Utilisation actuelle de $(whoami) @ $(hostname) :\n\n$(/bin/df -h -l -t ext3 -t ext4 -t fuseblk -t vfat)\n\n$(uptime)\n\n$(free -h)\n\n(date : $(date))"'
clear
