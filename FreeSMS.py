#!/usr/bin/env python
# -*- coding:utf8 -*-
"""
A simple Python 2.7+ / 3.1+ script to send a text message to a Free Mobile phone.

- Copyleft 2014-16 Lilian Besson
- License GPLv3.

Examples
--------
$ FreeSMS.py --help
Gives help

$ FreeSMS.py "I like using Python to send SMS to myself from my laptop -- and it's free thanks to Free Mobile !"
Will send a test message to your mobile phone.


- Last version? Take a look to the latest version at https://bitbucket.org/lbesson/bin/src/master/FreeSMS.py
- Initial Copyright : José - Juin 2014 (http://eyesathome.free.fr/index.php/tag/freemobile/)
- License:

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

from __future__ import print_function   # Python 2/3 compatible
from __future__ import absolute_import  # Python 2/3 compatible

import sys
from os import getenv
from json import dumps

# Use base64 to not keep plaintext files of the number, username and password in your home
from base64 import b64decode

from time import strftime
today = strftime("%H:%M:%S %Y-%m-%d")

try:
    from os.path import expanduser
except ImportError:
    print("Warning, os.path.expanduser is not available, trying to use getenv('USER') = {} ...".format(getenv("USER")))

    def expanduser(s):
        """ Try to simulate the os.path.expanduser function. """
        return '/home/' + getenv("USER") + '/' + s

if sys.version_info < (3, 0):
    from urllib import urlencode
    from urllib2 import urlopen, HTTPError
else:
    from urllib3.request import urlencode
    from urllib.request import urlopen
    from urllib.error import HTTPError


try:
    try:
        from ansicolortags import printc
    except ImportError:
        print("Optional dependancy (ansicolortags) is not available, using regular print function.")
        print("  You can install it with : 'pip install ansicolortags' (or sudo pip)...")
        from ANSIColors import printc
except ImportError:
    print("Optional dependancy (ANSIColors) is not available, using regular print function.")
    print("  You can install it with : 'pip install ANSIColors-balises' (or sudo pip)...")

    def printc(*a, **kw):
        """ Fake function printc.

        ansicolortags or ANSIColors are not installed...
        Install ansicolortags from pypi (with 'pip install ansicolortags')
        """
        print(*a, **kw)


def openSpecialFile(name):
    """ Open the hidden file '~/.smsapifreemobile_name.b64', read and decode (base64) and return its content.
    """
    assert name in ["number", "user", "password"], "Error: unknown or incorrect value for 'name' for the function openSpecialFile(name) ..."
    printc("<cyan>Opening the hidden file <white>'<u>~/.smsapifreemobile_{}.b64<U>'<cyan>, read and decode (base64) and return its content...<white>".format(name))
    try:
        # raise OSError  # DEBUG
        with open(expanduser('~/') + ".smsapifreemobile_" + name + ".b64") as f:
            variable = b64decode(f.readline()[:-1])
            while variable[-1] == '\n':
                variable = variable[:-1]
            return variable
    except OSError:
        printc("<red>Error: unable to read the file '~/.smsapifreemobile_{}.b64' ...<white>".format(name))
        printc("<yellow>Please check that it is present, and if it not there, create it:<white>")
        if name == "number":
            print("To create '~/.smsapifreemobile_number.b64', use your phone number (like '0612345678', not wiht +33), and execute this command line (in a terminal):")
            printc("<black>echo '0612345678' | base64 > '~/.smsapifreemobile_number.b64'<white>".format())
        elif name == "user":
            print("To create '~/.smsapifreemobile_user.b64', use your Free Mobile identifier (a 8 digit number, like '83123456'), and execute this command line (in a terminal):")
            printc("<black>echo '83123456' | base64 > '~/.smsapifreemobile_user.b64'<white>".format())
        elif name == "password":
            print("To create '~/.smsapifreemobile_password.b64', go to this webpage, https://mobile.free.fr/moncompte/index.php?page=options&show=20 (after logging to your Free Mobile account), and copy the API key (a 14-caracters string on [a-zA-Z0-9]*, like 'H6ahkTABEADz5Z'), and execute this command line (in a terminal):")
            printc("<black>echo 'H6ahkTABEADz5Z' | base64 > '~/.smsapifreemobile_password.b64<white>' ".format())


#: Number (not necessary)
# number = b64decode(open(expanduser('~') + ".smsapifreemobile_number.b64").readline()[:-1])
# if number[-1] == '\n':
#     number = number[:-1]
number = openSpecialFile("number")

# Detect language
language = getenv("LANG")
language = language[0:2] if language else "fr"


# Maximum size that can be sent
# XXX Reference: https://en.wikipedia.org/wiki/Short_Message_Service#Message_size
MAX_SIZE = 3 * 159
STR_MAX_SIZE = "3*159"



if language == "fr":
    errorcodes = {
        400: "Un des paramètres obligatoires est manquant.",
        402: "Trop de SMS ont été envoyés en trop peu de temps.",
        403: """Le service n'est pas activé sur l'espace abonné, ou login / clé incorrect.
Allez sur '<black>https://mobile.free.fr/moncompte/index.php?page=options&show=20<white>' svp, et activez l'option correspondate.""",
        500: "Erreur côté serveur. Veuillez réessayez ultérieurement.",
        1:   "Le SMS a été envoyé sur votre mobile ({}).".format(number),
        "toolong": "<red>Attention<white> : le message est trop long (+ de <black>{}<white> caracters, soit plus de 3 SMS).".format(STR_MAX_SIZE)
    }
