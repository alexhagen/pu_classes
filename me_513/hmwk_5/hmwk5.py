import sys
sys.path.append('/home/ahagen/code/')
from pym import func as ahf
from pyg import twod as ahp
import numpy as np
import scipy.special

gold = '#B1810B'
teal = '#2EAF9B'
black = '#000000'
purple = '#B63F97'

r_a = np.linspace(0.01, 6., 1000)
rho_0 = 1.
c = 1.0
u_0 = 1.0

plot = ahp.ah2d()
kas = [3., 6., 9., 12.]
colors = [black, gold, teal, purple]
for i in range(len(kas)):
    ka = kas[i]
    color = colors[i]
    p = 2. * rho_0 * c * u_0 * np.abs(np.sin(0.5 * ka * r_a *
                                      (np.sqrt(1. + np.power(r_a, -2.)) - 1.)))
    plot.add_line(r_a, p, name=r"$ka = %d$" % (ka), linestyle='-',
                  linecolor=color)
    plot.markers_off()
    plot.lines_on()

plot.xlabel(r'Scaled distance ($\nicefrac{r}{a}$) [ ]')
plot.ylabel(r'Pressure amplitude ($p$) [ ]')
plot.add_arrow(2., 2.5, 0.25, 1.5, r'$ka \uparrow$')
plot.legend()
plot.export('prob2a', formats=['pdf', 'pgf'], sizes=['2'])

r_a = np.linspace(0.01, 8., 1000)
rho_0 = 1.
c = 1.0
u_0 = 1.0

plot = ahp.ah2d()
ka = 12.
p = 2. * rho_0 * c * u_0 * np.abs(np.sin(0.5 * ka * r_a *
                                  (np.sqrt(1. + np.power(r_a, -2.)) - 1.)))
p_a = 0.5 * rho_0 * c * u_0 * np.power(r_a, -1.) * ka
plot.add_line(r_a, p, name=r"$ka = %d$" % (ka), linestyle='-',
              linecolor=black)
plot.add_line(r_a[p_a < 3.], p_a[p_a < 3.], name=r"asymptotic", linestyle='-',
              linecolor=gold)
plot.fill_between(r_a[r_a > 4.26], np.zeros_like(r_a[r_a > 4.26]),
                  2. * np.ones_like(r_a[r_a > 4.26]), fc=gold, leg=False)
plot.markers_off()
plot.lines_on()

plot.ylim(0., 2.)
plot.xlabel(r'Scaled distance ($\nicefrac{r}{a}$) [ ]')
plot.ylabel(r'Pressure amplitude ($p$) [ ]')
plot.add_text(6., 0.35, 'asymptotic region')
plot.legend()
plot.export('prob2b', formats=['pdf', 'pgf'], sizes=['2'])

omega = np.linspace(0.01, 6000., 1000)
rho_0 = 1.
c = 343.0
u_0 = 1.0
a = 1.0
S = np.pi * np.power(a, 2.)

plot = ahp.ah2d()
k = omega / c
J_1 = scipy.special.j1(2. * k * a)
R_1 = 1. - 2. * J_1 / (2. * k * a)
H_1 = scipy.special.struve(1., 2. * k * a)
X_1 = 2. * H_1 / (2. * k * a)
Z_r = rho_0 * c * S * (R_1)
Pi = 0.5 * np.power(u_0, 2.) * Z_r
plot.add_line(omega, Pi, name=r"$\Pi \left(ka \right)", linestyle='-',
              linecolor=black)
plot.fill_between(omega[omega < 900.], np.zeros_like(omega[omega < 900.]),
                  700. * np.ones_like(omega[omega < 900.]), fc=gold, leg=False)
plot.fill_between(omega[omega >= 900.], np.zeros_like(omega[omega >= 900.]),
                  700. * np.ones_like(omega[omega >= 900.]), fc=teal,
                  leg=False)
plot.add_text(450., 650., 'stiffness\ncontrolled')
plot.add_text(3500., 650., 'mass controlled')
plot.markers_off()
plot.lines_on()

plot.xlabel(r'Angular frequency ($\omega$) [ ]')
plot.ylabel(r'Radiated Power ($\Pi$) [ ]')
plot.legend()
plot.export('prob4', formats=['pdf', 'pgf'], sizes=['2'])
