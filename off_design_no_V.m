function [cL,cD,alpha,phi,w]=off_design_no_V[x,n,D,B,sigma,beta,Ms,Re,profile]
% STATIC OFF-DESIGN AERODYNAMICS 
% 
%
%% Organization:
% Inputs:
%   x         [adim]    Radial coordinate (x=r/R)
%   n         [rps]     Rotational velocity
%   D         [m]       Diameter
%   B         [units]   Number of blades
%   sigma     [adim]    Solidity
%   beta      [deg]     Blade angle
%
% Outputs:
%   cL        [adim]    Lift coefficient
%   cD        [adim]    Drag coefficient
%   alpha     [deg]     Angle of attack
%   phi       [rad]     True wind angle
%   w_adim    [adim]    Induced velocity ratio
%
%% analysis:
%     %% Performance Analysis: Figure of Merit for Static Thrust (V=0)
%     for i=1:length(control_pos)
%         x(control_station(i));
%         M_s=pi*n*D/a;
%         chord(control_station(i));
%         Re=chord(control_station(i))*pi*n*D*x*(rho/mu);
%         beta(control_station(i));
%         sigma(control_station(i));
%         [cL_control(i),cD_control(i),alpha_control(i),phi_control(i),w_control(i)]=...
%             off_design_no_V(x(control_station(i)),n,D,B,sigma(control_station(i)),beta(control_station(i)),Re,Ms,control_profiles{i});
%     end   
% 
%     % Interpolation for other stations
%     cL=interpn(control_pos,control_cL,0:1/span_elem:1,'linear');
%     cD=interpn(control_pos,control_cD,0:1/span_elem:1,'linear');
%     alpha=interpn(control_pos,control_alpha,0:1/span_elem:1,'linear');
%     
%     % Efficiency Calculations by Borst
%     % Induced Efficiency
%     c_T_ind=0;
%     c_Q_ind=0;
%     for i=5:length(x)
%         gamma=0;
%         Z=(pi*x(i)^2*J_0^2/8)*((1+w_adim_design*(cos(phi(i)))^2)/sin(phi(i)))...
%             ^2*sin(phi(i));
%         c_T_ind=c_T_ind+sigma(i)*cL(i)*2*Z*(cot(phi(i))-tan(gamma))/x(i)*dx;
%         c_Q_ind=c_Q_ind+sigma(i)*cL(i)*Z*(1+tan(gamma)/tan(phi(i)))*dx;
%     end
%     c_P_ind=2*pi*c_Q_ind;
%     c_T_ind; c_P_ind;
% 
%     % Efficiency
%     c_T=0;
%     c_Q=0;
%     for i=5:length(x)
%         gamma=atan(cD(i)/cL(i));
%         Z=(pi*x(i)^2*J_0^2/8)*((1+w_adim_design*(cos(phi(i)))^2)/sin(phi(i)))...
%             ^2*sin(phi(i));
%         c_T=c_T+sigma(i)*cL(i)*2*Z*(cot(phi(i))-tan(gamma))/x(i)*dx;
%         c_Q= c_Q+sigma(i)*cL(i)*Z*(1+tan(gamma)/tan(phi(i)))*dx;
%     end
%     c_P=2*pi*c_Q;
%     c_T; c_P;
%     
%     k_c
%     
%     FM=0.565*(c_T)^(3/2)/(c_P*k_c);
%     eff=FM;
%% Code
% Initial Setup
x;

% Iteration parameters
max_error=0.01;

phi_guess=pi/4;
error=1;

while error>max_error
    phi_guess_deg=phi_guess*180/pi;
    % Guessed advance ratio
    j=pi*x*tan(phi_guess);
    % Guessed induced velocity at wake
    w_guess=j*n*D;
    % Prandtl circulation
    K=prandtl_circ(x,j,B);
    % Guessed mass- and energy- coefficient 
    k=J2k(j);
    epsk=kJ2epsk(k,j);
    eps=epsk*k;
    % Guessed aerodynamic loading
    sigma_cL_guess=2*K*((eps+k/2)/eps)^2;
    % Guessed lift coefficient, true wind angle and angle of attack
    cL_guess=sigma_cL_guess/sigma;

    alpha_guess=beta-phi_guess_deg;
    % Check coefficients at guessed angle of attack   
    [cL,cD]=check_aero(profile,Re,Ms,alpha_guess);
    
    error=abs(cL-cL_guess)/cL;
    w=w_guess;
    alpha=alpha_guess;
    phi=phi_guess;
    
    % Iteration correction on induced velocity
    if cL<cL_guess
        if error<0.1
            phi_guess=phi*1.01;   %Might have to change * for /
        else
            phi_guess=phi*1.05;
        end
    else
        if error<0.1
            phi_guess=phi/1.01;
        else
            phi_guess=phi/1.05;
        end
    end    
    
end

% Outputs values
cL
cD
alpha
phi
w
end




%%
% % Guessing station induced velocity
% w_adim_guess=0.3;
% 
% error=1;
% while error>max_error
%     
%     % True wind angle
%     phi_guess=atan(J*(1+w_adim_guess)/(pi*x));
%     phi_guess_deg=phi_guess*180/pi;
%     % Advance ratio on the wake
%     J_wake=J_L*(1+w_adim_guess);
%     % Circulation
%     K=prandtl_circ(x,J_wake,B);
%     % Aerodynamic Loading
%     f=F(w_adim_guess,phi_guess);
%     sigma_cL_guess=2*w_adim_guess*f*K;
%     % Guessed lift coefficient and angle of attack
%     cL_guess=sigma_cL_guess/sigma;
%     alpha_guess=beta-phi_gess_deg;
% 
%     % Aerodynamic coefficients for guess angle of attack
%     % [cL,cD]=func(alpha_gess)   %%function from alpha to cL and cD
% 
%     
%     error=abs(cL-cL_guess)/cL;
%     w_adim=w_adim_guess;
%     alpha=alpha_guess;
%     phi=phi_guess;
%     
%     % Iteration correction on induced velocity
%     if cL<cL_guess
%         if error<0.1
%             w_adim_guess=w_adim*1.01;   %Might have to change * for /
%         else
%             w_adim_guess=w_adim*1.05;
%         end
%     else
%         if error<0.1
%             w_adim_guess=w_adim/1.01;
%         else
%             w_adim_guess=w_adim/1.05;
%         end
%     end
% end
