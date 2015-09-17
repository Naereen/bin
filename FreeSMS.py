#!/usr/bin/env python2
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
from os import getenv
from time import strftime

today = strftime("%H:%M:%S %Y-%m-%d")


#: Number (not necessary)
number = b64decode( open('/home/lilian/.smsapifreemobile_number.b64').readline()[:-1] )

#: Identification Number free mobile
user = b64decode( open('/home/lilian/.smsapifreemobile_user.b64').readline()[:-1] )

#: Password
password = b64decode( open('/home/lilian/.smsapifreemobile_password.b64').readline()[:-1] )

#: FIXME find a way to secure this step better than the way it is right now.


# Detect language
try:
    language = getenv("LANG")[0:2]
except:
    language = "fr"

if language == "fr":
    errorcodes = {
        400: "Un des paramètres obligatoires est manquant.",
        402: "Trop de SMS ont été envoyés en trop peu de temps.",
        403: """Le service n'est pas activé sur l'espace abonné, ou login / clé incorrect.
Allez sur 'https://mobile.free.fr/moncompte/index.php?page=options&show=20' svp""",
        500: "Erreur côté serveur. Veuillez réessayez ultérieurement.",
        1:   "Le SMS a été envoyé sur votre mobile ({number}).".format(number=number),
        "toolong": "Attention : le message est trop long (+ de 3*160 caracters, soit plus de 3 SMS)."
    }
else:
    errorcodes = {
        400: "One of the necessary parameter is missing.",
        402: "Too many SMSs has been sent in a short time (you might be a spammer!).",
        403: """Access denied: the service might not be activated on the online personnal space, or login/password is wrong.
Please go on 'https://mobile.free.fr/moncompte/index.php?page=options&show=20' svp""",
        500: "Error from the server side. Please try again later.",
        1:   "The SMS has been sent to your mobile ({number}).".format(number=number),
        "toolong": "Warning: message is too long (more than 3*160 caracters, so more than 3 SMS)."
    }


def send_sms(text="Empty!", user=user, password=password, secured=True):
    """Sens a free SMS to the user identified by [user], with [password].

:user: Free Mobile id (of the form [0-9]{8}),
:password: Service password (of the form [a-zA-Z0-9]{14}),
:text: The content of the message (a warning is displayed if the message is bigger than 480 caracters)
:secured: True to use HTTPS, False to use HTTP.

    Returns a boolean and a status string."""

    if len(text) >= 3*160:
        print(errorcodes["toolong"])

    print("\nYour message is:\n'" + text + "'.")
    print("\nYour query will be based on:\n{}.".format({"user": user, "pass": password, "msg": text}))
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
        print("""FreeSMS.py --help|-h | -f file | body of the message
A simple Python script to send a text message to a Free Mobile phone.
The message should be smaller than 480 caracters.

Examples:
$ FreeSMS.py --help
Print this help message!

$ FreeSMS.py -f /tmp/MyMessageFile.txt
Print this help message!

$ FreeSMS.py "I like using Python to send me SMS from my laptop -- and it"s free thanks to Free !"
Will send a test message to your mobile phone.

Copyleft 2014-15 Lilian Besson (License GPLv3)

FreeSMS.py is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.""")
        return 1

    if "-f" in argv:
        try:
            with open(argv[argv.index("-f")+1], 'r') as filename:
                text = "".join(filename.readlines())[:-1]
        except:
            text = " ".join(argv)
    else:
        if argv:
            #: Text of the SMS
            text = " ".join(argv)
        else:
            text = """Test SMS sent from jarvis.crans.org with FreeSMS.py (the {date}).

    (a Python 2.7 script by Lilian Besson, open source, you can find the code
    at https://bitbucket.org/lbesson/bin/src/master/FreeSMS.py
    or http://perso.crans.org/besson/bin/FreeSMS.py)

    For any issues, reach me by email at jarvis[at]crans[dot]org !"""
            text = text.format(date=today)
            text = text.replace("[at]", "@").replace("[dot]", ".")

    answer = send_sms(text)
    print(answer[1])
    return answer[0]

if __name__ == "__main__":
    # from doctest import testmod
    # testmod(verbose=False)
    exit(int(main(argv[1:])))
