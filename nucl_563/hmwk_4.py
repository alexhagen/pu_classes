from pyg import twod as pyg
from pym import func as pym
from pyg.colors import pu as puc

plot = pyg.pyg2d()

plot.fill_between([-3., 0.], [-6., -6.], [6., 6.], fc=puc.pu_colors['gray'])
plot.fill_between([0., 5.], [-6., -6.], [-5., -5.], fc=puc.pu_colors['gray'])
plot.fill_between([5., 8.], [-6., -6.], [0., 0.], fc=puc.pu_colors['gray'])

plot.xlim(-3, 8.)
plot.ylim(-6., 6.)
plot.add_text(-1.5, 2., r'I')
plot.add_text(2.5, 3., r'II')
plot.add_text(6.5, 4., r'III')
plot.xticks([0., 5.], [r'$0$', r'$a$'])
plot.yticks([-5, 0., 6], [r'$-V_{0}$', r'$0$', r'$\infty$'])
plot.xlabel(r'$x$')
plot.ylabel(r'$V\left(x\right)$')
plot.export('schrodinger_half_infinite_well', formats=['pdf', 'pgf'],
            sizes=['cs'], customsize=(1.5,1.5))
plot.show()
