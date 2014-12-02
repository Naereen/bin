#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-
"""
A simple (beta) Python tool to plot graphics from Wikipédia statistics.

.. warning:: Copyleft 2013 - Lilian Besson.
.. warning:: License GPLv3.
.. note:: Last version?

   Take a look to the latest version at https://bitbucket.org/lbesson/bin/src/master/wikistats.py

---

Examples
--------
$ wikistats.py --help
Gives help

$ wikistats.py --language=fr "Professeur Xavier"
$ wikistats.py -l fr "Professeur Xavier"
Will produce a graphic of visiting statistics for the page https://fr.wikipedia.org/wiki/Professeur_Xavier for the last 30 days

---

.. note::

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   wikistats.py is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License v3 along with wikistats.py.
   If not, see <http://perso.crans.org/besson/LICENSE.html>.
"""


# Pour détecter le langage par défault
import os

# Default values
language_default = os.getenv("LANG")[0:2]

lang_to_text = {"en": "english", "fr": "french"}

template_url_default = "http://stats.grok.se/json/{language}/latest30/{page}"

template_output_default = "{page}.{language}.json"


def download_json(page="JSON",
                  template_output=template_output_default,
                  language=language_default,
                  template_url=template_url_default):
    """ download_json(page="JSON", template_output=template_output_default,                  language=language_default, template_url=templateurl_default) -> str

Download a JSON file.

@page: tell which Wikipédia page to lookup to.
@template_output: template string for the output JSON (.json) file.
@language: language to use for downloading the JSON.
@template_url: online page to use a format to download the JSON.

Example:
>>> download_json(page="France", language="en", template_output="{page}.en.json")
'France.en.json'

>>> download_json(page="France", language="fr", template_output="out_{page}.fr.json")
'out_France.fr.json'
    """
    # To download the JSON file from the web
    # WARNING: https might not be supported
    import urllib2
    # To move the destination file to "/tmp/" if it is already there.
    import distutils.file_util

    url_to_download = template_url.format(page=page, language=language)
    outfile = template_output.format(page=page, language=language)

    try:
        print ("The destination file {outfile} was already present in the"
            " current directory, now it is in {newfile}".format(
                outfile=outfile,
                newfile=distutils.file_util.copy_file(outfile, "/tmp/")))
    except distutils.file_util.DistutilsFileError:
        print "Apparently the destination file {outfile} is not there.".format(outfile=outfile)

    url_request = urllib2.urlopen(url_to_download)
    distutils.file_util.write_file(outfile, url_request.readlines())
    return outfile


def outfile_to_json(outfile_name):
    """ outfile_to_json(outfile_name) -> dir

Try to dump and return the content of the file @outfile.
    """
    outfile = open(outfile_name)
    # To convert the content of this file in a Python dictionnary.
    import json
    try:
        json_obj = json.loads(outfile.readline())
    except:  # FIXME
        import string
        json_obj = json.loads(string.join(outfile.readlines()))
    return json_obj


def plot_month_stats_from_json(json_obj, graphic_name=None, graphic_name_template="{title}.{lang}.{ext}", ext="png"):
    """ plot_month_stats_from_json(json_obj, graphic_name=None, graphic_name_template="{title}.{lang}.{ext}", ext="png") -> None

Plot a couple of PNG/SVG/PDF statistics.

.. warning:: Beta !
    """
    assert(ext in ["png", "svg", "pdf"])

    title = json_obj["title"]
    lang = json_obj["project"]
    rank = json_obj["rank"]
    if rank == "-1":
        rank = "NA"

    if not graphic_name:
        graphic_name = graphic_name_template.format(title=title, lang=lang, ext=ext)

    views = json_obj["daily_views"]

    try:
        import datetime
        today = datetime.date.today()
        year, month, day = today.year, today.month, today.day
    except:  # FIXME
        year, month, day = "2014", "12", "02"

    print "The page \"{title}\", with language {lang}, has been ranked {rank}th on the {month}th month of {year}.".format(title=title, lang=lang, rank=rank, month=month, year=year)

    stats = {}
    data = []

    # FIXME
    for year_month_day in sorted(views, key=lambda s: s[-5:-3]+s[-2:]):
        newkey = year_month_day[-5:-3] + "-" + year_month_day[-2:]
        stats[newkey] = views[year_month_day]
        data.append([year_month_day, views[year_month_day]])
        print "On {year}, the {date} the page \"{title}\" (lang={lang}) had {number} visitor{plural}.".format(date=newkey, number=stats[newkey],
                        title=title, lang=lang, year=year,
                        plural=("s" if stats[newkey]>1 else "") )

    # Now make a graphic thanks to this data
    print "A graphic will be produced to the file \"{graphic_name}\" (with the type \"{ext}\").".format(graphic_name=graphic_name, ext=ext)

    # Pour en faire des graphiques.
    import numpy
    import pylab
    data_old = data
    data = numpy.array(data)

    # Just the numbers
    numbers = data[::, 1].astype(numpy.int)
    nbnumbers = numpy.size(numbers)

