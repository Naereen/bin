#! /usr/bin/env python2
# -*- coding: utf-8; mode: python -*-
""" Petit script Python pour afficher des graphiques de ses comptes et calculer des intérêts.

- *Date:* 04 February 2016.
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


taux2016 = {'CCP': 0.00, 'LA': 0.75, 'LEP': 1.25, 'LJ': 1.75, 'PEA': 0.00, 'PEL': 2.10}

print("<yellow>Calcul des intérêts, <white>script <u>calc_interets.py<U>:")
try:
    print("Lecture des comptes via le fichier '/home/lilian/comptes.pickle'...")
    with open("/home/lilian/comptes.pickle") as f:
        comptes = pickle.load(f)
except:
    print("Echec de la lecture.")
    comptes = {
               'CCP': 2000.00,
               'LA':  2000.00,
               'LEP': 2000.00,
               'LJ':  2000.00,
               'PEA': 2000.00,
               'PEL': 2000.00
            }


type_comptes = list(comptes.keys())


def calc_interets(comptes, taux=taux2016):
    """ Calcule une estimation de mes intérêts."""
    interet_fin_annee = sum(comptes[k] * taux[k] / 100.0 for k in type_comptes)
    for k in type_comptes:
        print("Pour mon <blue>compte {:>3}<white>, avec <magenta>{:>10,.2f} €<white>, et un <cyan<taux à <u>{:>4,.2f}%<U><white> {} <green>intérêt ~= {:>6.2f} €<white>.".format(k.upper(), comptes[k], taux[k], '→', comptes[k] * taux[k] / 100.0))
    print("<green>Intérêt estimé pour 2016 : {:.2f} €.<white>".format(interet_fin_annee))
    print("<red>Attention<white> : les vrais intérêts sont calculés toutes les quinzaine, mon estimation n'est pas précise.")
    return interet_fin_annee


def main(comptes, taux=taux2016):
    """ Affiche un diagramme camembert montrant la répartition de sa fortune."""
    total = sum(round(comptes[k] * taux[k] / 100.0, 3) for k in type_comptes)
    print("Affichage d'un diagrame camembert en cours...")
    valeurs = list(comptes.values())
    print("Valeurs du diagrame :<black>{}<white>".format(valeurs))
    etiquettes = [
                  u'{} : {} € (à {}% $\\rightarrow$ {} €)'.format(k, comptes[k], taux[k], round(comptes[k] * taux[k] / 100.0), 2)
                  for k in type_comptes
                ]
    legendes = [
                '{} (taux {}%)'.format(k, taux[k])
                for k in type_comptes
                ]
    print("Étiquettes du diagrame :<black>{}<white>".format(etiquettes))
    explode = [0.1] * len(valeurs)  # Explode the pie chart
    plt.pie(valeurs, labels=etiquettes, explode=explode, labeldistance=1.05, startangle=135)
    plt.legend(legendes, loc='lower right')
    plt.title("Repartition de mon argent dans mes comptes (2016). Interets totaux = {:.2f}".format(total))
    plt.axis('equal')
    # XXX Experimental https://stackoverflow.com/q/12439588/
    figManager = plt.get_current_fig_manager()
    try:
        figManager.frame.Maximize(True)
    except:
        figManager.window.showMaximized()
    outfile = '/home/lilian/Public/argent_2016.png'
    print("Sauvegarde de ce graphique vers {} en cours...".format(outfile))
    plt.savefig(outfile)
    plt.show()
    # plt.close('all')


if __name__ == '__main__':
    print("Commence...")
    calc_interets(comptes=comptes)
    main(comptes=comptes)
    print("Terminé !")


# End of calc_interets.py
