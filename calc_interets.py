#! /usr/bin/env python2
# -*- coding: utf-8; mode: python -*-
""" Petit script Python pour afficher des graphiques de ses comptes et calculer des intérêts.

- *Date:* Wednesday 30 December 2015, 9:42:00.
- *Author:* Lilian Besson, (C) 2015-16.
- *Licence:* MIT Licence (http://lbesson.mit-license.org).
"""

from __future__ import print_function, division  # Python 2 compatibility if needed
import matplotlib.pyplot as plt
import pickle

try:
    from ANSIColors import printc as print
except ImportError:
    print("ANSIColors not available, using regular print.")
    print("  You can install it with : 'pip install ANSIColors-balises' (or sudo pip)...")


taux2015 = {'CCP': 0, 'LA': 0.75, 'LEP': 1.25, 'LJ': 1.75, 'PEA': 0, 'PEL': 2.1}

# FIXME change this, or read it from a file
# FIXME make this script public if possible
try:
    print("Lecture des comptes via le fichier '/home/lilian/comptes.pickle'...")
    with open("/home/lilian/comptes.pickle") as f:
        comptes = pickle.load(f)
except:
    print("Echec de la lecture. FIXME trouve une autre solution.")
    comptes = {
               'CCP': 2000.65,
               'LA': 2000,
               'LEP': 2000,
               'LJ': 2000.25,
               'PEA': 2000,
               'PEL': 2000.09
            }

type_comptes = list(comptes.keys())


def calc_interets(comptes, taux=taux2015):
    """ Calcule une estimation de mes intérêts."""
    interet_fin_annee = sum( comptes[k] * taux[k] / 100.0 for k in type_comptes )
    print("<green>Intérêt estimé pour 2015 : {:.2g} €.<white>".format(interet_fin_annee))
    print("<red>Attention<white> : les vrais intérêts sont calculés toutes les quinzaine, mon estimation n'est pas précise.")
    for k in type_comptes:
        print("Pour mon <blue>compte {}<white>, avec <magenta>{} €<white> et un <cyan<taux à {}%<white> ==> <green>intérêt ~= {}<white>.".format(k.upper(), comptes[k], taux[k], comptes[k] * taux[k] / 100.0))
    return interet_fin_annee


def main(comptes, taux=taux2015):
    """ Affiche un diagramme camembert montrant la répartition de sa fortune."""
    print("Affichage d'un diagrame camembert en cours...")
    valeurs = list(comptes.values())
    print("Valeurs du diagrame :<black>{}<white>".format(valeurs))
    etiquettes = [
                  u'{} : {} € (à {}% $\\rightarrow$ {})'.format(k, comptes[k], taux[k], round(comptes[k] * taux[k] / 100.0), 2)
                  for k in type_comptes
                ]
    legendes = [
                '{} (taux {}%)'.format(k, taux[k])
                for k in type_comptes
                ]
    print("Étiquettes du diagrame :<black>{}<white>".format(etiquettes))
    explode = [0.1] * len(valeurs)  # Explode the pie chart
    plt.pie(valeurs, labels=etiquettes, explode=explode, labeldistance=1.1, startangle=22)
    plt.legend(legendes)
    plt.title("Repartition de mon argent dans mes comptes (2015)")
    plt.axis('equal')
    # XXX Experimental https://stackoverflow.com/q/12439588/
    figManager = plt.get_current_fig_manager()
    try:
        figManager.frame.Maximize(True)
    except:
        figManager.window.showMaximized()
    print("Sauvegarde de ce graphique vers '/home/lilian/Public/argent_2015.png' en cours...")
    plt.savefig('/home/lilian/Public/argent_2015.png')
    plt.show()
    # plt.close('all')


if __name__ == '__main__':
    print("Commence...")
    calc_interets(comptes=comptes)
    main(comptes=comptes)
    print("Terminé !")


# End of calc_interets.py