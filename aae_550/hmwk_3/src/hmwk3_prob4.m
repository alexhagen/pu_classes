close all;
clear all;

hmwk3_prob4_header;
vlb = [1 1 1 lb lb lb lb lb lb];	%Lower bound of each gene - all variables
vub = [4 4 4 ub ub ub ub ub ub];	%Upper bound of each gene - all variables
bits =[2 2 2 12 12 12 12 12 12];	%number of bits describing each gene - all variables
lambda = sum(bits);
% Finding the population size using criteria given in class
N_pop = 4 * lambda;
% Finding the mutation rate using criteria given in class
P_m = (lambda + 1) / (2 * N_pop * lambda);
% Call default options with a modified population size and mutation
% probability
options = goptions([1, 0.9, 0, 0, 0, 0, 0, 0, 0, 0, N_pop, 0, P_m, 200]);

for i = 1:3
    [x, fbest, stats, nfit, fgen, lgen, lfit]= GA550('pseudoobjfunc', ...
                                                     [ ], options, vlb, ...
                                                     vub, bits);
    name = sprintf('Run %d', i);
    g = constraintsfunc(x);
    mass = massfunc(x);
    table(i, :) = {name, N_pop, P_m, max(stats(:,1)), nfit, x, mass, ...
                   g, fbest};
end

% Save our results to a latex file so we can use it and update it easily
format short
header = {'', '$N_{pop}$', '$P_{m}$', '$N_{gen}$', '\code{feval}', ...
          '$\vec{x}^{*}$', '$m$', ...
          '$\vec{g}\left( \vec{x}^{*} \right)$', ...
          '$f\left( \vec{x}^{*} \right)$'};
m2lyx(table,'prob4.lyx',header);
