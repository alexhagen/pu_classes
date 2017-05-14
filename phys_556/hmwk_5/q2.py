import sys
import os
sys.path.append(os.environ['HOME'] + '/code')
from pyg import twod as ahp
from pym import func as ahf
import numpy as np

gold = '#E3AE24'
teal = '#2EAFA4'
orange = '#B95915'

t = [0., 1., 2., 3., 4., 5., 6., 7., 8., 9., 10., 20., 40., 60., 80., 100.,
     120., 140., 160., 180., 200.]
alpha = np.log(np.array([102515., 79205., 61903., 48213., 37431., 29367., 23511.,
                  18495., 14829., 11853., 9595., 2372., 1421., 1135., 862.,
                  725., 551., 462., 359., 265., 225.]) / 3600.)
t_1 = np.linspace(0., 50.)
m_1 = (-0.4 - 3.3) / 20.0
alpha_1 = m_1 * t_1 + 3.3
t_2 = np.linspace(20., 200.)
m_2 = ((-2.8 + 0.4) / 180.)
alpha_2 = m_2 * t_2 + m_2 * 20.
curve = ahf.curve(t, alpha, name=r'$\alpha_{1} + \alpha_{2}$')
a1 = ahf.curve(t_1, alpha_1, name=r'$\alpha_{1}$')
a2 = ahf.curve(t_2, alpha_2, name=r'$\alpha_{2}$')
plot = curve.plot(linecolor=gold, linestyle='-')
plot = a1.plot(linecolor=teal, linestyle='--', addto=plot)
plot = a2.plot(linecolor=orange, linestyle='--', addto=plot)
plot.lines_on()
plot.markers_off()
plot.xlabel(r'Time ($t$) [$d$]')
plot.ylabel(r'Log Activity ($\ln \left( \alpha_{X} \right)$) [$bq$]')
plot.legend()
plot.add_data_pointer(0., curve=curve,
                      string=r'$\alpha \left( %.1f \right) = %.1f$' %
                      (0.0, curve.at(0.0)), place=(20., 2.))
plot.add_data_pointer(20., curve=curve,
                      string=r'$\alpha \left( %.1f \right) = %.1f$' %
                      (20.0, curve.at(20.0)), place=(50., 0.))
plot.add_data_pointer(200., curve=curve,
                      string=r'$\alpha \left( %.1f \right) = %.1f$' %
                      (200.0, curve.at(200.0)), place=(150., -1))
plot.add_data_pointer(100., curve=a2,
                      string=r'$\alpha_{2} = \alpha_{20} \exp \left(' +
                      r' %.3f t \right)$' % (m_2), place=(125., 1.))
plot.add_data_pointer(15., curve=a1,
                      string=r'$\alpha_{1} = \alpha_{10} \exp \left(' +
                      r' %.3f t \right)$' % (m_1), place=(50., 1.))
plot.ylim(-3, 4.)
plot.export('q2', formats=['png', 'pgf'], sizes=['cs'], customsize=(6., 2.5))
