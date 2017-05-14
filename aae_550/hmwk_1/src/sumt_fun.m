function f = sumt_fun(x)

    [rho, ~, L, ~, ~, ~, ~] = constants();

    R = x(1);
    t = x(2);
    f = rho * pi * t * (2 * R - t) * L;
    
end