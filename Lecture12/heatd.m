function [A,B,C,D,K,x0] = heatd(kappa,htf,T,Ngrid,L,temp)
% ODE file parameterizing the heat diffusion model

% kappa (first parameter) - heat diffusion coefficient
% htf (second parameter) - heat transfer coefficient 
%                          at the end of rod

% Auxiliary variables for computing state-space matrices:
% Ngrid: Number of points in the space-discretization
% L: Length of the rod
% temp: Initial room temperature (uniform)

% Compute space interval
deltaL = L/Ngrid;

% A matrix
A = zeros(Ngrid,Ngrid);
for kk = 2:Ngrid-1
  A(kk,kk-1) = 1;
  A(kk,kk) = -2;
  A(kk,kk+1) = 1;
end

% Boundary condition on insulated end
% Change -1 to -2 below to insted get dissipation on non-insulated end
A(1,1) = -1; 
A(1,2) = 1;
A(Ngrid,Ngrid-1) = 1;
A(Ngrid,Ngrid) = -1;

A = A*kappa/deltaL/deltaL;

% B matrix
B = zeros(Ngrid,1);
B(1,1) = htf/deltaL;

% C matrix
C = zeros(1,Ngrid);
C(1,round(Ngrid/2)) = 1;

% D matrix (fixed to zero)
D = 0;

% K matrix: fixed to zero
K = zeros(Ngrid,1);

% Initial states: fixed to room temperature
x0 = temp*ones(Ngrid,1);