else:
    errorcodes = {
        400: "One of the necessary parameter is missing.",
        402: "Too many SMSs has been sent in a short time (you might be a spammer!).",
        403: """Access denied: the service might not be activated on the online personnal space, or login/password is wrong.
Please go on '<black>https://mobile.free.fr/moncompte/index.php?page=options&show=20<white>' please, and enable the corresponding option.""",
        500: "Error from the server side. Please try again later.",
        1:   "The SMS has been sent to your mobile ({}).".format(number),
        "toolong": "<red>Warning<white>: message is too long (more than <black>{}<white> caracters, so more than 3 SMS).".format(STR_MAX_SIZE)
    }


def send_sms(text="Empty!", secured=True):
    """ Sens a free SMS to the user identified by [user], with [password].

    :user: Free Mobile id (of the form [0-9]{8}),
    :password: Service password (of the form [a-zA-Z0-9]{14}),
    :text: The content of the message (a warning is displayed if the message is bigger than 480 caracters)
    :secured: True to use HTTPS, False to use HTTP.

    Returns a boolean and a status string.
    """
    # DONE split the text into smaller pieces if length is too big (automatically, or propose to do it ?)
    if len(text) > MAX_SIZE:
        printc(errorcodes["toolong"])
        nb_sub_messages = len(text) / MAX_SIZE
        printc("\n<red>Warning<white>: message will be split in <red>{} pieces<white> of size smaller than <black>{} characters<white>...".format(nb_sub_messages, MAX_SIZE))
        printc("  <magenta>Note that new lines and other information can be lost!<white>")
        for i, index in enumerate(range(0, len(text), MAX_SIZE)):
            answer = send_sms(text[index: index + MAX_SIZE])
            printc("For piece #{} of the message, the answer is:\n  <magenta>{}<white>...\n".format(i + 1, answer[1]))
        return answer
        # raise ValueError(errorcodes["toolong"])

    # Read number, user, password

    #: Identification Number free mobile
    # user = b64decode(open(expanduser('~') + ".smsapifreemobile_user.b64").readline()[:-1])
    # if user[-1] == '\n':
    #     user = user[:-1]
    user = openSpecialFile("user")

    #: Password
    # password = b64decode(open(expanduser('~') + ".smsapifreemobile_password.b64").readline()[:-1])
    # if password[-1] == '\n':
    #     password = password[:-1]
    password = openSpecialFile("password")

    # FIXME find a way to secure this step better than the way it is right now.

    printc("\n<green>Your message is:<white>\n<yellow>" + text + "<white>")
    dictQuery = {"user": user, "pass": password, "msg": text}
    url = "http" + ("s" if secured else "")
    printc("\nThe web-based query to the Free Mobile API (<u>{}://smsapi.free-mobile.fr/sendmsg?query<U>) will be based on:\n{}.".format(url, dumps(dictQuery, sort_keys=True, indent=4)))

    query = urlencode(dictQuery)
    url += "://smsapi.free-mobile.fr/sendmsg?{}".format(query)

    try:
        urlopen(url)
        return 0, errorcodes[1]
    except HTTPError as e:
        if hasattr(e, "code"):
            return e.code, errorcodes[e.code]
        else:
            print("Unknown error...")
            return 2, "Unknown error..."


def main(argv):
    """ Main function. Use the arguments of the command line (sys.argv).
    """
    # FIXME use docopt to handle the command line arguments! Cf. http://docopt.org/
    # FIXME can docopt handle a cli documentation with ansicolortags tags in it? Cf. http://ansicolortags.rtfd.io/
    # Manual handing of the command line arguments
    if "-h" in argv or "--help" in argv:
        printc("""
<green>FreeSMS.py<white> --help|-h | -f file | body of the message

A simple Python script to send a text message to a Free Mobile phone.
The message should be smaller than 480 caracters.

<u>Examples:<U>
<black>$ FreeSMS.py --help<white>
Print this help message!

<black>$ FreeSMS.py -f MyMessageFile.txt<white>
Try to send the content of the file MyMessageFile.txt.

<black>$ FreeSMS.py "I like using Python to send me SMS from my laptop -- and it"s free thanks to Free !"<white>
Will send a test message to your mobile phone.

<magenta>Copyleft 2014-16 Lilian Besson (License GPLv3)<white>
<b>FreeSMS.py is distributed in the hope that it will be useful,
but <red>WITHOUT ANY WARRANTY<white>; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.<reset><white>
""")
        return 0

    if "-f" in argv:
        try:
            with open(argv[argv.index("-f") + 1], 'r') as filename:
                text = "".join(filename.readlines())[:-1]
        except Exception as e:
            print(e)
            print("Trying to use the rest of the arguments to send the text message...")
            text = " ".join(argv)
    else:
        if argv:
            # Text of the SMS
            text = " ".join(argv)
            text = text.replace("\\n", "\n")
            # Durty hack to have true new lines in the message
        else:
            text = """Test SMS sent from {machinename} with FreeSMS.py (the {date}).

    (a Python 2.7+ / 3.1+ script by Lilian Besson, open source, you can find the code
    at https://bitbucket.org/lbesson/bin/src/master/FreeSMS.py
    or http://perso.crans.org/besson/bin/FreeSMS.py)

    For any issues, reach me by email at jarvis[at]crans[dot]org !"""
            # FIXED Check that this is working correctly!
            machinename = "jarvis.crans.org"  # Default name!
            try:
                machinename = open("/etc/hostname").readline()[:-1]
            except OSError:
                print("Warning: unknown machine name (file '/etc/hostname' not readable?)...")
                machinename = "unknown machine"
            text = text.format(date=today, machinename=machinename)
            text = text.replace("[at]", "@").replace("[dot]", ".")

    answer = send_sms(text)
    print(answer[1])
    return answer[0]


if __name__ == "__main__":
    # from doctest import testmod  # DEBUG ?
    # testmod(verbose=False)  # DEBUG ?
    sys.exit(int(main(sys.argv[1:])))
