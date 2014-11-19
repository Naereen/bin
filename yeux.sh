#!/usr/bin/env bash
# author: Lilian BESSON
# email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# date: 19-11-2014.
# web: https://bitbucket.org/lbesson/bin/src/master/yeux.sh
#
# For one short moment, reduce the brightness of the screen to rest your eyes.
#
# Licence: GPLv3 (http://perso.crans.org/besson/LICENSE.html)
#

date > /tmp/yeux.log
echo "Repose tes yeux, pendant 15 secondes. Vas-y, regarde loin de ton écran, n'ai pas peur." | tee -a /tmp/yeux.log
notify-send 'Repose tes yeux!' 'Prends ces 15 secondes pour bien reposer tes yeux. (Idée venue de http://askubuntu.com/a/431038).'

xrandr --output LVDS --brightness 0.4 | tee -a /tmp/yeux.log
sleep 15s | tee -a /tmp/yeux.log
xrandr --output LVDS --brightness .85 | tee -a /tmp/yeux.log

echo "Terminé :) C'est bien, tu prends soin de tes yeux." | tee -a /tmp/yeux.log
