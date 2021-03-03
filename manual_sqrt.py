# coding: utf-8
"""
Implements manually the sqrt() function in Python 3, using Héron's method.

@author: Lilian Besson
@date: 26-09-2020
@license: MIT
"""

## Square root

def sqrt(x, epsilon=1e-12, max_nb_iterations=100, x0=None):
    """ Computes an approximation of sqrt(x) with Héron's method."""
    # initial guess of sqrt_x as floor(sqrt(x)) by a simple loop
    assert x >= 0
    if x == 0: return 0
    if x0 is None:
        sqrt_x = 1.0
        while sqrt_x**2 < x:
            sqrt_x += 1
    else:
        sqrt_x = x0
    # now Héron's method
    nbiter = 0
    while (sqrt_x**2 - x) > epsilon and nbiter < max_nb_iterations:
        nbiter += 1
        sqrt_x = (sqrt_x + x / sqrt_x) / 2.0
    return sqrt_x


if __name__ == '__main__':
    for i in range(1, 1000):
        sqrt_i = sqrt(i)
        print(f"sqrt of {i} is computed ~= {sqrt_i}, that's a relative precision of {abs(sqrt_i**2 - i) / i}")
