#!/usr/bin/env python
# -*- coding: utf8 -*-
"""Stupid implementation of the Monte-Carlo method.

Reference: https://en.wikipedia.org/wiki/Monte_Carlo_integration
License: GPLv3
Author: Lilian Besson (C) 2014, Mahindra École Centrale."""
import random, math

def montecarlo(f, nb, x0, x1, y0, y1):
    """Approximate the integrale of x --> f(x) from x0 to x1."""
    integral = 0.
    for i in xrange(nb):
        if random.uniform(y0, y1) <= f(random.uniform(x0, x1)):
            integral += 1.
    return integral * (1. / nb) * (y1 - y0) * (x1 - x0)

def printintegrale(f, strf, nb, x0, x1, y0, y1):
    integral = montecarlo(f, nb, x0, x1, y0, y1)
    print("For f : x --> %s, integral from x0=%g to x1=%g is approximately %g (using %i random points with a simple Monte-Carlo method)." % (strf, x0, x1, integral, nb))

print(montecarlo((lambda x: x), 1000000, 0., 1., 0., 1.))
printintegrale((lambda x: x**3), "x^3", 1000000, 0., 1., 0., 1.)
printintegrale((lambda x: 1./(1+(math.sinh(2*x))*(math.log(x)**2))), "1/(1+sinh(2x)log(x)^2)", 1000000, 0.8, 3, 0., 1.)
