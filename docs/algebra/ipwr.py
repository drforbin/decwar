""" imaginary powers of 10, starting with 10**(i/1024), and squaring successively ten times. this matches with 
feynman's table 22-3. the rounded version gives the same x value in the last iteration as feynman's, -0.66928. note 
the initial y = .00225 should be .0022486, just as in the text. the same rounding is used here as there."""
from math import sqrt
y = .00225
x = sqrt(1. - y**2)
for _ in range(11):
    print('%10.5f %10.5f' % (x, y))
    x2 = x**2 - y**2
    y2 = 2 * x * y
    x, y = x2, y2
