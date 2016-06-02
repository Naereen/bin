#!/usr/bin/env python
# -*- coding: utf-8; mode: python -*-
""" A simple and consice Sudoku solver with z3.

- Author: Lilian Besson, (C) 2013.
- Online: https://bitbucket.org/lbesson/bin/
- Licence: MIT Licence (http://lbesson.mit-license.org).
"""

from __future__ import print_function
from z3 import *

# 9x9 matrix of integer variables
X = [[Int("x_%s_%s" % (i + 1, j + 1)) for j in xrange(9)]
     for i in xrange(9)]

# each cell contains a value in {1, ..., 9}
cells_c = [And(1 <= X[i][j], X[i][j] <= 9)
           for i in xrange(9) for j in xrange(9)]

# each row contains a digit at most once
rows_c = [Distinct(X[i]) for i in xrange(9)]

# each column contains a digit at most once
cols_c = [Distinct([X[i][j] for i in xrange(9)])
          for j in xrange(9)]

# each 3x3 square contains a digit at most once
sq_c = [Distinct([X[3 * i0 + i][3 * j0 + j]
                 for i in xrange(3) for j in xrange(3)])
        for i0 in xrange(3) for j0 in xrange(3)]

sudoku_c = cells_c + rows_c + cols_c + sq_c

# sudoku instance, we use '0' for empty cells
instance = [[0, 0, 0, 0, 0, 0, 7, 0, 0],
            [7, 3, 0, 0, 4, 0, 0, 0, 0],
            [1, 0, 0, 7, 5, 0, 0, 3, 0],
            [0, 0, 3, 2, 0, 5, 4, 0, 7],
            [0, 0, 0, 9, 0, 8, 0, 0, 0],
            [2, 0, 7, 1, 0, 4, 5, 0, 0],
            [0, 6, 0, 0, 8, 7, 0, 0, 4],
            [0, 0, 0, 0, 9, 0, 0, 1, 3],
            [0, 0, 2, 0, 0, 0, 0, 0, 0]]

instance_c = [If(instance[i][j] == 0, True, X[i][j] == instance[i][j])
              for i in xrange(9) for j in xrange(9)]

s = Solver()
s.add(sudoku_c + instance_c)
if s.check() == sat:
    m = s.model()
    r = [[m.evaluate(X[i][j]) for j in xrange(9)]
         for i in xrange(9)]
    print_matrix(r)
else:
    print("Failed to solve the grid.")
