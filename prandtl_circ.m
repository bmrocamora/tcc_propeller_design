function K=prandtl_circ(x,J)
% PRANDTL CIRCULATION MODEL Calculates circulation with Prandtl model
% Calculates at a determined radius  x=r/R for a number of blades B and 
% advance ratio J=V/nD
%
%% Organization:
% Inputs:
% x         [adim]      Radial coordinate (x=r/R)
% J         [adim]      Advance ratio at the wake
% B         [units]     Number of blades
%
% Outputs:
% K         [adim]      Circulation factor
%
%% Code:

% Calling global variable
global B

% Geometric advance ratio
lamb=J/pi;

% Tip loss function
f=B/2*((lamb^2+1)^0.5/lamb)*(1-x);
F=2/pi*acos(exp(-f));

% Circulation
X=x/lamb;
K=F*X^2/(1+X^2);

end