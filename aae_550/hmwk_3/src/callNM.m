% this file provides input for and calls fminsearch to use the Nelder-Mead
% Simplex method
% Modified last on 11/28/16 by Alex Hagen.

close all;
clear all;

options = optimset('Display','iter');

x0 = [100; 300];

[x,fval,exitflag,output] = fminsearch('NMfunc',x0,options)

