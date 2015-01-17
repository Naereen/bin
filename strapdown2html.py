#!/usr/bin/env python
# -*- coding: utf8 -*-
""" Convert a Markdown/StrapDown.js file to a simple HTML (.html),
which looks as a StrapDown.js powered page, but is autonomous and do not require JavaScript.

Try to do it as well as possible (and include nice plugin, like jQuery.QuickSearch ?).
"""
__author__ = "Lilian Besson"
__version__ = "0.1"

import sys
import codecs
import markdown
try:
    from ANSIColors import printc
except ImportError:
    print("ANSIColors.printc not available.")

    def printc(*args):
        """ Erzatz of ANSIColors.printc."""
        print(args)

# Fix UTF-8 output
sys.stdout = codecs.getwriter('utf8')(sys.stdout)


def main(argv=[], path='/tmp', outfile='test.html', title='Test', zoom=1.0, zoom_navbar=1.2):
    """ Convert every input file from Markdown to HTML, and concatenate all them to an output."""

    printc("<green>Starting main, with:<white> \n\tpath='{path}',\n\toutfile='{outfile}',\n\ttitle='{title}',\n\tzoom='{zoom}',\n\tzoom_navbar='{zoom_navbar}'.".format(path=path, outfile=outfile, title=title, zoom=zoom, zoom_navbar=zoom_navbar))

    with open("/tmp/test.html", "w") as html_file:
        html_file = codecs.getwriter('utf8')(html_file)
        html_file.write(u"""<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, target-densitydpi=device-dpi" name="viewport">
    <title>{title}</title>
    <meta name="author" content="Lilian Besson">
    <meta name="generator" content="https://bitbucket.org/lbesson/bin/strapdown2html.py">
    <link href="http://perso.crans.org/besson/_static/md/themes/united.min.css" rel="stylesheet">
    <link href="http://perso.crans.org/besson/_static/md/strapdown.css" rel="stylesheet">
    <link href="http://perso.crans.org/besson/_static/md/themes/bootstrap-responsive.css" rel="stylesheet">
    <link rel="shortcut icon" href="http://perso.crans.org/besson/_static/.favicon.ico"/>
    <script type="text/javascript" src="http://perso.crans.org/besson/_static/jquery.js"></script>
    <script type="text/javascript" src="http://perso.crans.org/besson/_static/jquery.quicksearch.min.js"></script>
    <script type="text/javascript" src="http://perso.crans.org/besson/_static/jquery.smooth-scroll.min.js"></script>
</head>
<body>
<div class="navbar navbar-fixed-top"><div style="zoom:{zoomprct}%; -moz-transform: scale({zoom});">
    <div class="navbar-inner">
        <div class="container">
            <div id="headline" class="brand">
                <span id="title" style="font-size: {zoomprct}%;">{title}</span>
            </div>
""".format(title=title, zoom=zoom_navbar, zoomprct=zoom_navbar*100))
        html_file.write(u"""
            <div id="headline-copyrights" class="brand">
                Generated with <a href="https://bitbucket.org/lbesson/bin/strapdown2html.py">Python</a>,
                by <a href="http://perso.crans.org/besson/">Lilian Besson</a>.
                Based on <a title="http://lbo.k.vu/md" href="http://lbesson.bitbucket.org/md/index.html">StrapDown.js</a>
                (theme <a title="More information on this theme, on bootswatch.com." href="http://bootswatch.com/united"><i>united</i></a>),
                on <a href="http://perso.crans.org/besson/">perso.crans.org/besson</a>.
            </div>
            <div id="headline-squirt" class="brand">
                <a title="Quick read with SquirtFR. Check http://lbesson.bitbucket.org/squirt/ for more information."
                href="javascript:(function(){sq=window.sq;if(sq&amp;&amp;sq.closed){window.sq.closed&amp;&amp;window.document.dispatchEvent(new%20Event('squirt.again'));}else{sq=window.sq||{};sq.version='0.4';sq.host='http://lbesson.bitbucket.org/squirt';sq.j=document.createElement('script');sq.j.src=sq.host+'/squirt.js?src=strapdown.min.js';document.body.appendChild(sq.j);}})();">[QuickRead]</a>
            </div>
        </div>
    </div>
</div></div>
<br><br>""")
        html_file.write(u"""
<div id="content" class="container" style="padding:{margin}px 1px 1px 1px;" >
<div id="experimentalZoom" class="container" style="zoom:{zoomprct}%; -moz-transform: scale({zoom});">
<!--    <blockquote class="pull-right" style="right-margin: 5%;">
        <h3>Search on that page?</h3>
            (Thanks to the <a href="http://deuxhuithuit.github.io/quicksearch/">QuickSearch</a> <a href="https://www.jQuery.com/">jQuery</a> plugin.)
            <form><fieldset>
                <input type="text" name="search" value="" id="id_search" placeholder="Search on that page" autofocus />
            </fieldset></form>
    </blockquote><hr><br> -->
    <!-- First file -->
""".format(margin=int(round(49 * zoom)), zoom=zoom, zoomprct=zoom*100))

        # Now, print each file.
        for inputfile in argv[1:]:
            try:
                printc("## Trying to read from the file '{inputfile}'.".format(inputfile=inputfile))
                with open(inputfile, 'r') as openinputfile:
                    printc(" I opened it, to '{openinputfile}'.".format(openinputfile=openinputfile))
                    # FIXME detect encoding better?
                    openinputfile = codecs.getreader('utf8')(openinputfile)
                    printc(" Codec changed to utf8.")
                    s = ""
                    for line in openinputfile:
                        # printc("I read one line, and I am converting it to Markdown.")
                        try:
                            s += markdown.markdown(line)
                        except Exception as e:
                            print e
                            printc(" ===> <WARNING> I failed to markdownise this line. Next!<reset><white>")
                    # FIXME: maybe better to read all the lines once ?
                    # t = "".join(openinputfile.readlines())
                    # printc("I read the lines.")
                    # s = markdown.markdown(t)
                    printc(" I converted from Markdown to HTML.")
                    html_file.write(s)
                    printc(" <blue>I wrote this to the output file '{html_file}'<white>.".format(html_file=html_file))
                    # Done for that reading from that file
                html_file.write("\n<!-- End of the HTML converted from the file '{inputfile}' -->\n<br><hr><br>\n<!-- Next file -->\n".format(inputfile=inputfile))
            except Exception as e:
                print e
                printc(" ==> <ERROR>: Failed to read from the file {inputfile}. Going to the next one.<reset><white>\n".format(inputfile=inputfile))

        # FIXME: search through what if there is no table ?
        # $('input#id_search').quicksearch('table tbody tr');
        # // Smooth Scroll jQuery plugin
        html_file.write(u"""
    <script type="text/javascript">
        $('a').smoothScroll({
            offset: ((screen.width > 680) ? -60 : 0), preventDefault: true,
            direction: 'top', easing: 'swing', speed:  350, autoCoefficent: 3,
        });
    </script>
    <br><hr>
    <h5 class="pull-right">© 2015 <a title="Check out my web-pages!" href="http://perso.crans.org/besson/">Lilian Besson</a>, generated by <a href="https://bitbucket.org/lbesson/bin/strapdown2html.py" title="Python 2.7 is cool!">an open-source Python script</a>.</h5>
</div></div>
""")
        html_file.write(u"""
<script type="text/javascript" src="http://perso.crans.org/besson/_static/ga.js" async defer></script>
<img alt="GA|Analytics" style="visibility:hidden;display:none;" src="http://perso.crans.org/besson/beacon/{path}/{outfile}?pixel"/>
</body></html>
""".format(path=path, outfile=outfile))
    # TODO: also print the web-path and name of that script ($0)
    return True


if __name__ == '__main__':
    # TODO: handle options, display help.
    path = '/tmp'  # FIXME get from the user
    outfile = 'test.html'  # FIXME get from the user
    title = 'This is a test title!'  # FIXME get from the user
    zoom = 1.0  # FIXME get from the user
    zoom_navbar = 1.2  # FIXME get from the user
    # Calling main
    main(sys.argv, path=path, outfile=outfile, title=title, zoom=zoom, zoom_navbar=zoom_navbar)
    printc("\n<green>Done, I wrote to the file '{outfile}' in the dir '{path}'.<white>".format(path=path, outfile=outfile))
