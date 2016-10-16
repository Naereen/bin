#!/bin/bash
#
# Script to interpret the button#8 of my mouse (Dell with left/right button)
# works on Ubuntu, with this .xbindkeysrc file (http://perso.crans.org/besson/bin/.xbindkeysrc)
#

# log=/tmp/$(basename ${0})_$$.log
title=$(xdotool getwindowname $(xdotool getactivewindow))

# echo "Interpretation 'b:9 + Release' on the window with title '${title}' ..." | tee -a ${log}  # DEBUG

case $title in
    'Terminal - '*)
        # echo "Running 'tmux previous-window' ..." | tee -a ${log}  # DEBUG
        tmux previous-window
    ;;
    *' - Sublime Text')
        # echo "Running 'subl --background --command prev_bookmark' ..." | tee -a ${log}  # DEBUG
        subl --background --command prev_bookmark
    ;;
    *' - Mozilla Firefox')
       # echo "Doing 'xte 'keydown Alt_L' 'keydown Left' 'keyup Left' 'keyup Alt_L'' ..." | tee -a ${log}  # DEBUG
       xte 'keydown Alt_L' 'keydown Left' 'keyup Left' 'keyup Alt_L'
    ;;
    *)
       # echo "Doing nothing ..." | tee -a ${log}  # DEBUG
       # FIXME the key should still be sent to the running program!
       # xte 'mousedown 8' 'mouseup 8'
    ;;
esac
