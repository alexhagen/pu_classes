close all;
clear all;


hmwk3_header;
vlb = [lb lb];	%Lower bound of each gene - all variables
vub = [ub ub];	%Upper bound of each gene - all variables
bits =[20 20];	%number of bits describing each gene - all variables
l = sum(bits);
% Finding the population size using criteria given in class
N_pop = 4 * l;
% Finding the mutation rate using criteria given in class
P_m = (l + 1) / (2 * N_pop * l);
% Call default options with a modified population size and mutation
% probability
options = goptions([1, 0.9, 0, 0, 0, 0, 0, 0, 0, 0, N_pop, 0, P_m, 200]);

for i = 1:3
    [x, fbest, stats, nfit, fgen, lgen, lfit]= GA550('GAfunc', [ ], ...
                                                     options, vlb, vub, ...
                                                     bits);
    name = sprintf('Run %d (20 bits)', i);                                             
    table(i, :) = {name, N_pop, P_m, max(stats(:,1)), nfit, x, fbest};
end

bits =[5 5];	%number of bits describing each gene - all variables
l = sum(bits);
% Finding the population size using criteria given in class
N_pop = 4 * l;
% Finding the mutation rate using criteria given in class
P_m = (l + 1) / (2 * N_pop * l);
% Call default options with a modified population size and mutation
% probability
options = goptions([1, 0.9, 0, 0, 0, 0, 0, 0, 0, 0, N_pop, 0, P_m, 200]);

for i = 4:6
    [x, fbest, stats, nfit, fgen, lgen, lfit]= GA550('GAfunc', [ ], ...
                                                     options, vlb, vub, ...
                                                     bits);
    name = sprintf('Run %d (5 bits)', i - 3);  
    table(i, :) = {name, N_pop, P_m, max(stats(:,1)), nfit, x, fbest};
end

% Save our results to a latex file so we can use it and update it easily
format short
header = {'', '$N_{pop}$', '$P_{m}$', '$N_{gen}$', '\code{feval}', ...
          '$\vec{x}^{*}$', '$f\left( \vec{x}^{*} \right)$'};
matrix2lyx(table,'prob3_2.lyx',header);

