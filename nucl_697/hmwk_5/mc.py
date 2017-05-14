import numpy as np
from scipy import integrate
import sys
sys.path.append("/Users/ahagen/code")
from pymf import ctmfd as ahi
from pym import func as ahf
from pyg import twod as ahp

arr = np.loadtxt('mc_results_4.dat')
z = arr[:, 0]
C = arr[:, 1]

mc4 = ahf.curve(z, C, name=r'$N = 10^{4}$')

plot = ahp.ah2d()
mc4.plot(linestyle='-', linecolor='#5C8727', addto=plot)
plot.lines_on()
plot.markers_off()

arr = np.loadtxt('mc_results_6.dat')
z = arr[:, 0]
C = arr[:, 1]

mc6 = ahf.curve(z, C, name=r'$N = 10^{6}$')
mc6.plot(linestyle='-', linecolor='#2EAFA4', addto=plot)

plot.lines_on()
plot.markers_off()

arr = np.loadtxt('mc_results_8.dat')
z = arr[:, 0]
C = arr[:, 1]

mc8 = ahf.curve(z, C, name=r'$N = 10^{8}$')
mc8.plot(linestyle='--', linecolor='#5C6F7B', addto=plot)

plot.lines_on()
plot.markers_off()

plot.ylabel(r'Fluence ($\Phi$) [$\mathrm{\frac{J}{cm^{2}}}$]')
plot.xlabel(r'Position ($r$) [$\mathrm{cm}$]')
plot.legend()
for x in z[::10]:
    plot.add_vline(x, 0.0, 0.6, lw=0.5, color='#D1D3D4')
plot.xlim(0., 0.1)
plot.ylim(0., 0.4)

plot.export('full_result', formats=['pdf', 'pgf'], sizes=['cs'],
            customsize=(7, 2.8))
plot.show()

plot.xlim(0., 0.010)
plot.export('full_result_closeup', formats=['pdf', 'pgf'], sizes=['cs'],
            customsize=(4, 2.8))
plot.show()

plot = ahp.ah2d()
mc = ahf.curve([0.5], [0.5], name=r'example')
mc.plot(linecolor='#E3AE24', addto=plot)
plot.xlim(0., 1.)
plot.ylim(0., 1.)
plot.export('example_empty', formats=['pdf', 'pgf'], sizes=['cs'],
            customsize=(1, 1))
plot.show()

x = np.linspace(0., 1., 100)
Gamma = np.exp(- np.power(x, 2.) / np.power(1.0e-2 / 2.0e-1, 2.))
G = ahf.curve(x, Gamma, name=r'$\Gamma$')
G.plot(linecolor='#A7A9AC', linestyle='-', addto=plot)

plot.fill_between(x, np.zeros_like(x), Gamma, fc='#A7A9AC')
plot.lines_on()
plot.markers_off()

plot.lines['example0'].set_alpha(1.0)
plot.lines['example0'].set_markersize(6)

plot.export('example_gaussian', formats=['pdf', 'pgf'], sizes=['cs'],
            customsize=(1, 1))
plot.show()
