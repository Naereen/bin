#!/usr/bin/env python3
# -*- coding: utf-8; mode: python -*-
""" My not-too-naive answer to https://github.com/dutc/battlegame

I am mainly trying to write fun and "Pythonic" Python, rather than trying to solve the questions.

- Author: Lilian Besson, (C) 2018.
- Online: https://bitbucket.org/lbesson/bin/
- Licence: MIT Licence (http://lbesson.mit-license.org).
"""
__author__ = "Lilian Besson"
__name_of_app__ = "Battle Client"
__version__ = "0.0.1"

import sys
from time import sleep
from random import choice
from docopt import docopt
import numpy as np

# https://stackoverflow.com/a/4896288/5889533
from subprocess import PIPE, Popen
ON_POSIX = 'posix' in sys.builtin_module_names

DEFAULT_X = DEFAULT_Y = 5

# --- Documentation

documentation = f"""{__name_of_app__}.

Usage:
    battleplayer.py [--delay=<delay>] [--size=<xy>] [--server_command=<cmd>]
    battleplayer.py (-h | --help)
    battleplayer.py --version

Options:
    -h --help       Show this screen.
    --version       Show version.
    --server_command=<cmd>  Play against a server launched by 'cmd' [default: ./battleserver.py --random --play].
    --size=<xy>     Set size of the board [default: {DEFAULT_X},{DEFAULT_Y}].
    --delay=<delay> Delay between successive plays, in seconds [default: 0.1].
"""


def main(args):
    cmd = args['--server_command']
    sizex, sizey = [int(i) for i in args['--size'].split(',')]
    delay = float(args['--delay'])

    if '--size' not in cmd:
        cmd += f" --size={sizex},{sizey}"

    if not cmd: return 1

    pipe = Popen(cmd.split(' '), stdout=PIPE, stdin=PIPE, bufsize=1, close_fds=ON_POSIX, universal_newlines=True)
    child_stdin, child_stdout = pipe.stdin, pipe.stdout

    all_possible_positions = [
        (x, y)
        for x in range(sizex)
        for y in range(sizey)
    ]

    def next_play():
        x, y = 0, 0
        if len(all_possible_positions) > 0:
            x, y = choice(all_possible_positions)
            all_possible_positions.remove((x, y))
        print(f"bot: {x},{y}")
        print(f"{x},{y}", file=child_stdin, flush=True)
        return x, y

    while True:
        # 1. playing
        x, y = next_play()
        # 2. seeing output and using it as feedback
        stdout_data = child_stdout.readline()
        print(f"board: {stdout_data}", end='')
        if 'you win!' in stdout_data:
            print("VICTORY!")
            return 0
        # if len(all_possible_positions) == 0:
        #     print("ERROR: cannot play anymore, all positions were tried but the bot did not win!")
        #     return 1
        sleep(delay)

if __name__ == '__main__':
    arguments = docopt(documentation, version=f"{__name_of_app__} v{__version__}")
    sys.exit(main(arguments))
