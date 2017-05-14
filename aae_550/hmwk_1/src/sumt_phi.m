function phi = sumt_phi(x,r_p)

% compute values of the objective function and constraints at the current
% value of x
f = sumt_fun(x);
g = sumt_con(x);

% exterior penalty function
ncon = length(g);   % number of constraints
P = 0;              % intialize P value to zero
for j = 1:ncon
    P = P + max(0,g(j))^2;  % note: no c_j scaling parameters
end
phi = f + r_p * P;
