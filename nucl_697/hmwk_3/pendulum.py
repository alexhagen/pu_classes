import numpy as np
from scipy import integrate
import sys
sys.path.append("/Users/ahagen/code")
from pymf import ctmfd as ahi
from pym import func as ahf
from pyg import twod as ahp

def deriv(Y, t):
    return [Y[1], -0.5 * Y[1] - 10 * np.sin(Y[0])]

# use integrate.odeint to determine the solution
x = np.linspace(0, 2.5, 1000, endpoint=True)
sol = integrate.odeint(deriv, [.5, 0], x)

ode_solution = ahf.curve(x, sol[:, 0], name='ode')

t_0_25, y_0_25 = np.loadtxt('pendulum_0.250000.dat', usecols=(0, 1), unpack=True)
h_0_25_solution = ahf.curve(t_0_25, y_0_25, name=r'$h = 0.25 \mathrm{s}$')

t_0_125, y_0_125 = np.loadtxt('pendulum_0.125000.dat', usecols=(0, 1),
                              unpack=True)
h_0_125_solution = ahf.curve(t_0_125, y_0_125,
                             name=r'$h = 0.125 \mathrm{s}$')

t_0_00001, y_0_00001 = np.loadtxt('pendulum_0.000244.dat', usecols=(0, 1),
                                  unpack=True)
h_0_00001_solution = ahf.curve(t_0_00001, y_0_00001,
                               name=r'$h = 0.000244 \mathrm{s}$')

plot = ahp.ah2d()
plot = h_0_25_solution.plot(linecolor='#7ED0E0', linestyle='-', addto=plot)
plot = h_0_125_solution.plot(linecolor='#7299C6', linestyle='-', addto=plot)
plot = h_0_00001_solution.plot(linecolor='#B63F97', linestyle='-', addto=plot)
plot = ode_solution.plot(linecolor='#2EAFA4', linestyle='--', addto=plot)

plot.lines_on()
plot.markers_off()
plot.ylabel(r'Position ($y$) [$\mathrm{cm}$]')
plot.xlabel(r'Time ($t$) [$\mathrm{s}$]')
plot.legend()

plot.export('full_result', formats=['pdf', 'pgf'], sizes=['2'])
plot.show()

h, y = np.loadtxt('convergence.dat', unpack=True)
h_y_curve = ahf.curve(h, y, name='convergence')
plot2 = ahp.ah2d()
plot2 = h_y_curve.plot(linecolor="#E3AE24", linestyle='-', addto=plot2)

plot2.lines_on()
plot2.markers_off()
plot2.ylabel(r'Convergence Parameter ($\varepsilon$) [ ]')
plot2.xlabel(r'Time Step ($h$) [$\mathrm{s}$]')
plot2.ax.set_yscale('log')
plot2.ax.set_xscale('log')

plot2.export('convergence', formats=['pdf', 'pgf'], sizes=['2'])
plot2.show()
