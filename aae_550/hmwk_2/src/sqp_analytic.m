clear all;
% linear inequality constraints
A = [-1, 0; 1, 0; 0, -1; 0, 1; -8, 1];
b = [-0.05; 5; -0.05; 5; 0];
% no linear equality constraints
Aeq = [];
beq = [];
% lower bounds
lb = [];
% upper bounds
ub = [];
% set options for medium scale algorithm with active set (SQP as described
% in class; these options do not include user-defined gradients
options = optimoptions('fmincon', 'Algorithm', 'sqp', ...
    'GradObj', 'on', 'GradConstr', 'on', 'Display', 'iter');
% initial guess  - note that this is infeasible
x0 = [6; 0.01];
[x,fval,exitflag,output] = fmincon('objective_function', x0, A, b, Aeq, ...
    beq, lb, ub, 'nonlinear_constraints', options)