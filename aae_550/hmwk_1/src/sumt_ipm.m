clear all
format long    % use format long to see differences near convergence

table = [];
x0 = [0.15; 0.015];   % initial design
p = 0;         % initial value of minimization counter 
r_p = 1.0;     % initial value of penalty multiplier 
gamma = 10;

% compute function value at x0, initialize convergence criteria
f = sumt_fun(x0);
f_last = 2 * f;   % ensure that first loop does not trigger convergence
% set optimization options - use default BFGS with numerical gradients
% provide display each iteration
options = optimset('LargeScale', 'off', 'Display', 'iter');  

% begin sequential minimizations  - note tolerances chosen here
% absolute tolerance for change in objective function, absolute tolerance
% for constraints
while ((abs((f-f_last)/f_last) >= 1e-3) || (max(g) >= 1e-5))
    f_last = f;  % store last objective function value
    p            % display current minimization counter
    r_p          % display current penalty multiplier
    % call fminunc - use "phi" pseudo-objective function, note that r_p is
    % passed as a "parameter", no semi-colon to display results
    [xstar,phistar,exitflag,output] = fminunc(@sumt_phi_ipm,x0,options,r_p)
    % compute objective and constraints at current xstar
    f = sumt_fun(xstar);
    g = sumt_con(xstar);
    N = output.funcCount;
    table = [table; p, r_p, xstar(1), xstar(2), f, phistar, N, exitflag];
    p = p + 1;     % increment minimization counter
    r_p = r_p / gamma; % solve rpp
    x0 = xstar;    % use current xstar as next x0
end
% display function and constraint values at last solution
f = sumt_fun(xstar)
g = sumt_con(xstar)
format short
header = {'$p$', '$r_{p}$', '$R$', '$t$', ...
          '$f\left(\vec{x}^{*}\right)$', ...
          '$\phi\left(\vec{x}^{*}\right)$', '$N$', 'exitflag'};
matrix2lyx(table,'ipm.lyx',header);

