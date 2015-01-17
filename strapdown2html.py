#!/usr/bin/env python
# -*- coding: utf8 -*-
""" Convert a Markdown/StrapDown.js file to a simple HTML (.html),
which looks as a StrapDown.js powered page, but is autonomous and *do not* require JavaScript at all.

Try to do it as well as possible (and include nice features, like jQuery.QuickSearch ?).

Includes:
- SquirtFr (http://lbesson.bitbucket.org/squirt/)

FIXME:
- arguments reading,
- zooming issue.
"""
__author__ = "Lilian Besson"
__version__ = "0.2"

import sys
import codecs
import markdown
import re
try:
    from ANSIColors import printc
except ImportError:
    print("ANSIColors.printc not available.")

    def printc(*args):
        """ Erzatz of ANSIColors.printc."""
        print(args)

# Fix UTF-8 output
sys.stdout = codecs.getwriter('utf8')(sys.stdout)
use_jquery = False


def main(argv=[], path='/tmp', outfile='test.html', title='Test', zoom=1.0, zoom_navbar=1.2):
    """ Convert every input file from Markdown to HTML, and concatenate all them to an output."""

    printc("<green>Starting main, with:<white> \n\tpath='{path}',\n\toutfile='{outfile}',\n\ttitle='{title}',\n\tzoom='{zoom}',\n\tzoom_navbar='{zoom_navbar}'.".format(path=path, outfile=outfile, title=title, zoom=zoom, zoom_navbar=zoom_navbar))

    with open("/tmp/test.html", "w") as html_file:
        html_file = codecs.getwriter('utf8')(html_file)
        # FIXME? Add ', target-densitydpi=device-dpi' to the meta.name=viewport?
        html_file.write(u"""<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" name="viewport">
    <meta charset="utf-8">
    <title>{title}</title>
    <link href="http://perso.crans.org/besson/_static/md/themes/united.min.css" rel="stylesheet">
    <link href="http://perso.crans.org/besson/_static/md/strapdown.min.css" rel="stylesheet">
    <link href="http://perso.crans.org/besson/_static/md/themes/bootstrap-responsive.min.css" rel="stylesheet">
    <link rel="shortcut icon" href="http://perso.crans.org/besson/_static/.favicon.ico">
""".format(title=title))
        # Include jquery, and some plugins
        if use_jquery:
            html_file.write(u"""
    <script type="text/javascript" src="http://perso.crans.org/besson/_static/jquery.js"></script>
    <script type="text/javascript" src="http://perso.crans.org/besson/_static/jquery.quicksearch.min.js"></script>
    <script type="text/javascript" src="http://perso.crans.org/besson/_static/jquery.smooth-scroll.min.js"></script>
    <meta name="author" content="Lilian Besson">
    <meta name="generator" content="https://bitbucket.org/lbesson/bin/strapdown2html.py">
""")
        html_file.write(u"""</head>
<body>
<div class="navbar navbar-fixed-top">
    <!-- <div style="zoom:{zoomprct}%; -moz-transform: scale({zoom});"> -->
        <div class="navbar-inner">
            <div class="container">
                <div id="headline" class="brand">
                    <!-- <span id="title" style="font-size: {zoomprct}%;"> -->
                        {title}
                    <!-- </span> -->
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
    <!-- </div> -->
</div>
<br><br>""")
        html_file.write(u"""
<div id="content" class="container">
    <!-- <div style="padding:{margin:d}px 1px 1px 1px;"> -->
    <!-- <div id="experimentalZoom" class="container" style="zoom:{zoomprct:g}%; -moz-transform: scale({zoom:g});"> -->
""".format(margin=int(round(49 * zoom)), zoomprct=zoom*100, zoom=zoom))
        # Include the jQuery.QuickSearch plugin.
        if use_jquery:
            html_file.write(u"""
    <blockquote class="pull-right" style="right-margin: 5%;">
        <h3>Search on that page?</h3>
            (Thanks to the <a href="http://deuxhuithuit.github.io/quicksearch/">QuickSearch</a> <a href="https://www.jQuery.com/">jQuery</a> plugin.)
            <form><fieldset>
                <input type="text" name="search" value="" id="id_search" placeholder="Search on that page" autofocus />
            </fieldset></form>
    </blockquote><hr><br>""")
        html_file.write(u"""\n<!-- First file -->\n""")

        # Now, print each file.
        for inputfile in argv:
            try:
                printc("## Trying to read from the file '{inputfile}'.".format(inputfile=inputfile))
                with open(inputfile, 'r') as openinputfile:
                    printc(" I opened it, to '{openinputfile}'.".format(openinputfile=openinputfile))
                    # FIXME detect encoding better?
                    openinputfile = codecs.getreader('utf8')(openinputfile)
                    printc(" Codec changed to utf8.")
                    s = ''
                    for line in openinputfile:
                        # printc("I read one line, and I am converting it to Markdown.")
                        try:
                            s += markdown.markdown(line)
                        except Exception as e:
                            print e
                            printc(" ===> <WARNING> I failed to markdownise this line. Next!<reset><white>")
                    # FIXME: maybe better to read all the lines once ?
                    # t = ''.join(openinputfile.readlines())
                    # printc("I read the lines.")
                    # s = markdown.markdown(t)
                    printc(" I converted from Markdown to HTML.")
                    # TODO: change code (according to:)
