function phi = NMfunc(x)
% objective function: egg-crate function homework assignment
% linear exterior penalty to enforce bounds
hmwk3_header
f = 0.0;
for i = 1:d
    f = f + (-x(i) * sin(sqrt(abs(x(i)))));
end
f = f + a * d;
g = zeros(1, 2*d);
for i = 1:d
    g(2*i-1) = x(i) / (lb) - 1;  % enforces lower bound
    g(2*i) = x(i) / (ub) - 1; % enforces upper bound
end
P = 0.0;    % initialize penalty function
for i = 1:2*d
    P = P + rp * max(0,g(i));
end
phi = f + P;