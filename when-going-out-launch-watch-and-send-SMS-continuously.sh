#!/usr/bin/env bash

echo "Je surveille la maison pour toi, jeune héros."
watch --interval 900 'FreeSMS.py "Utilisation actuelle de $(whoami) @ $(hostname) :\n\n$(/bin/df -h -l -t ext3 -t ext4 -t fuseblk -t vfat)\n\n$(uptime)\n\n$(free -h)\n\n(date : $(date))"'
