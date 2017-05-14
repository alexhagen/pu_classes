import numpy as np
from scipy import integrate
import sys
sys.path.append("/Users/ahagen/code")
from pymf import ctmfd as ahi
from pym import func as ahf
from pyg import twod as ahp

nonuniform = int(sys.argv[1])

arr = np.loadtxt('sim/0000')
z = arr[:, 0] * 1.0E4
C = arr[:, 1]

concentration1 = ahf.curve(z, C, name=r'$t=0\,\mathrm{s}$')

plot = ahp.ah2d()
concentration1.plot(linestyle='-', linecolor='#5C8727', addto=plot)
plot.lines_on()
plot.markers_off()

arr = np.loadtxt('sim/0001')
z = arr[:, 0] * 1.0E4
C = arr[:, 1]

concentration2 = ahf.curve(z, C, name=r'$t=1\,\mathrm{\mu s}$')
concentration2.plot(linestyle='-', linecolor='#2EAFA4', addto=plot)
plot.lines_on()
plot.markers_off()

arr = np.loadtxt('sim/0004')
z = arr[:, 0] * 1.0E4
C = arr[:, 1]

concentration3 = ahf.curve(z, C, name=r'$t=1\,\mathrm{ms}$')
concentration3.plot(linestyle='-', linecolor='#7ED0E0', addto=plot)

arr = np.loadtxt('sim/0006')
z = arr[:, 0] * 1.0E4
C = arr[:, 1]

concentration4 = ahf.curve(z, C, name=r'$t=100\,\mathrm{ms}$')
concentration4.plot(linestyle='-', linecolor='#7299C6', addto=plot)

plot.lines_on()
plot.markers_off()
plot.ylabel(r'Concentration ($C$) [$\mathrm{\frac{atoms}{cm^{3}}}$]')
plot.xlabel(r'Position ($z$) [$\mathrm{\mu m}$]')
plot.legend()
plot.ylim(0.0, 5.0E21)
for x in z[::10]:
    plot.add_vline(x, 0.0, 5.0E21, lw=0.5, color='#D1D3D4')

if nonuniform == 1:
    plot.export('full_result_nonuniform', formats=['pdf', 'pgf'], sizes=['cs'],
                customsize=(7, 4))
    plot.show()
else:
    plot.export('full_result_uniform', formats=['pdf', 'pgf'], sizes=['cs'],
                customsize=(7, 4))
    plot.show()
