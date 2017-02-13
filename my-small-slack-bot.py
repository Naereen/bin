#! /usr/bin/env python2
# -*- coding: utf-8; mode: python -*-
""" Small experimental bot for our Slack team at SCEE (https://sceeteam.slack.com/), CentraleSupélec campus de Rennes.

It reads a file full of quotes (from TV shows), and post one randomly at random times on the channel #random.

- *Date:* 13/02/2017.
- *Author:* Lilian Besson, (C) 2017
- *Licence:* MIT Licence (http://lbesson.mit-license.org).
"""

from __future__ import print_function, division  # Python 2 compatibility if needed

import sys
import os
import random
from os.path import join, expanduser
import time

import logging
logging.basicConfig(
    format="%(asctime)s  %(levelname)s: %(message)s",
    datefmt='%m-%d-%Y %I:%M:%S %p',
    level=logging.INFO
)

from numpy.random import poisson
from slackclient import SlackClient

# --- Parameters of the bot

seconds = 60
QUOTE_FILE = os.getenv("quotes", expanduser(join("~", ".quotes.txt")))

SLACK_TOKEN = "FIXME"

USE_CHANNEL = True
SLACK_USER = "@lilian"
SLACK_CHANNEL = "#random"

POISSON_TIME = 30 * seconds


# --- Functions

def sleeptime(use_poisson=True, default_time=30 * seconds):
    """Random time until next message."""
    if use_poisson:
        return poisson(POISSON_TIME)
    else:
        return default_time


def random_line(lines):
    """Read the file and select one line."""
    try:
        return random.choice(lines)
    except:  # Default quote
        logging.info("Failed to read a random line ...")  # DEBUG
        return "I love you !"


def send(text, sc, use_channel=USE_CHANNEL):
    channel = SLACK_CHANNEL if use_channel else SLACK_USER
    logging.info("Sending the message {} to channel/user {} ...".format(text, channel))
    # https://github.com/slackapi/python-slackclient#sending-a-message
    return sc.api_call(
        "chat.postMessage", channel=channel, text=text,
        username="my-small-slack-bot.py", icon_emoji=":robot_face:"
    )


def loop(quote_file=QUOTE_FILE):
    logging.info("Starting my Slack bot, reading random quotes from the file {}...".format(quote_file))
    the_quote_file = open(quote_file, 'r')
    lines = the_quote_file.readlines()
    sc = SlackClient(SLACK_TOKEN)
    while True:
        # 1. get random quote
        text = random_line(lines)
        logging.info("\nNew message:\n{}".format(text))
        send(text, sc)
        # 2. sleep until next quote
        secs = sleeptime()
        str_secs = time.asctime(time.localtime(time.time() + secs))
        logging.info("  ... Next message in {} seconds, at {} ...".format(secs, str_secs))
        time.sleep(secs)
    return 0


# --- Main script

if __name__ == '__main__':
    quote_file = sys.argv[1] if len(sys.argv) > 1 else QUOTE_FILE
    sys.exit(loop(quote_file))

# End of my-small-slack-bot.py