# // Prettify
#   var codeEls = document.getElementsByTagName('code');
#   for (var i=0, ii=codeEls.length; i<ii; i++) {
#     var codeEl = codeEls[i];
#     var lang = codeEl.className;
#     codeEl.className = 'prettyprint lang-' + lang;
#   }
#   prettyPrint();
                    html_file.write(s)
                    printc(" <blue>I wrote this to the output file '{html_file}'<white>.".format(html_file=html_file))
                    # Done for that reading from that file
                html_file.write("\n<!-- End of the HTML converted from the file '{inputfile}'. -->\n<br><hr><br>\n<!-- Next file -->\n".format(inputfile=inputfile))
            except Exception as e:
                print e
                printc(" ==> <ERROR>: Failed to read from the file {inputfile}. Going to the next one.<reset><white>\n".format(inputfile=inputfile))

        # FIXME: search through what if there is no table ?
        # $('input#id_search').quicksearch('table tbody tr');
        # // Smooth Scroll jQuery plugin
        if use_jquery:
            html_file.write(u"""
    <script type="text/javascript">
        $('input#id_search').quicksearch('p');
        $('a').smoothScroll({
            offset: ((screen.width > 680) ? -60 : 0), preventDefault: true,
            direction: 'top', easing: 'swing', speed:  350, autoCoefficent: 3,
        });
    </script>""")
        html_file.write(u"""
    <br><hr>
    <h5 class="pull-right">© 2015 <a title="Check out my web-pages!" href="http://perso.crans.org/besson/">Lilian Besson</a>, generated by <a href="https://bitbucket.org/lbesson/bin/strapdown2html.py" title="Python 2.7 is cool!">an open-source Python script</a>.</h5>
    <!-- </div> -->
    <!-- </div> -->
</div>
""")
        html_file.write(u"""
<script type="text/javascript" src="http://perso.crans.org/besson/_static/ga.js" async defer></script>
<img alt="GA|Analytics" style="visibility:hidden;display:none;" src="http://perso.crans.org/besson/beacon/{path}/{outfile}?pixel"/>
</body></html>
""".format(path=path, outfile=outfile))
    # TODO: also print the web-path and name of that script ($0)
    return True


if __name__ == '__main__':
    args = sys.argv
    # TODO: handle options, display help.
    if '-?' in args or '-h' in args or '--help' in args:
        printc("""<yellow>strapdown2html.py<white>: -h | [options] file1 [file2 [file3 ..]]

Convert the input files (Markdown (.md) or HTML (.html) StrapDown.js-powered) to one autonomous HTML file.

Options:
    <magenta>-?|-h|--help<white>:\n\t\tdisplay this help,
    <magenta>-o|--out<white>:\n\t\tspecify the output file. Default is based on the first file name. <red>TODO: implement.<white>
    <magenta>-t|--title<white>:\n\t\tspecify the title of the output. Default is based on the first file name. <red>TODO: conclude.<white>
    <magenta>-z|--zoom<white>:\n\t\tspecify zoom factor. Default is 1.0 (ie 100%, no zoom).
    <magenta>-zn|--zoomnavbar<white>:\n\t\tspecify zoom factor for the navbar. Default is 1.2 (120%).
    <magenta>-v|--view<white>:\n\t\topen the output file when done.

Warning:
    Experimental !

Copyright: 2015, Lilian Besson.
License: GPLv3.""")
        exit(1)

    path = '/tmp'  # FIXME get from the user
    outfile = 'test.html'  # FIXME get from the user

    # OK get from the user or from the file
    if '-t' in args:
        title = args[1 + args.index('-t')]
    if '--title' in args:
        title = args[1 + args.index('--title')]
    title = ''
    i = 0
    while title == '':
        i += 1
        try:
            with open(args[i], 'r') as file1:
                try:
                    title = re.search("<title>[^<]+</title>", "".join(file1.readlines())).group()
                    title = title.replace('<title>', '').replace('</title>', '')
                except Exception as e:
                    # print e
                    printc("<WARNING> Failed to read title from the file '{file1}'.<white>".format(file1=file1))
        except Exception as e:
            # print e
            break
    if title == '':
        printc("<WARNING> I tried to read the title in one of the input file, but failed.<white>\n")
        title = 'This is a test title!'

    # OK get it from the user
    zoom = 1.0
    if '-z' in args:
        zoom = float(args.pop(1 + args.index('-z')))
        args.remove('-z')
    if '--zoom' in args:
        zoom = float(args.pop(1 + args.index('--zoom')))
        args.remove('--zoom')

    # OK get it from the user
    zoom_navbar = 1.2
    if '-zn' in args:
        zoom_navbar = float(args.pop(1 + args.index('-zn')))
        args.remove('-zn')
    if '--zoomnavbar' in args:
        zoom_navbar = float(args.pop(1 + args.index('--zoomnavbar')))
        args.remove('--zoomnavbar')

    # Calling main
    main(args[1:], path=path, outfile=outfile, title=title, zoom=zoom, zoom_navbar=zoom_navbar)
    printc("\n<green>Done, I wrote to the file '{outfile}' in the dir '{path}'.<white>".format(path=path, outfile=outfile))
    if '-v' in args or '--view' in args:
        try:
            printc("Opening that document in your favorite browser...")
            import webbrowser  # Thanks to antigravity.py
            webbrowser.open(path + '/' + outfile)
        except Exception as e:
            printc("But I failed in opening that page to show you the content")
