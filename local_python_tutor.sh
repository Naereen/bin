#!/usr/bin/env bash
# Author: Lilian BESSON, (C) 2021-
# Email: Lilian.BESSON[AT]crans[DOT]org
# Date: 21-02-2021.
# Web: https://bitbucket.org/lbesson/bin/src/master/local_python_tutor.sh

# local_python_tutor.sh: a script to launch an offline version of PythonTutor!
#
# Using a local clone of https://github.com/seamile/PyTutor/
# it works only with Python 3, visualize and live mode! but it's already greaaaat!
#
#
# Usage: $ local_python_tutor.sh
# TODO: adapt the path of the local clone, and once
# go there, and do
# $ cd v5-unity ; virtualenv ./env
# with Python 3
#
# Licence: MIT Licence (http://lbesson.mit-license.org).
#
version="0.1"

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -eu
set -o pipefail

cd ~/publis/OCamlTutor.git/other_gits/seamile_PyTutor.git/v5-unity/
xdg-open http://localhost:8003/index.html

. ./env/bin/activate
./env/bin/python bottle_server.py
