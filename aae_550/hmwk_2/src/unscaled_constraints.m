clear; clc;
% use a script to call all the variables called out by the problem
% statement
parameters

% iterate through all of the constraints and print their values, so that we
% can add a scaling factor for them to get them on the order of 1
for b=[0.05, 5.0]
    for h=[0.05, 5.0]
        g(1) = 0.05 - b;
        g(2) = b - 5.0;
        g(3) = 0.05 - h;
        g(4) = h - 5.0;
        g(5) = 1E-2 * (1 - (4*D_a*E*b*h^3)/(L^3 * (P+(5/8)*q*L)));
        g(6) = 1E-2 * (1 - (4*sigma_a*b*h^2)/(3*L*(2*P+L*q)));
        g(7) = 1E-9 * ...
            (P + q*L - 4.013*sqrt(0.312*h^4*b^4*G*E)/(L^2*sqrt(12)));
        g(8) = 1E-9 * ...
            (P + q*L - 4.013*sqrt(0.312*h^2*b^6*G*E)/(L^2*sqrt(12)));
        g(9) = h - 8*b;
        b
        h
        g
    end
end