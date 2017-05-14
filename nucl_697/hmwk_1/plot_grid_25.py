import matplotlib
matplotlib.use('pgf')
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import matplotlib.pyplot as plt
import numpy as np
import os
import string

for grid in [11, 15]:
    fig = plt.figure()
    ax = fig.gca(projection='3d')
    arr = np.loadtxt('output_grid_0'+ str(grid) + '_x_0'+ str(grid) +'.dat')
    x = arr[:, 0]
    y = arr[:, 1]
    x = np.reshape(x, (np.sqrt(x.size), np.sqrt(x.size)))
    y = np.reshape(y, (np.sqrt(x.size), np.sqrt(x.size)))
    z = arr[:, 2]
    z = np.reshape(z, x.shape)
    surf = ax.plot_surface(x, y, z, cmap=cm.coolwarm,
                           rstride=1, cstride=1, alpha=0.8)

    ax.view_init(elev=21., azim=-113.)
    ax.set_xlabel(r'log $T$ [$K$]')
    ax.set_ylabel(r'log $\rho$ [$\frac{g}{cm^{3}}$]')
    ax.set_zlabel(r'log $k$ [$\frac{W}{cm \cdot K}$]')
    fig.set_size_inches(6, 3)
    filename = 'plot_'+str(grid)+'.pgf'
    fig.savefig(filename,
                transparent=True)
    f=open(filename,'r')
    fstring = "\\centering \n" + f.read()
    f.close()
    f=open(filename,'w')
    fstring=fstring.replace("\\rmfamily\\fontsize{8.328000}{9.993600}\\selectfont","\\scriptsize")
    fstring=fstring.replace("\\rmfamily\\fontsize{12.000000}{14.400000}\\selectfont","\\normalsize")
    fstring = filter(lambda x: x in string.printable, fstring);
    f.write(fstring)
    f.close()
