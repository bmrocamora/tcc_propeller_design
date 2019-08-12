function cP_crit=critical_cp(M)
% CRITICAL CP Calculates critical minimum pressure coefficient for
% determined Mach number
%
%% Organization:
% Inputs:
%   M           [adim]      Mach number
%
% Outputs:
%   cP_crit     [adim]      Mininum critical cP
%
%% Code:

% Heat capacity ratio 
gamma=1.4;

% Critical cP calculation
cP_crit=(2/(gamma*M^2))*(((2+(gamma-1)*M^2)/(gamma+1))^(gamma/(gamma-1))-1);

end