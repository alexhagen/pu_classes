import numpy as np
from scipy import integrate
import matplotlib.pyplot as plt
import sys
sys.path.append("/Users/ahagen/code")
from pymf import ctmfd as ahi
from pym import func as ahf
from pyg import twod as ahp
arr = np.loadtxt('fem_unstable/000005.dat')
z = arr[:, 0] * 1.0E4
C = arr[:, 1]
fem = ahf.curve(z, C, name=r'fem')

plot = fem.plot(linestyle='-', linecolor='#B63F97')
plot.lines_on()
plot.markers_off()

for x in z[::10]:
    plot.add_vline(x, 0.0, 5.0E17, lw=0.5, color='#D1D3D4')

arr = np.loadtxt('RANGE.txt')
z = 1.0E-8 * np.array(arr[:, 0]) * 1.0E4
S = np.array(arr[:, 1])
source = ahf.curve(z, S)
S = 1.0E17 * S / np.max(S)

plot.fill_between(z, np.zeros_like(S), S, fc='#D1D3D4', name=r'$\vec{S}$')
plot.ylabel(r'Concentration ($C$) [$\mathrm{\frac{atoms}{cm^{3}}}$]')
plot.xlabel(r'Position ($z$) [$\mathrm{\mu m}$]')
plot.legend()
plot.ylim(0.0, 5.0E17)

plot.export('../img/unstable_result_fem',
            formats=['pdf', 'pgf'], sizes=['cs'], customsize=(4.25, 2.125))
plot.show()

plt.close(plot.fig)
del plot

arr = np.loadtxt('fdm_unstable/000005.dat')
z = arr[:, 0] * 1.0E4
C = arr[:, 1]

fdm = ahf.curve(z, C, name=r'fdm')
fdm.crop(y_min=0.0, y_max=5.0E17)
plot = fdm.plot(linestyle='-', linecolor='#2EAFA4')
plot.lines_on()
plot.markers_off()

for x in z[::10]:
    plot.add_vline(x, 0.0, 5.0E17, lw=0.5, color='#D1D3D4')

arr = np.loadtxt('RANGE.txt')
z = 1.0E-8 * np.array(arr[:, 0]) * 1.0E4
S = np.array(arr[:, 1])
source = ahf.curve(z, S)
S = 1.0E17 * S / np.max(S)

plot.fill_between(z, np.zeros_like(S), S, fc='#D1D3D4', name=r'$\vec{S}$')
plot.ylabel(r'Concentration ($C$) [$\mathrm{\frac{atoms}{cm^{3}}}$]')
plot.xlabel(r'Position ($z$) [$\mathrm{\mu m}$]')
plot.legend()
plot.ylim(0.0, 5.0E17)

plot.export('../img/unstable_result_fdm',
            formats=['pdf', 'pgf'], sizes=['cs'], customsize=(4.25, 2.125))
plot.show()
