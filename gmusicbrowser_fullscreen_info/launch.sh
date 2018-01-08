#!/usr/bin/env bash
cd /home/lilian/bin/gmusicbrowser_fullscreen_info/
chromium-browser http://0.0.0.0:9999/ &
FLASK_APP=start_ui.py flask run --host=0.0.0.0 --port=9999
zenity --title="Full screen mode for GMusicBrowser" --info --display=:0.0 --text="Mode plein écran pour GMusicBrowser bien lancé, ouvert dans Chromium"
