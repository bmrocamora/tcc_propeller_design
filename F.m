function f=F(w_adim,phi)
% F calculates part of the circulation function
%
%% Organization:
% Inputs:
%   w_adim      [adim]      Induced velocity ratio
%   phi         [rad]       True wind angle
%
% Outputs:
%   f           [adim]      Loading factor
%
%% Code:

% f calculation
f=(1+w_adim)*(sin(phi))^2/...
    ((1+0.5*w_adim)*(1+0.5*w_adim*(cos(phi))^2)*cos(phi));

end