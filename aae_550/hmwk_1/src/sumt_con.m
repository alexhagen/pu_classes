function g = sumt_con(x)

    [rho, E, L, g, sigma_a, Delta, P] = constants();

    % First, convert the input vector into the names we know the variables
    % by
    R = x(1);
    t = x(2);
    
    % Then, define the constraints as described
    g(1) = (P/(pi*t*(2*R - t))) - sigma_a;
    g(2) = (5*rho*g*(L^4)*(2*R-t)/(384*E*R^3)) - Delta;
    g(3) = 0.03 - R;
    g(4) = R - 0.30;
    g(5) = 0.002 - t;
    g(6) = t - 0.02;
    g(7) = R/t - 15;
    g(8) = t - R;

    % Finally, we can scale all of these constants to be
    % same order of magnitude
    c = [1E-7, 1E3, 10, 10, 100, 100, 1E-2, 10];

    g = g.*c;
    
end