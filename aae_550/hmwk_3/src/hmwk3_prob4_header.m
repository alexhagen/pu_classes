% Alpha from the problem statement
L_1 = 3*0.3048;                % length of element 1 [m]
L_2 = 3*0.3048;                % length of element 2 [m]
L_3 = 3.625*0.3048;            % length of element 3 [m]
% Bounds from the problem statement
lb = 0.0001;
ub = 0.1;
% Penalty Multiplier
rp = [1, 1, 1]*1e9;