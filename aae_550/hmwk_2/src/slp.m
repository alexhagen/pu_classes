clear all;
parameters;
x0 = [2.5; 2.5];
delta_x = [5.0, 5.0];

epsilon_f = 1e-04;
epsilon_g = 1e-04;
epsilon_h = 1e-04;
max_ii = 100;

options = optimoptions('linprog','Algorithm','simplex','Display','iter');
lb = [-Inf;-Inf];
ub = [Inf;Inf];

f_last = 1e+5;
ii = 0;

x = x0;
[f, grad_f] = objective_function(x);
[g, ~, grad_g, ~] = constraints(x);

while (((abs(f_last - f) >= epsilon_f) || (max(g) >= epsilon_g)) ...
        && (ii < max_ii))
    % increment counter
    ii = ii + 1;
    
    % store 'f_last' value
    f_last = f;
    
    % linprog uses vector of coefficients as input; does not need constant 
    % term
    fhat = grad_f;
    
    A = grad_g';
    b = grad_g' * x0 - g';  
    
    Aeq = [];
    beq = [];
    
    lb_LP = max(x0' - delta_x, lb');
    ub_LP = min(x0' + delta_x, ub');
    
    [x,fval,exitflag,output] = linprog(fhat,A,b,Aeq,beq,lb_LP,ub_LP,x0,...
        options);
    
    [f, grad_f] = objective_function(x);
    [g, ~, grad_g, ~] = constraints(x);
    
    x0 = x;
end