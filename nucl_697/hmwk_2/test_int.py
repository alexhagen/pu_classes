import sys
import os
import re
import numpy as np
from colour import Color
from dateutil import parser
import matplotlib.dates as md
sys.path.append("/Users/ahagen/code")
from pymf import ctmfd as ahi
from pym import func as ahf
from pyg import twod as ahp

mid = []
trap = []
simp = []

evals = [2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 50, 100]

for i in evals:
    output = os.popen("./maxwellian %d" % (i)).read()
    floats = map(float, output.strip().split("\n"))
    mid = np.append(mid, floats[0])
    trap = np.append(trap, floats[1])
    simp = np.append(simp, floats[2])

mid_curve = ahf.curve(evals, mid, name="midpoint")
trap_curve = ahf.curve(evals, trap, name="trapezoidal")
simp_curve = ahf.curve(evals, simp, name="simpson's")

plot = ahp.ah2d()
mid_curve.plot(linestyle='-', linecolor="#E3AE24", addto=plot)
trap_curve.plot(linestyle='-', linecolor="#746C66", addto=plot)
simp_curve.plot(linestyle='-', linecolor="#2EAFA4", addto=plot)

plot.lines_on()
plot.legend()
plot.xlabel(r'Number of subintervals ($\frac{E_{high} - E_{low}}{h}$) [ ]')
plot.ylabel(r'Probability ($\frac{N\left( E \right)}{N}$) [ ]')

plot.ax.set_xscale('log')

#plot.export("convergence", sizes=['2'], formats=['pdf', 'pgf'])
#os.system("open -a Preview " + "convergence.pdf")

pi = 3.1415926535897932384626433832795028841971693993751058
T= 1000.
k= 0.00008617332478
E_avg = 3.0 * k * T / 2.0
E_low = 0.05 * E_avg
E_high = 2.5 * E_avg
E = np.linspace(E_low, E_high, 1000)
N = 2. * pi * np.sqrt(E) * np.exp(- E / (k * T)) / np.power((pi * k * T), 3. / 2.)

def boltz(E, T):
    return 2. * pi * np.sqrt(E) * np.exp(- E / (k * T)) / np.power((pi * k * T), 3. / 2.)

curve = ahf.curve(E, N, name=r'$f\left( E \right)$')
plot = curve.plot(linestyle='-', linecolor='#000000')
mid = (boltz(1.9 * E_avg, 1000.) + boltz(2.3 * E_avg, 1000.)) / 2.
plot.fill_between([1.9 * E_avg, 2.3 * E_avg], [0., 0.], [mid, mid],
                  name='midpoint', fc='#E3AE24')
plot.add_data_pointer(2.1 * E_avg, point=mid,
                      string='Constant shape of subintervals',
                      place=(0.22, 2))

mid = (boltz(0.1 * E_avg, 1000.) + boltz(0.5 * E_avg, 1000.))/2.
plot.fill_between([0.1 * E_avg, 0.5 * E_avg], [0., 0.],
                  [boltz(0.1 * E_avg, 1000.), boltz(0.5 * E_avg, 1000.)],
                  name='trapezoidal', fc='#746C66')
plot.add_data_pointer(0.3 * E_avg, point=mid,
                      string='Linear shape of subintervals',
                      place=(0.07, 5.5))

E_simp = np.linspace(0.7 * E_avg, 1.7 * E_avg, 1000)
a = np.array([0.7 * E_avg, 1.2 * E_avg, 1.7 * E_avg])
p = np.polyfit(a, boltz(a, T), 2)
n_simp = np.polyval(p, E_simp)
plot.fill_between(E_simp, np.zeros_like(E_simp), n_simp,
                  name="simpson's", fc="#2EAFA4")
plot.add_data_pointer(1.2 * E_avg, point=np.polyval(p, 1.2 * E_avg),
                      string='Quadratic shape of subintervals',
                      place=(0.15, 4))

plot.xlabel(r'Energy ($E$) [$\mathrm{MeV}$]')
plot.ylabel(r'Number ($N\left( E \right)$) [ ]')

plot.lines_on()
plot.markers_off()
plot.legend()

plot.export("method", sizes=['2'], formats=['pdf', 'pgf'])
os.system("open -a Preview " + "method.pdf")
