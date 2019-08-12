function [cL,cD]=check_aero(profile,Re,M,alpha_guess)
%% CHECK AERO Interpolate profile aerodynamics from XFoil
% Uses data from XFOIL to find cL and cD for a given profile at defined Re,
% M and angle of attack
%
%% Organization:
% Inputs:
%   profile             [string]    Airfoil section
%   Re                  [adim]      Reynolds number
%   M                   [adim]      Mach number
%   alpha_guess         [deg]       Angle of attack to be checked
%
% Outputs:
%   cL                  [adim]      Lift coefficient for alpha_guess
%   cD                  [adim]      Drag coefficient for alpha_guess
%
%% Code
if M <= 0.55
    alpha_min=-5;
    alpha_max=+25;
    alpha_step=0.5;
elseif 0.55 < M <=0.65
    alpha_min=-5;
    alpha_max=10;
    alpha_step=0.5;
else
    alpha_min=-3;
    alpha_max=10;
    alpha_step=0.5;
end
    
alpha_range=...
    [num2str(alpha_min) ' ' num2str(alpha_max) ' ' num2str(alpha_step)];

[alpha_data,cL_data,cD_data,cM_data,cPmin_data]=...
    load_xfoil_alpha(profile,Re,M,alpha_min,alpha_range);

if alpha_min <= alpha_guess & alpha_guess <= alpha_max
    %Interpolation
    cL=interp1(alpha_data,cL_data,alpha_guess,'pchip');
    cD=interp1(alpha_data,cD_data,alpha_guess,'pchip');
else
    %Extrapolation 
    cL=interp1(alpha_data,cL_data,alpha_guess,'nearest','extrap');
    if cL>2
        cL=2;
    elseif cL<-1
        cL=-1;
    end
    cD=interp1(alpha_data,cD_data,alpha_guess,'spline');
    if cD>1.5
        cD=1.5;
    elseif cD<0.1
        cD=0.1;
    end     
end
end