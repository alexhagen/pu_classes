function phi = sumt_phi_elpm(x,r_p,epsilon)

% compute values of the objective function and constraints at the current
% value of x
f = sumt_fun(x);
g = sumt_con(x);

% exterior penalty function
ncon = length(g);   % number of constraints
P = 0;              % intialize P value to zero
for j = 1:ncon
    if g(j) <= epsilon
        P = P - 1/g(j);
    else
        P = P - (2*epsilon - g(j))/(epsilon^2);
    end
end
phi = f + r_p * P;
