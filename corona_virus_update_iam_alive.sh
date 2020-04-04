#!/usr/bin/env bash

notify-send "Building https://perso.crans.org/besson/coronavirus.fr.html ..."
cd ~/web-sphinx/

rm -vf -- ./*coronavirus.*.rst~
git add -- *coronavirus.*.rst

git commit -m "Auto updating https://perso.crans.org/besson/coronavirus.fr.html"
git push && clear

make && clear

notify-send "Updated https://perso.crans.org/besson/coronavirus.fr.html : YOUPI JE SUIS (ENCORE) VIVANT"
echo "Updated https://perso.crans.org/besson/coronavirus.fr.html : YOUPI JE SUIS (ENCORE) VIVANT" | lolcat
