import sys
sys.path.append('/home/ahagen/code/')
from pym import func as ahf
from pyg import twod as ahp
import numpy as np

gold = '#B1810B'
teal = '#2EAF9B'

r2r1 = np.linspace(0.,10.,1000)
R = np.divide(r2r1 - 1., r2r1 + 1.)
T = np.divide(2. * r2r1, r2r1 + 1.)
Ri = np.divide(np.power(r2r1 - 1., 2), np.power(r2r1 + 1., 2))
Ti = np.divide(4. * r2r1,  np.power(r2r1 + 1., 2))

plot = ahp.ah2d()
plot.add_line(r2r1, R, name=r'$R$', linestyle='-', linecolor=gold)
plot.add_line(r2r1, T, name=r'$T$', linestyle='-', linecolor=teal)
plot.add_line(r2r1, Ri, name=r'$R_{I}$', linestyle='-.', linecolor=gold)
plot.add_line(r2r1, Ti, name=r'$T_{I}$', linestyle='-.', linecolor=teal)
plot.markers_off()
plot.lines_on()
plot.legend(loc=3)
plot.ylim(-2.,3.)
plot.xlim(0.,12.)
plot.add_hline(0.,0.,10., ls='--', color='gray')
plot.xlabel(r'$\nicefrac{r_{2}}{r_{1}}$')
plot.ylabel(r'Coefficient')
plot.export('coefficients', formats=['png','pgf'], sizes=['cs'], customsize=(6.,2.5))

rho_1 = 1.0
L = 1.0
c_1 = 1.0
omega = np.linspace(0., 3.* c_1 * np.pi / L, 500.)
z = -rho_1 * c_1 * np.tan(omega * L / c_1)
plot = ahp.ah2d()
plot.add_line(omega, z, name=r'$z_{n}$', linestyle='-', linecolor=gold)
plot.lines_on()
plot.markers_off()
plot.ylim(-10., 10.)
for n in np.arange(1.,7.,2.):
    plot.add_vline(n * c_1 * np.pi / (2.0 * L), -10, 10, ls='--', color='gray')
    plot.add_data_pointer(n * c_1 * np.pi / (2.0 * L), point=0.,
                          string=r'$\frac{%d c_{1} \pi}{2L}$' % (n),
                          place=(n * c_1 * np.pi / (2.0 * L) + 1., -2.))
plot.add_hline(0.,0.,10., ls='--', color='gray')
plot.xlabel(r'$\omega_{1}$')
plot.ylabel(r'$z_{n}$')
plot.export('impedance', formats=['png', 'pgf'], sizes=['cs'], customsize=(6.,2.5))