#    # Sort decreasingly
#    ind = numpy.argsort(numbers)
#    data = data[ind]
#    numbers = numbers[ind]

    # Graph options
    pylab.xlabel("Dates from the last 30 days (at the {today})".format(today=datetime.date.today()))
    pylab.ylabel("Number of visitors")

    try:
        lang_name = "(in " + lang_to_text[lang] + ")"
    except:
        lang_name = "(unknown language)"
    pylab.title(u".: Visiting statistics for the Wikipedia page {title} {lang_name} :.\n (Data from http://stats.grok.se, Python script by Lilian Besson (C) 2014) ".format(title=title, lang_name=lang_name))

    # X axis
    pylab.xlim(1, nbnumbers+1)
    pylab.xticks(numpy.arange(nbnumbers+1), [ s[-2:]+"/"+s[-5:-3] for s in data[:,0] ]
, rotation=85)
    # Y axis
    pylab.ylim(0, numbers.max() + 1)

    pylab.grid(True, alpha=0.4)

    # Compute (and plot) an (invisible) histogram
    xvalues, bins, patches = pylab.hist(data, numpy.arange(nbnumbers+1), facecolor='blue', alpha=0.0)

    print len(xvalues), len(bins)
    print xvalues
    print bins

    pylab.plot(bins[:][:], xvalues[:], 'go--', linewidth=.5, markersize=5)

    # Tweak spacing to prevent clipping of ylabel
    pylab.subplots_adjust(left=0.15)

    pylab.show()  # FIXME
    pylab.savefig(graphic_name, format=ext)  # FIXME
    print "Ploting the statistics on an histogram on the file \"{graphic_name}\".".format(graphic_name=graphic_name)
    pylab.draw()
    pylab.clf()

    return views, data, data_old


def test(page="France", language=language_default):
    """ test() -> None"""
    outfile = download_json(page, language)
    json_obj = outfile_to_json(outfile)
    return plot_month_stats_from_json(json_obj)


if __name__ == '__main__':
#    from doctest import testmod
#    testmod(verbose=False)
    try:
        import sys
        views, data, data_old = test(page=sys.argv[1], language=sys.argv[2])
    except IndexError:
        views, data, data_old = test(page="France", language="en")
#    sys.exit(0)

    # Pour analyser les arguments de l'appel du script en ligne du commande,
    import argparse
    import getopt


###
#def main(argv):
#    try:
#        opts, args = getopt.getopt(argv, "sdh", ["stdout", "download", "mode=", "authhash=", "ttl=", "help"])
#    except getopt.GetoptError:
#        usage()
#        sys.exit(2)
#
#    paste = PasteBox()
#
#    for opt, arg in opts:
#        if opt in ("--mode"):
#            if arg:
#                paste.mode = arg
#            else:
#                print("You need to provide a mode see usage (--help)")
#                sys.exit(2)
#
#        if opt in ("--authhash"):
#            if arg:
#                paste.authhash = arg
#            else:
#                print("You need to provide an authhash see usage (--help)")
#                sys.exit(2)
#
#        if opt in ("--ttl"):
#            if arg:
#                paste.ttl = arg
#            else:
#                print("You need to provide the TTL see usage (--help)")
#                sys.exit(2)
#
#        if opt in ("-h", "--help"):
#            usage()
#            sys.exit()
#        elif opt == '-s' or opt == '--stdout':
#            for pasteid in args:
#                paste.stdout(pasteid)
#        elif opt == '-d' or opt == '--download':
#            for pasteid in args:
#                paste.download(pasteid)
#
#    if not opts and args:
#        for file in args:
#            try:
#                print("%s: %s"%(file, paste.create(''.join(open(file, 'r').readlines()))))
#            except IOError:
#                print("skipping %s: file doesn't exist"%file)
#
#    if not sys.stdin.isatty():
#        paste = paste.create(' '.join(sys.stdin.readlines()))
#        print(paste)
#
#if __name__ == "__main__":
#    main(sys.argv[1:])
