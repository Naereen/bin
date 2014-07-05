#! /usr/bin/env python
# -*- coding: utf-8 -*-
# Author: Lilian BESSON
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Web version: http://besson.qc.to/bin/dump_dD.py
# Web version (2): https://bitbucket.org/lbesson/bin/src/master/dump_dD.py
# Date: 02-07-2013
#
# A small script to dump all Maths Exercice LaTeX sources from some website.
#

# Doc: http://www.crummy.com/software/BeautifulSoup/bs3/documentation.html#Printing%20a%20Document
# And an exemple: http://mp.cpgedupuydelome.fr/mesexos.php?idTeX=1485

try:
    from ANSIColors import printc
except:
    def printc(a): print(a)

printc("<yellow>.: Lilian Besson presents :.")
printc("<cyan>Maths exercice LaTeX sources dumper, v0.1<reset>")

# Quicker if you keep this value up-to-date here
# nbExos=$(wget -O - --quiet "http://mp.cpgedupuydelome.fr/index.php" | html2text | grep Exercice | grep -o [0-9]*)
nbExos  = 3994
printc("<reset>Choix aléatoire parmi <neg>%i<Neg> exercices de maths (niveau MPSI et MP)..." % nbExos)

from random import randint

# numexo  = randint(1, nbExos)  # FIXME !
numexo  = 1485

urlToGo = "http://mp.cpgedupuydelome.fr/mesexos.php?idTeX=%i" % numexo

printc("Numéro <magenta>%i<reset>. On va vers <u>\"%s\"<U><white>" % (numexo, urlToGo))

# On récupère la page
import urllib2
response = urllib2.urlopen(urlToGo)
html = response.read()

# BeautifulSoup v3
from BeautifulSoup import BeautifulSoup

# On l'analyse
parsed_html = BeautifulSoup(html)

# On cherche la section <section id="contenu">..</section>
contenu = parsed_html.body.find('section', attrs={'id':'contenu'})

# Et on prend le contenu de la première <textarea> !
codeTeX = contenu.findAll('textarea', limit=1)[0].renderContents()

# Là on galère pour afficher en UTF-8. Zut !
# print( unicode( codeTeX ) )
printc("<blue><u>Code LaTeX de cet exercice:<U><white>\n\n%s" % codeTeX)

# On créé un fichier TeX
name = "exos_%i.fr.tex" % numexo
out = open(name, mode="w")
# On va écrire le code de l'exercice dedans
printc("<green>On écrit dans %s !<white>" % out)

out.write("%%%% LaTeX code, for exos #%i, from %s, in French (file %s).\n%%%%\n" % (numexo, urlToGo, name))
out.write(codeTeX)

printc("<green>Succès :)")
