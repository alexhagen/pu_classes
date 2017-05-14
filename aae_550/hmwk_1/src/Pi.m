function [f, nabla, H] = Pi(u)
    E = 16E6; % psi
    A_1 = 1.75; % inches
    L_1 = sqrt((3*12)^2 + (4*12)^2); % inches
    theta_1 = -36.87;
    K_1 = [cos(theta_1); sin(theta_1)] * E * A_1 * ...
          [cos(theta_1) sin(theta_1)] / L_1;
    A_2 = 1.05; % inches
    L_2 = 3*12; % inches
    theta_2 = -90;
    K_2 = [cos(theta_2); sin(theta_2)] * E * A_2 * ...
          [cos(theta_2) sin(theta_2)] / L_2;
    A_3 = 1.20; % inches
    L_3 = sqrt((3*12)^2 + (2*12)^2); % inches
    theta_3 = -56.31;
    K_3 = [cos(theta_3); sin(theta_3)] * E * A_3 * ...
          [cos(theta_3) sin(theta_3)] / L_3;

    K = K_1 + K_2 + K_3;

    p = [15000 * cos(-45); 15000 * sin(-45)];

    f = u' * K * u - p' * u;
    
    nabla = [u(1) * K(1, 1) + (u(2)/2) * (K(1, 2) + K(2, 1)) - p(1);
             (u(1)/2) * (K(1, 2) + K(2, 1)) + u(2) * K(2, 2) - p(2)];
    
    H = [K(1, 1) (K(1, 2) + K(2, 1))/2;
         (K(1, 2) + K(2, 1))/2 K(2, 2)];
end