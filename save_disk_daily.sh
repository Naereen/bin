#!/bin/sh

# Un script pour sauver facilement ses données
#  Il est conçu pour être utilisé sur Ubuntu, installé sur Windows via WUBI

# Écrit par Lilian BESSON (C)
# v3 07-01-2013

message=`date "+%d-%m, et il est %Hh:%Mm-%Ss"`
echo "$USER, vous avez demandé une sauvegarde de votre installation d'Ubuntu, nous sommes le $message."

directory_to_save="/host/ubuntu/disks/"
# TODO : choisir ICI son disque dur externe !
directory_where_save="/media/Disque Dur - Naereen/.SAVE/Save_disks_"`date "+%d_%m_%y"`/

echo "La sauvegarde va commencer entre le répertoire : \n $directory_to_save\n et le répertoire situé sur votre DDE :\n$directory_where_save"

read -p "[o]ui/[N]ON ? " ok

case "$ok" in
       Non*|""|non*)
          echo "$ok : réponse négative. Ciao !"
          exit 1
       ;;
       *)
          echo "$ok : réponse positive. Je me lance : en utilisant rsync pour vous informer de l'avancée de la sauvegarde en 'temps réel'"
       ;;
esac

CP="cp -vi"
CP="/usr/bin/rsync --verbose --human-readable --progress --archive"

time $CP -r "$directory_to_save" "$directory_where_save" && notify-send --urgency=critical --icon=alert "Sauvegarde" "Sauvegarde de votre installation d'Ubuntu effectuée, dans le dossier $directory_where_save."

# DONE