#!/usr/bin/env python3
# -*- coding: utf-8; mode: python -*-
""" My not-too-naive answer to https://github.com/dutc/battlegame

I am mainly trying to write fun and "Pythonic" Python, rather than trying to solve the questions.

- Author: Lilian Besson, (C) 2018.
- Online: https://bitbucket.org/lbesson/bin/
- Licence: MIT Licence (http://lbesson.mit-license.org).
"""
__author__ = "Lilian Besson"
__name_of_app__ = "Battle Server"
__version__ = "0.0.1"

import sys
from string import ascii_uppercase
from collections import OrderedDict
from pprint import pprint
from docopt import docopt
import numpy as np


# --- Ships

DEFAULT_X = DEFAULT_Y = 5

ships = OrderedDict({
    # "Carrier": 5,
    # "Battleship": 4,
    # "cRuiser": 3,
    # "Submarine": 3,
    "Destroyer": 2,
})
symbol_of_ship = OrderedDict({
    name: str.lower(list(set(name).intersection(ascii_uppercase))[0])
    for name in ships.keys()
})
# pprint(symbol_of_ship)
ship_of_symbol = OrderedDict({v: k for k, v in symbol_of_ship.items()})


# --- Documentation

documentation = f"""{__name_of_app__}.

Usage:
    battleserver.py {' '.join([f'[--{name.lower()}=<x,y,dir>]' for name in ships.keys()])} [--size=<xy>] (--show | --play)
    battleserver.py (-h | --help)
    battleserver.py --version

Options:
    -h --help       Show this screen.
    --version       Show version.
    --show          Print the board.
    --play          Let you play a "one player" game interactively.
    --size=<xy>     Set size of the board [default: {DEFAULT_X},{DEFAULT_Y}].
    {'    '.join([f'--{name.lower()}=<x,y,dir>     Place ship {name} at position x,y and direction (h or v) [default: {i},0,h].' for i, name in enumerate(list(ships.keys()))])}
""".replace(',h].', ',h].\n')


symbol_of_uint8 = OrderedDict({0: '-'})
symbol_of_uint8.update({
    i+1: symbol_of_ship[name]
    for i, name in enumerate(ships.keys())
})
# pprint(symbol_of_uint8)
uint8_of_symbol = OrderedDict({v: k for k, v in symbol_of_uint8.items()})
# pprint(uint8_of_symbol)


class Board(object):
    def __init__(self, x=DEFAULT_X, y=DEFAULT_Y):
        self.x = x
        self.y = y
        self.board = np.zeros((x, y), dtype=np.uint8)

    def __getitem__(self, *args, **kwargs): return self.board.__getitem__(*args, **kwargs)
    def __setitem__(self, *args, **kwargs): return self.board.__setitem__(*args, **kwargs)

    def is_empty(self):
        return np.all(self.board == 0)

    def get_ship(self, x, y):
        return ship_of_symbol[symbol_of_uint8[self[x, y]]]

    def ship_still_here(self, ship):
        return np.any(self.board == uint8_of_symbol[symbol_of_ship[ship]])

    def show(self):
        for line in self.board:
            print(''.join(symbol_of_uint8[c] for c in line))

    def add_ship(self, name, x=0, y=0, direction='h', debug=True):
        size = ships[name]
        horizontally = (direction == 'v')
        if horizontally:
            if x + size > self.x:
                if debug: print(f"Unable to place ship '{name}' of size {size} at position {x}, {y} horizontally... ({x + size} > {self.x})")
                return 1
            if not set(self.board[x:x+size, y]) == {0}:
                if debug: print(f"Unable to place ship '{name}' at position {x}, {y} horizontally: line from {x} to {x+size} is not empty!")
                return 3
            self.board[x:x+size, y] = uint8_of_symbol[symbol_of_ship[name]]
        else:
            if y + size > self.y:
                if debug: print(f"Unable to place ship '{name}' of size {size} at position {x}, {y} vertically... ({x + size} > {self.x})")
                return 2
            if not set(self.board[x, y:y+size]) == {0}:
                if debug: print(f"Unable to place ship '{name}' at position {x}, {y} vertically: row from {y} to {y+size} is not empty!")
                return 4
            self.board[x, y:y+size] = uint8_of_symbol[symbol_of_ship[name]]
        return 0

    def random_add_ship(self, name, maxTrials=100):
        size = ships[name]
        trial = -1
        retcode = 10
        while trial < maxTrials and retcode > 0:
            retcode = self.add_ship(name, x=np.random.randint(self.x - size + 1), y=np.random.randint(self.y - size + 1), direction=np.random.choice(['h', 'v']), debug=False)
            trial += 1
        return retcode

    def play(self, cheat=True, max_nb_moves=None):
        seen_x_y = set()
        nb_moves = -1
        if max_nb_moves is None: max_nb_moves = self.x * self.y
        while nb_moves < max_nb_moves:
            nb_moves += 1
            if cheat: self.show()
            try:
                action = input("> ")
                if action == '': return
                x, y = [int(i) for i in action.replace(',', ' ').split(' ')]
                if (x, y) in seen_x_y:
                    print("already played")
                seen_x_y.add((x, y))
                if self[x, y] == 0:
                    print("miss")
                else:
                    ship = self.get_ship(x, y)
                    self[x, y] = 0
                    if self.ship_still_here(ship):
                        print(f"hit {ship.lower()}")
                    else:
                        print(f"sunk {ship.lower()}")
                if self.is_empty():
                    print(f"you win! in {nb_moves} moves")
                    return 0
            except ValueError:
                pass
            except (EOFError, KeyboardInterrupt):
                return 2
        return 1


def main(args):
    # pprint(args)
    sizex, sizey = [int(i) for i in args['--size'].split(',')]
    board = Board(x=sizex, y=sizey)
    for name in ships.keys():
        if args[f'--{name.lower()}']:
            if args[f'--{name.lower()}'] == 'r':
                board.random_add_ship(name)
            else:
                x, y, direction = args[f'--{name.lower()}'].split(',')
                board.add_ship(name, x=int(x), y=int(y), direction=direction)
    if args['--show']:
        return board.show()
    elif args['--play']:
        return board.play()


if __name__ == '__main__':
    arguments = docopt(documentation, version=' 2.0')
    sys.exit(main(arguments))
