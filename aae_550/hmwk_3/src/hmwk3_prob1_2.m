% this file provides input for and calls fminsearch to use the Nelder-Mead
% Simplex method
% Modified last on 11/28/16 by Alex Hagen.

close all;
clear all;

options = optimset('Display','iter');

x0 = [100; 400];

[x,fval,exitflag,output] = fminsearch('NMfunc',x0,options);
table(1, :) = {'Run 1', x0, output.funcCount, x, fval, exitflag};
x0 = x;
[x,fval,exitflag,output] = fminsearch('NMfunc',x0,options);
table(2, :) = {'Re-start', x0, output.funcCount, x, fval, exitflag};

format short
header = {'', '$\vec{x}^{0}$', '\code{feval}', '$\vec{x}^{*}$', ...
          '$f\left( \vec{x}^{*} \right)$', 'exitflag'};
matrix2lyx(table,'prob1_2.lyx',header);