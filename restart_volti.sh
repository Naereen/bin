#!/usr/bin/env bash
# author: Lilian BESSON
# email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# date: 03-11-2015
# web: https://bitbucket.org/lbesson/bin/src/master/restartvolti.sh
#
# A small script to easily pkill and restart volti
# More detail at https://github.com/gen2brain/volti/issues/52
#
# Licence: GPL v3
#

pkill volti
volti &
