import numpy as np
from pyg import twod as pyg
from pym import func as pym

k_33 = [0.48, 0.70, 0.71]
d_33 = [149.e-12, 285.e-12, 374.e-12]
g_33 = [14.0e-3, 24.9e-3, 24.8e-3]
Y_33 = [11.1e10, 6.6e10, 5.3e10]
K_33 = [1200., 1300., 1700.]

s = 51.71e6
l = 1.27e-3

V = np.array(g_33) * l * s

print V

C = 500.e-12
C_0 = 3000.e-12

V_0 = V*C / (C_0 + C)

print V_0

A = 1.27e-4

F = s * A

W_in = 0.5 * (F**2) * l / (np.array(Y_33) * A)

print W_in

f = 120.0/(2.0 * np.pi)

P_in = f * W_in

print P_in

Q = np.array(d_33) * F

print Q

W_out = 0.5 * (Q**2) / C #W_in * np.power(np.array(k_33), 2.0) #

print W_out

P_out = f * W_out

print P_out

W_i = 600.0e3
theta = 3.0 * np.pi / 2.0
xi = 0.99
A_1s = np.linspace(1., 5., 5)
P_2 = np.linspace(2.e8, 10.e8, 10)
epsilon_0 = 8.854e-12
M = 2.0 * 938.0e8 * (1.6e-13)
q = 1.0
alpha = 1.0
R_E = alpha / (1.0 - xi)
plot = pyg.pyg2d()
for A_1 in A_1s:
    a = 4.0 * epsilon_0 * A_1 * theta * np.sqrt(0.5/M)/(q**2)
    h_2 = np.sqrt(a * np.sqrt(xi) * np.power(W_i, 5./2.) / (P_2 * (1-xi)))
    r_2 = R_E * A_1 / (h_2 * theta)
    heights = pym.curve(P_2, h_2, name='$h_{2, %d m^{2}}$' % A_1)
    plot = heights.plot(linestyle='--', linecolor='black', addto=plot)
    plot.add_text(1.9e8, h_2[0], string=r'$h_{2}\left( %d m^{2}\right)$' % A_1, ha='right')
    radii = pym.curve(P_2, r_2, name='$r_{2, %d m^{2}}$' % A_1)
    if A_1 == 1.0:
        yy = True
        axes = None
    else:
        yy = False
        axes = plot.ax2
    plot = radii.plot(linestyle=':', linecolor='black', yy=yy, axes=axes, addto=plot)
    plot.add_text(10.1e8, r_2[-1], string=r'$r_{2}\left( %d m^{2}\right)$' % A_1, axes=plot.ax2, ha='left')
plot.xlabel('Beam Power ($P_{2}$) [$W$]')
plot.ylabel('Exit Height ($h_{2}$) [$m$]')
plot.ylabel('Exit Radius ($r_{2}$) [$m$]', axes=plot.ax2)
plot.markers_off()
plot.lines_on()
plot.xlim(1.0E8, 11.E8)
#plot.export('expander_size', sizes=['2'], ratio='silver', formats=['pdf', 'pgf'])
#plot.show()

W_i = np.linspace(100.0e3, 500.0e3, 25)
theta = 3.0 * np.pi / 2.0
xi = 0.99
P_2s = [100.0E6, 500.0e6]
epsilon_0 = 8.854e-12
M = 2.0 * 938.0e8 * (1.6e-13)
q = 1.0
alpha = 1.0
R_E = alpha / (1.0 - xi)
A_1 = 2.0
plot = pyg.pyg2d()
for P_2 in P_2s:
    a = 4.0 * epsilon_0 * A_1 * theta * np.sqrt(0.5/M)/(q**2)
    h_2 = np.sqrt(a * np.sqrt(xi) * np.power(W_i, 5./2.) / (P_2 * (1-xi)))
    r_2 = R_E * A_1 / (h_2 * theta)
    heights = pym.curve(W_i, h_2, name='$h_{2, %d}$' % (P_2/1.0E6))
    plot = heights.plot(linestyle='--', linecolor='black', addto=plot)
    plot.add_text(90.0E3, h_2[0], string=r'$h_{2}\left( %d MW\right)$' % (P_2/1.0E6), ha='right')
    radii = pym.curve(W_i, r_2, name='$r_{2, %d}$' % (P_2/1.0E6))
    if P_2 == 100.0E6:
        yy = True
        axes = None
    else:
        yy = False
        axes = plot.ax2
    plot = radii.plot(linestyle=':', linecolor='black', yy=yy, axes=axes, addto=plot)
    plot.add_text(510.0E3, r_2[-1], string=r'$r_{2}\left( %d MW\right)$' % (P_2/1.0E6), axes=plot.ax2, ha='left')
plot.xlabel('Ion Energy ($W_{i}$) [$eV$]')
plot.ylabel('Exit Height ($h_{2}$) [$m$]')
plot.ylabel('Exit Radius ($r_{2}$) [$m$]', axes=plot.ax2)
plot.markers_off()
plot.lines_on()
plot.xlim(0.0, 600.0E3)
plot.export('expander_size_with_ions', sizes=['2'], ratio='silver', formats=['pdf', 'pgf'])
plot.show()
