function sigma = stressHW3(A, E)
% This function assembles the stiffness matrix and computes the stress in
% each element of the three-bar truss in AAE 550, HW 3, part IV, Fall 2014.
%
% The function returns a three-element vector "sigma"; each element is the computed
% stress in each truss element.  The input is the three-element vector "A";
% each element is the cross-sectional area of each truss element.  Values
% for Young's modulus are input as parameters

% fixed values
P = 15000*4.4482;               % applied load [N]
L(1) = 3*0.3048;                % length of element 1 [m]
L(2) = 3*0.3048;                % length of element 2 [m]
L(3) = 3.625*0.3048;            % length of element 3 [m]
phi = asind(1.375/3);

% local stiffness matrices
K1 = [cosd(-phi) sind(-phi)]'*(E(1)*A(1)/L(1))*[cosd(-phi) sind(-phi)];
K2 = [cosd(phi) sind(phi)]'*(E(2)*A(2)/L(2))*[cosd(phi) sind(phi)];
K3 = [0 sind(90)]'*(E(3)*A(3)/L(3))*[0 sind(90)];

% global (total) stiffness matrix:
K = K1 + K2 + K3;

% load vector (note lower case to distinguish from P)
p = P*[cosd(45) sind(45)]';

% compute displacements (u(1) = x-displacement on figure; u(2) =
% y-displacement on figure)
u = K \ p; 

% change in element length under load
DL(1) = sqrt((L(1)*cosd(phi)+u(1))^2 + (L(1)*sind(phi)-u(2))^2) - L(1);
DL(2) = sqrt((L(2)*cosd(phi)+u(1))^2 + (L(2)*sind(phi)+u(2))^2) - L(2);
DL(3) = u(2);

% stress in each element
sigma = E .* DL ./ L;
