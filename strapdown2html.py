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

# Fix UTF-8 output
sys.stdout = codecs.getwriter('utf8')(sys.stdout)

# FIXME: detect/compute the path, outfile, and title.

def main(argv=[], path='/tmp', outfile='test.html', title='Test'):
    """ Convert every input file from Markdown to HTML, and concatenate all them to an output."""

    with open("/tmp/test.html", "w") as html_file:
        html_file.write("""<!DOCTYPE html>
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
<div class="navbar navbar-fixed-top">
    <div class="navbar-inner">
        <div class="container">
            <div id="headline" class="brand">{title}</div>
""".format(title=title))
        html_file.write("""
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
</div>
<div id="content" class="container" style="zoom:120%;">
<!--    <blockquote class="pull-right" style="right-margin: 5%;">
        <h3>Search on that page?</h3>
            (Thanks to the <a href="http://deuxhuithuit.github.io/quicksearch/">QuickSearch</a> <a href="https://www.jQuery.com/">jQuery</a> plugin.)
            <form><fieldset>
                <input type="text" name="search" value="" id="id_search" placeholder="Search on that page" autofocus />
            </fieldset></form>
    </blockquote>
    <br><hr><br> -->
    <!-- First file -->
""")

        # Now, print each file.
        for inputfile in argv[1:]:
            try:
                print "Trying to read from the file {inputfile}.".format(inputfile=inputfile)
                with open(inputfile, 'r') as openinputfile:
                    print "I opened it, to {openinputfile}.".format(openinputfile=openinputfile)
                    # FIXME detect encoding better?
                    openinputfile = codecs.getreader('utf8')(openinputfile)
                    print "Codec changed to utf8."
                    t = "".join(openinputfile.readlines())
                    print "I read the lines lines"
                    s = markdown.markdown(t)
                    print "I converted from Markdown to HTML."
                    html_file.write(s)
                    print "I wrote this to the {html_file}.".format(html_file=html_file)
                    # Done for that reading from that file
                html_file.write("\n<!-- End of the HTML converted from the file {inputfile} -->\n<br><hr><br>\n<!-- Next file -->\n".format(inputfile=inputfile))
            except Exception as e:
                print e
                print "==> ERROR: Failed to read from the file {inputfile}. Going to the next one.\n".format(inputfile=inputfile)

        # FIXME: search through what if there is no table ?
        # $('input#id_search').quicksearch('table tbody tr');
        # // Smooth Scroll jQuery plugin
        html_file.write("""
    <script type="text/javascript">
        $('a').smoothScroll({
            offset: ((screen.width > 680) ? -60 : 0), preventDefault: true,
            direction: 'top', easing: 'swing', speed:  350, autoCoefficent: 3,
        });
    </script>
    <br><hr>
    <h5 class="pull-right">© 2015 <a title="Check out my web-pages!" href="http://perso.crans.org/besson/">Lilian Besson</a>, generated by an open-source <a href="https://bitbucket.org/lbesson/bin/strapdown2html.py" title="Python 2.7 is cool!">Python</a> script.</h5>
</div>
""")
        html_file.write("""
<script type="text/javascript" src="http://perso.crans.org/besson/_static/ga.js" async defer></script>
<img alt="GA|Analytics" style="visibility:hidden;display:none;" src="http://perso.crans.org/besson/beacon/{path}/{outfile}?pixel"/>
</body></html>
""".format(path=path, outfile=outfile))
    # TODO: also print the web-path and name of that script ($0)
    return True


if __name__ == '__main__':
    import sys
    # TODO: handle options, display help.
    main(sys.argv)
