function A = sumt_phi_alm(x,r_p,lambda)

% compute values of the objective function and constraints at the current
% value of x
f = sumt_fun(x);
g = sumt_con(x);
psi = zeros(size(g));

% Fletcher's substitution
for j = 1:length(g)
    psi(j) = max(g(j), -lambda(j) / (2 * r_p));
end
%psi(1) = max(g(1), -lambda(1) / (2 * r_p));
%psi(2) = max(g(2), -lambda(2) / (2 * r_p));

% Augmented Lagrangian function
A = f + sum(lambda .* psi) + sum(r_p * psi.^2);