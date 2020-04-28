#!/usr/bin/env bash

watch \
    --interval $((15 * 60)) \
    "git pull \
        | tee /tmp/Version-Jaune.log \
        && notify-send \
            'Pokémon Version Jaune' \
            'Pokémon Version Jaune : dernière sauvegarde récupérée depuis GitHub à \
                $(date)\
                \n\n\
                $(ls -larth /tmp/Version-Jaune.log)\
                \n\n\
                $(cat /tmp/Version-Jaune.log)\
            '\
    "
