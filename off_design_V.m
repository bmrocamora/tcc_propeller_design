function [cL,cD,alpha,phi,w_adim]=off_design_V(x,sigma,beta,profile,Re,M)
% OFF-DESIGN AERODYNAMICS Finds induced velocity and aerodynamic coefficients
% for a given off-design condition
%
%% Organization:
% Inputs:
%   x                   [adim]      Radial coordinate (x=r/R)
%   sigma               [adim]      Solidity
%   beta                [deg]       Blade angle
%   profile             [string]    Airfoil section
%   Re                  [adim]      Reynolds number
%   M                   [adim]      Mach number
%
% Outputs:
%   cL                  [adim]      Lift coefficient
%   cD                  [adim]      Drag coefficient
%   alpha               [deg]       Angle of attack
%   phi                 [rad]       True wind angle
%   w_adim              [adim]      Induced velocity ratio
%
%% Code:
% Initial Setup

global J

% Iteration parameters
max_error=0.01;

% Guessing station induced velocity
w_adim_guess=[0.001:0.001:0.01, 0.02:0.01:0.1, 0.12:0.02:1, 1:0.1:3];

for i=1:length(w_adim_guess)    
    % True wind angle
    w_adim_guess(i);
    phi_guess(i)=atan(J*(1+w_adim_guess(i))/(pi*x));
    phi_guess_deg(i)=phi_guess(i)*180/pi;
    % Advance ratio on the wake
    J_wake=J*(1+w_adim_guess(i));
    % Circulation
    K(i)=prandtl_circ(x,J);
    % Aerodynamic loading
    f=F(w_adim_guess(i),phi_guess(i));
    sigma_cL_guess(i)=2*w_adim_guess(i)*f*K(i);
    % Guessed lift coefficient and angle of attack
    cL_guess(i)=sigma_cL_guess(i)/sigma;
    alpha_guess(i)=beta-phi_guess_deg(i);
    % Check coefficients at guessed angle of attack
   [cL_d,cD_d]=check_aero(profile,Re,M,alpha_guess(i));
    cL_xfoil(i)=cL_d;
    cD_xfoil(i)=cD_d;
    error(i)=abs((cL_xfoil(i)-cL_guess(i))/cL_xfoil(i));
end
% figure
% subplot(2,3,1)
% plot(w_adim_guess,phi_guess_deg);
% ylabel('\phi [deg]');
% xlabel(['w_{adim} at x=',num2str(x)]);
% 
% subplot(2,3,2)
% plot(w_adim_guess,sigma_cL_guess);
% ylabel('\sigma*c_L');
% xlabel(['w_{adim} at x=', num2str(x)]);
% 
% subplot(2,3,3)
% plot(w_adim_guess,K);
% ylabel('K');
% xlabel(['w_{adim} at x=', num2str(x)]);
% 
% subplot(2,3,4)
% plot(w_adim_guess,error);
% ylabel('error');
% xlabel(['w_{adim} at x=', num2str(x)]);
% 
% subplot(2,3,5)
% plot(w_adim_guess,cL_guess,w_adim_guess,cL_xfoil);
% ylabel('c_L');
% xlabel(['w_{adim} at x=', num2str(x)]);
% legend('Guessed c_L', 'XFoil c_L');
% 
% subplot(2,3,6)
% plot(w_adim_guess,alpha_guess);
% ylabel('\alpha');
% xlabel(['w_{adim} at x=', num2str(x)]);

[min_error,I]=min(error);
% Outputs values
cL=cL_xfoil(I);
cD=cD_xfoil(I);
alpha=alpha_guess(I);
phi=phi_guess(I);
w_adim=w_adim_guess(I);

end
