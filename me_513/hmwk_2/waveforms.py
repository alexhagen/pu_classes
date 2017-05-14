import sys
import os
import numpy as np
sys.path.append(os.path.expanduser('~') + "code");
from pymf import ctmfd as ahi
from pym import func as ahf
from colour import Color

x = np.linspace(0,1.0);
k_1 = 2.02875;
k_2 = 4.91318;
y_1 = np.sin(k_1*x);
y_2 = np.sin(k_2*x);

fund_curve = ahf.curve(x,y_1,name='Fundamental');
plot = fund_curve.plot(linecolor='#A3792C',linestyle='--');
over_curve = ahf.curve(x,y_2,name='1st Overtone');
plot = over_curve.plot(addto=plot,linecolor='#2EAFA4',linestyle='--');

plot.lines_on();
plot.lines_off();
plot.xlabel('X-Coordinate ($x$) [ ]');
plot.ylabel('Wave Function ($y_{n}$) [ ]');
plot.ylim(-1.5,1.5);
plot.legend();

plot.export("waveforms",sizes=['cs'],formats=['png','svg','pgf'],customsize=[6,3]);
