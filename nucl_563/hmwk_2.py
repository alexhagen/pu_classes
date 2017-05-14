from pyg import twod
from pym import func
import numpy as np

Edot = np.array([57., 85., 105., 150., 135., 165.])
Edot = Edot * 2.205
d = Edot
W = np.array([2000, 4000])
T = 8.6E-2 * d
print T
v = 30.

for _T, _d in zip(T, d):
    for _W in W:
        R = _d / (4.42E-2 + (2.21E-4 * v) + (((3.95E-2)/_W) + 1.86E-5)*v*v)
        print '%6.4f, %6.4f, %.1e, %6.4f' % (_T, _W, 5.22 * _W * _T, R)
