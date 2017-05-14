close all;
clear all;

% Bring in the header parameters and set the bounds into an input format
% that SA_550 knows
hmwk3_header
bounds = [lb ub;
          lb ub];
% Set our initial design
x0 = [100; 400];
% Set the cooling
T0 = 85;
% Zero out the options array
options = zeros(1,9);
% set a counter for our results array
i = 1;
for r0 = [0.15, 0.5, 0.85]
    % Put the temperature and cooling rate in the appropriate places
    options(1) = T0;
    options(6) = r0;
    % Run SA_550 save the values to a cell array
    [xstar, fstar, count, ~, ~, T] = SA_550('SAfunc', bounds, x0, options);
    table(i, :) = {'Run 1', x0, T0, r0, count, T, xstar, fstar};
    % increment the table
    i = i + 1;
end

% Save our results to a latex file so we can use it and update it easily
format short
header = {'', '$\vec{x}^{0}$', '$T_{0}$', '$r_{T}$', '\code{feval}', ...
          '$T$', '$\vec{x}^{*}$', '$f\left( \vec{x}^{*} \right)$'};
matrix2lyx(table,'prob2_3.lyx',header);
