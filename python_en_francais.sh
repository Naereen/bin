#!/usr/bin/env bash
#
# Author: Lilian Besson
# License: GPLv3
# Online: https://perso.crans.org/besson/bin/python_en_francais.sh
# Online(2): https://bitbucket.org/lbesson/bin/src/master/python_en_francais.sh
# Date: 02-03-2021
#
# Un petit programme Bash qui va traduire un fichier écrit en Python avec les mots clés traduits en français, en un vrai fichier écrit en Python.
# Attention : pas terminé, et potentiellement cassé, à utiliser pour le plaisir uniquement.
#
# Usage :
# $ python_en_francais.sh entrée.frpy [sortie.py]
# traduit le programme entrée.frpy écrit en "Python en français" en Python, dans un fichier temporaire /tmp/temXXX.py ou dans sortie.py s'il est renseigné.
#
# ## TODO:
# - [X] don't just translate, but also execute directly, so it can be used as a shebang
# - [ ] TODO: instead of ugly regexp, rewrite a parser of CPython, recompile my own CPython and call it CPython.fr ? If I take the time to do that, I should also translate some error messages...
# - [ ] TODO: if it's easy to do for Python, do the same for OCaml and C ?
#
version='0.0.1'

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

function traduireEnPythonAnglais() {
    input="$1"
    output="$2"
    function echout() {
        echo "$@" >> "${output}"
    }

    echout '#!/usr/bin/env python'
    echout '# coding: utf-8'
    echout '# Preambule of a Python program generated with python_en_francais.sh'
    echout '# (c) Lilian Besson, 2021, License MIT'

    # for next rules, it should be easy to just output a preambule to the output program
    # rules to translate constants
    echout 'Rien = None'
    echout 'Faux = False'
    echout 'Vrai = True'
    echout '__nom__ = __name__'

    # now some useful functions
    echout 'afficher = print'
    echout 'ouvrir = open'
    echout 'intervale = range'
    echout 'entier = int'
    echout 'flottant = float'
    echout 'chaine = str'
    echout 'liste = list'
    echout 'dictionnaire = dict'
    echout 'ensemble = set'
    echout 'booléen = bool'
    echout 'complexe = complex'
    echout 'estinstance = isinstance'

    echout 'somme = sum'
    echout 'minimum = min'
    echout 'maximum = max'
    echout 'énumère = enumerate'
    echout 'objet = object'

    # rules to translate keywords
    cat "${input}" | \
    sed 's/\(^\|[^a-zA-Z0-9]\)déf\($\|[^a-zA-Z0-9]\)/\1def\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)pour\($\|[^a-zA-Z0-9]\)/\1for\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)tantque\($\|[^a-zA-Z0-9]\)/\1while\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)tant que\($\|[^a-zA-Z0-9]\)/\1while\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)ousi\($\|[^a-zA-Z0-9]\)/\1elif\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)ou si\($\|[^a-zA-Z0-9]\)/\1elif\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)si\($\|[^a-zA-Z0-9]\)/\1if\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)sinon\($\|[^a-zA-Z0-9]\)/\1else\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)renvoyer\($\|[^a-zA-Z0-9]\)/\1return\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)est pas\($\|[^a-zA-Z0-9]\)/\1is not\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)est\($\|[^a-zA-Z0-9]\)/\1is\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)pas dans\($\|[^a-zA-Z0-9]\)/\1not in\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)dans\($\|[^a-zA-Z0-9]\)/\1in\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)et\($\|[^a-zA-Z0-9]\)/\1and\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)ou\($\|[^a-zA-Z0-9]\)/\1or\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)continuer\($\|[^a-zA-Z0-9]\)/\1continue\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)brise\($\|[^a-zA-Z0-9]\)/\1break\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)non\($\|[^a-zA-Z0-9]\)/\1not\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)impose\($\|[^a-zA-Z0-9]\)/\1assert\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)importer\($\|[^a-zA-Z0-9]\)/\1import\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)depuis\($\|[^a-zA-Z0-9]\)/\1from\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)essayer\($\|[^a-zA-Z0-9]\)/\1try\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)exception\($\|[^a-zA-Z0-9]\)/\1except\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)comme\($\|[^a-zA-Z0-9]\)/\1as\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)avec\($\|[^a-zA-Z0-9]\)/\1with\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)classe\($\|[^a-zA-Z0-9]\)/\1class\2/g' | \
    sed 's/\(^\|[^a-zA-Z0-9]\)soi\($\|[^a-zA-Z0-9]\)/\1self\2/g' | \
        cat >> "${output}"

}

# Now run the function for the input file
input="$1"

name="${input%.frpy}"
if [ X"${name}.frpy" != X"${input}" ]; then
    echo -e "Erreur : le fichier d'entrée '${input}' ne termine pas par l'extension .frpy" >/dev/stderr
    exit 1
fi

output="${2:-$(tempfile -s .py)}"
# echo -e "Le fichier sera traduit vers '${output}'"

traduireEnPythonAnglais "$input" "$output"
# echo -e "Fichier bien traduit :"
# ls -larth "$output"
# file "$output"

python3 "$output"

# DEBUG:
# echo -e "Afficher les différences :"
# diff "$input" "$output"
# icdiff "$input" "$output"
# git diff --no-index --color-words  "$input" "$output"