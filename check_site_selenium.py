#!/usr/bin/env python3
# -*- coding:utf8 -*-
"""
A simple Python 3.4+ script to use selenium to download a URL, research a message inside the interpreted web page (with JavaScript support!), and exit with return code 0 if message is found, 1 if message is not found.

- Copyright 21 Lilian Besson
- License MIT.

Examples
--------
Use it with the Bash script check_site_and_texto_if_changed_selenium.sh

$ check_site_selenium.py "$URL" "$message" "$success"
"""

import sys

try:
    from selenium import webdriver
except ImportError:
    print("selenium module not found")
    print("Install it, see https://selenium-python.readthedocs.io/installation.html")
    from webbrowser import open_new_tab
    open_new_tab("https://selenium-python.readthedocs.io/installation.html")


def main(URL, message, success):
    print(f"Downloading '{URL}'...")
    firefoxOptions = webdriver.FirefoxOptions()
    firefoxOptions.headless = True
    browser = webdriver.Firefox(options=firefoxOptions)

    browser.get(URL)
    source = browser.page_source
    browser.close()

    if message in source:
        print(f"{URL} indique toujours le message recherché :\n\"{message}\"")
    else:
        print(f"{URL} n'indique pas le message recherché :\n\"{message}\"\n{success}")
        # !FreeSMS.py f"{URL} semble indiquer qu'il y a des disponibilités désormais."
        # exit 1 to quit the "watch" loop
        return 1
    return 0


if __name__ == '__main__':
    URL = "https://partners.doctolib.fr/hopital-public/perigueux/vaccination-covid?speciality_id=5494&enable_cookies_consent=1"
    if len(sys.argv) >= 2:
        URL = sys.argv[1]

    message = "ce centre n'a plus de disponibilités"
    if len(sys.argv) >= 3:
        message = sys.argv[2]

    success = "Peut être qu'il y a des disponibilités désormais !"
    if len(sys.argv) >= 4:
        message = sys.argv[3]

    sys.exit(main(URL, message, success))
