#!/usr/bin/env python
# -*- coding:utf8 -*-
"""
A simple Python script to send a text message to a Free Mobile phone.

.. note:: Copyleft 2014-15 Lilian Besson
.. warning:: License GPLv3.

---

Examples
--------
>>> FreeSMS.py --help
Gives help

>>> FreeSMS.py "I like using Python to send me SMS from my laptop -- and it"s free thanks to Free !"
Will send a test message to your mobile phone.

------

.. sidebar:: Last version?

   Take a look to the latest version at https://bitbucket.org/lbesson/bin/src/master/FreeSMS.py
.. note:: Initial Copyright : José - Juin 2014 (http://eyesathome.free.fr/index.php/tag/freemobile/)
.. note::

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   FreeSMS.py is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

   See the GNU General Public License for more details.
   You should have received a copy of the GNU General Public License v3 along with FreeSMS.py.
   If not, see <http://perso.crans.org/besson/LICENSE.html>.
"""

from sys import exit, argv
from urllib import urlencode
from urllib2 import urlopen, HTTPError
from base64 import b64decode


# Detect language
from os import getenv
try:
    language = getenv("LANG")[0:2]
except:
    language = "fr"

if language == "fr":
    errorcodes = {
        400: "Un des paramètres obligatoires est manquant.",
        402: "Trop de SMS ont été envoyés en trop peu de temps.",
        403: "Le service n'est pas activé sur l'espace abonné, ou login / clé incorrect.",
        500: "Erreur côté serveur. Veuillez réessayez ultérieurement.",
        1:   "Le SMS a été envoyé sur votre mobile.",
        "toolong": "Attention : le message est trop long (+ de 3*160 caracters, soit plus de 3 SMS)."
    }
else:
    errorcodes = {
        400: "Missing Parameter",
        402: "Spammer!",
        403: "Access Denied",
        500: "Server Down",
        1:   "Success",
        "toolong": "Warning: message is too long (more than 3*160 caracters, so more than 3 SMS)."
    }


#: Identification Number free mobile
user = b64decode("MjM5NzgzMzY=")

#: Password
password = b64decode("VVFaSmdiOHhwcm01TWc=")

#: FIXME find a way to secure this step better than the way it is right now.


def send_sms(text="Empty!", user=user, password=password, secured=True):
    """Sens a free SMS to the user identified by [user], with [password].

:user: Free Mobile id (of the form [0-9]{8}),
:password: Service password (of the form [a-zA-Z0-9]{14}),
:text: The content of the message (a warning is displayed if the message is bigger than 480 caracters)
:secured: True to use HTTPS, False to use HTTP.

    Returns a boolean and a status string."""

    if len(text) >= 3*160:
        print errorcodes["toolong"]

    query = urlencode({"user": user, "pass": password, "msg": text})
    url = "http" + ("s" if secured else "")
    url += "://smsapi.free-mobile.fr/sendmsg?{}".format(query)

    try:
        urlopen(url)
        return 0, errorcodes[1]
    except HTTPError as e:
        if hasattr(e, "code"):
            return e.code, errorcodes[e.code]
        else:
            print "Unknown error"
            return 2, "Unknown error"


def main(argv):
    """ main(argv) -> None

Main function. Use the arguments of the command line. """

    if "-h" in argv or "--help" in argv:
        print """FreeSMS.py --help|-h | body of the message
A simple Python script to send a text message to a Free Mobile phone.
The message should be smaller than 480 caracters.

Examples:
$ FreeSMS.py --help
Print this help message!

$ FreeSMS.py "I like using Python to send me SMS from my laptop -- and it"s free thanks to Free !"
Will send a test message to your mobile phone.

Copyleft 2014-15 Lilian Besson (License GPLv3)

FreeSMS.py is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."""
        return 1

    if argv:
        #: Text of the SMS
        text = " ".join(argv)
    else:
        text = """Test SMS sent from jarvis.crans.org with FreeSMS.py.

(a Python 2.7 script by Lilian Besson, open source, you can find the code
at https://bitbucket.org/lbesson/bin/src/master/FreeSMS.py
or http://perso.crans.org/besson/bin/FreeSMS.py)

For any issues, reach me by email at jarvis[at]crans[dot]org !
""".replace("[at]", "@").replace("[dot]", ".")

    answer = send_sms(text)
    print answer[1]
    return answer[0]

if __name__ == "__main__":
    # from doctest import testmod
    # testmod(verbose=False)
    exit(int(main(argv[1:])))
