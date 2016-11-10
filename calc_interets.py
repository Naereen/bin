#! /usr/bin/env python2
# -*- coding: utf-8 -*-
""" Petit script Python pour afficher des graphiques de ses comptes et calculer des intérêts.

- *Date:* 10 November 2016.
- *Author:* Lilian Besson, © 16.
- *Licence:* MIT Licence (http://lbesson.mit-license.org).
"""

from __future__ import print_function, division  # Python 2 compatibility if needed
import matplotlib.pyplot as plt
import pickle
import time
import sys
# try:
#     import codecs
#     sys.stdout = codecs.getwriter('utf8')(sys.stdout)
# except Exception as e:
#     print("Failed to force utf8 for stdout...")

try:
    try:
        from ansicolortags import printc as print
    except ImportError as e:
        print("ansicolortags not available, using regular print.")
        print("  You can install it with : 'pip install ansicolortags' (or sudo pip)...")
        raise e
except ImportError:
    try:
        from ANSIColors import printc as print
    except ImportError:
        print("ANSIColors not available, using regular print.")
        print("  You can install it with : 'pip install ANSIColors-balises' (or sudo pip)...")


# Valeurs EMPIRIQUES des taux d'intérêts.
taux2016 = {'CCP': 0.00, 'LA': 0.75, 'LEP': 1.25, 'LJ': 1.75, 'PEA': 0.00, 'PEL': 2.10}

print("<yellow>Calcul des intérêts, <white>script <u>calc_interets.py<U>:")
try:
    print("Lecture des comptes via le fichier <u>'/home/lilian/comptes.pickle'<U>...")
    with open("/home/lilian/comptes.pickle", 'r') as f:
        comptes = pickle.load(f)
except:
    print("Echec de la lecture.")
    comptes = {'CCP': 2000.00,
               'LA': 2000.00,
               'LEP': 2000.00,
               'LJ': 2000.00,
               'PEA': 2000.00,
               'PEL': 2000.00
               }


type_comptes = list(comptes.keys())


def calc_interets(comptes, taux=taux2016):
    """ Calcule une estimation de mes intérêts.
    """
    interet_fin_annee = sum(comptes[k] * taux[k] / 100.0 for k in type_comptes)
    for k in type_comptes:
        print("Pour mon <blue>compte {:>3}<white>, avec <magenta>{:>10,.2f} €<white>, et un <cyan<taux à <u>{:>4,.2f}%<U><white> {} <green>intérêt ~= {:>6.2f} €<white>.".format(k.upper(), comptes[k], taux[k], '→', comptes[k] * taux[k] / 100.0))
    print("<green>Intérêt estimé pour 2016 : {:.2f} €.<white>".format(interet_fin_annee))
    print("<red>Attention<white> : les vrais intérêts sont calculés toutes les quinzaines, mon estimation n'est pas précise !")
    return interet_fin_annee


def main(comptes, taux=taux2016):
    """ Affiche un diagramme camembert montrant la répartition de sa fortune.
    """
    argenttotal = sum(comptes.values())
    interets = sum(round(comptes[k] * taux[k] / 100.0, 3) for k in type_comptes)
    print("Affichage d'un diagrame camembert en cours...")
    valeurs = list(comptes.values())
    print("Valeurs du diagrame : <black>{}<white>".format(valeurs))
    etiquettes = [u'{} : {} € (à {}% $\\rightarrow$ {} €)'.format(k, comptes[k], taux[k], round(comptes[k] * taux[k] / 100.0, 2))
                  for k in type_comptes]
    legendes = [u'{} (taux {}%)'.format(k, taux[k])
                for k in type_comptes]
    print("Étiquettes du diagrame : <black>{}<white>".format(etiquettes))
    explode = [0.1] * len(valeurs)  # Explode the pie chart
    plt.pie(valeurs, labels=etiquettes, explode=explode, labeldistance=1.05, startangle=135)
    plt.legend(legendes, loc='lower right')
    mydate = time.strftime('%d %b %Y', time.localtime())
    # FIXME FUCKING hack because Matplotlib apparently fails to handles utf-8 correctly here...
    mydate = mydate.replace('û', 'u').replace('é', 'e')
    mytitle = "Mes comptes (le {}). interets = {:.2f} -> Interets = {:.2f} euros ?".format(mydate, argenttotal, interets)
    print("Using title: <magenta>{}<white>".format(mytitle))
    mytitle = u"Mes comptes (le {}). Total = {:.2f} $\\rightarrow$ intérêts = {:.2f} € ?".format(mydate, argenttotal, interets)
    plt.title(mytitle)
    plt.axis('equal')
    # XXX Experimental https://stackoverflow.com/q/12439588/
    figManager = plt.get_current_fig_manager()
    try:
        figManager.frame.Maximize(True)
    except:
        figManager.window.showMaximized()
    year = time.strftime('%Y', time.localtime())
    outfile = '/home/lilian/Public/argent_{}.png'.format(year)
    print("Sauvegarde de ce graphique vers {} en cours...".format(outfile))
    plt.savefig(outfile)
    plt.show()
    try:
        plt.close('all')
        return 0
    except:
        return 1


if __name__ == '__main__':
    print("Commence...")
    calc_interets(comptes=comptes)
    ret = main(comptes=comptes)
    print("Terminé !")
    sys.exit(ret)

# End of calc_interets.py
