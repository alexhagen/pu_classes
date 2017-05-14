import numpy as np
from scipy import integrate
import sys
sys.path.append("/Users/ahagen/code")
from pymf import ctmfd as ahi
from pym import func as ahf
from pyg import twod as ahp
import glob

plot = ahp.ah2d()

fname = glob.glob('fem_sol/*.dat')
for i in range(len(fname)):
    arr = np.loadtxt(fname[i])
    z = arr[:, 0] * 1.0E4
    C = arr[:, 1]
    fem = ahf.curve(z, C, name=r'fem')

    plot = fem.plot(linestyle='-', linecolor='#5C8727')
    plot.lines_on()
    plot.markers_off()

    arr = np.loadtxt(fname[i].replace('fem', 'fdm'))
    z = arr[:, 0] * 1.0E4
    C = arr[:, 1]

    fdm = ahf.curve(z, C, name=r'fdm')
    fdm.plot(linestyle='-', linecolor='#2EAFA4', addto=plot)
    plot.lines_on()
    plot.markers_off()

    for x in z[::10]:
        plot.add_vline(x, 0.0, 5.0E17, lw=0.5, color='#D1D3D4')

    arr = np.loadtxt('RANGE.txt')
    z = 1.0E-8 * np.array(arr[:, 0]) * 1.0E4
    S = 1.0E17 * np.array(arr[:, 1]) * 1.0E-6

    t = float(filter(str.isdigit, fname[i])) * 1.0E-5 * 1.0E6

    plot.fill_between(z, np.zeros_like(S), S, fc='#D1D3D4', name=r'$\vec{S}$')
    plot.add_text(0.75E-1, 2.E17, string=r'$%4.1f\,\mu s$' % (t), ha='left')
    plot.ylabel(r'Concentration ($C$) [$\mathrm{\frac{atoms}{cm^{3}}}$]')
    plot.xlabel(r'Position ($z$) [$\mathrm{\mu m}$]')
    plot.legend()
    plot.ylim(0.0, 5.0E17)


    plot.export('../img/full_result_%02d' % (i),
                formats=['png', 'pgf'], sizes=['cs'], customsize=(4.25, 2.125))
    #plot.show()
