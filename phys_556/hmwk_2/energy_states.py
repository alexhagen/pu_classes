import sys
import numpy as np
sys.path.append("/Users/ahagen/code");
from ah_py.data import ctmfd as ahi
from ah_py.calc import func as ahf

a = 1.;
k = 1.;
pi = 3.14150;

x = np.linspace(-a/2.,a/2.,1000);
psi_1 = np.cos(pi*1.*x/a);
p_1 = np.cos(pi*1.*x/a)*np.cos(pi*1.*x/a);
psi_2 = np.cos(pi*3.*x/a) + 3.;
p_2 = np.cos(pi*3.*x/a)*np.cos(pi*3.*x/a) + 3.;
psi_3 = np.cos(pi*5.*x/a) + 6.;
p_3 = np.cos(pi*5.*x/a)*np.cos(pi*5.*x/a) + 6.;
psi_4 = np.cos(pi*7.*x/a) + 9.;
p_4 = np.cos(pi*7.*x/a)*np.cos(pi*7.*x/a) + 9.;

psi_1_curve = ahf.curve(x,psi_1);
p_1_curve = ahf.curve(x,p_1);
plot = psi_1_curve.plot(linestyle='-');
plot.lines_on();
plot.markers_off();
plot = p_1_curve.plot(addto=plot,linestyle='--');
plot.lines_on();
plot.markers_off();
plot.fill_between(x,np.zeros_like(p_1),p_1,fc="#000000");
psi_2_curve = ahf.curve(x,psi_2);
p_2_curve = ahf.curve(x,p_2);
plot = psi_2_curve.plot(addto=plot,linecolor="#A3792C",linestyle='-');
plot.lines_on();
plot.markers_off();
plot = p_2_curve.plot(addto=plot,linecolor="#A3792C",linestyle='--');
plot.lines_on();
plot.markers_off();
plot.fill_between(x,3.+np.zeros_like(p_2),p_2,fc="#A3792C");
psi_3_curve = ahf.curve(x,psi_3);
p_3_curve = ahf.curve(x,p_3);
plot = psi_3_curve.plot(addto=plot,linecolor="#B95915",linestyle='-');
plot.lines_on();
plot.markers_off();
plot = p_3_curve.plot(addto=plot,linecolor="#B95915",linestyle='--');
plot.lines_on();
plot.markers_off();
plot.fill_between(x,6.+np.zeros_like(p_3),p_3,fc="#B95915");
psi_4_curve = ahf.curve(x,psi_4);
p_4_curve = ahf.curve(x,p_4);
plot = psi_4_curve.plot(addto=plot,linecolor="#2EAFA4",linestyle='-');
plot.lines_on();
plot.markers_off();
plot = p_4_curve.plot(addto=plot,linecolor="#2EAFA4",linestyle='--');
plot.lines_on();
plot.markers_off();
plot.fill_between(x,9.+np.zeros_like(p_4),p_4,fc="#2EAFA4");
plot.yticks([0.,3.,6.,9.],
    ["Energy State 1","Energy State 2","Energy State 3","Energy State 4"]);
plot.xticks([-a/2.,a/2.],["$-\\frac{a}{2}$","$\\frac{a}{2}$"]);
plot.ylim(-1.,10.)
plot.export("img/energy_states",sizes=['cs'],formats=['png','pgf'],customsize=[3,4.5]);
