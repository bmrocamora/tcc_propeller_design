function [p_design]=prop_design(inputs,method,control)
% PROPELLER DESIGN Single point condition design
% Calculates optimum efficiency and blade planform for a single point
% design chosen
%
%% Organization:
% Inputs:
%   inputs.                 [struct]
%       n                   [rps]       Rotational velocity
%       P                   [W]         Engine power
%       V                   [m/s]       Axial velocity
%       B                   [units]     Number of blades
%       rho                 [kg/m^3]    Air density
%       D                   [m]         Design diameter
%
%   method                  [string]    Circulation distribution method
%   control.
%       span_elem           [num]       Blade discretization
%       pos                 [array]     Control positions
%       station             [array]     Control station (array position)
%       profiles            [string]    Profiles for control each position
%
% Outputs:
%   p_design.               [struct]
%       eff                 [adim]      Total efficiency (induced and profile losses)
%       eff_ind             [adim]      Induced efficiency (induced losses only)
%       J_0                 [adim]      Geometric advance ratio
%       J                   [adim]      Design advance ratio
%       J_wake              [adim]      Wake advance ratio
%       w_adim              [adim]      Wake displacement velocity
%       c_T                 [adim]      Design thrust coefficient 
%       c_P                 [adim]      Design power coefficient
%       c_T_ind             [adim]      Induced thrust coefficient 
%       c_P_ind             [adim]      Induced power coefficient 
%       sigma               [adim]      Design solidity distribution 
%       chord               [adim]      Design chord distribution
%       cL                  [adim]      Design lift coefficient distribution 
%       cD                  [adim]      Design drag coefficient distribution
%       alpha               [adim]      Design angle of attack distribution 
%       beta                [adim]      Design blade angle distribution 
%
%% Code:

% Defining global variables
global n, n=inputs.n;
global V, V=inputs.V;
global B, B=inputs.B;
global P, P=inputs.P;
global rho, rho=inputs.rho;
global mu, mu=inputs.mu;
global a, a=inputs.a;
global D, D=inputs.D;
global hub, hub=inputs.hub;
global R, R=D/2;

% Geometric advance ratio
p_design.J_0=V/(n*D);

%% Power coefficient matching and wake induced velocity

% Range of induced velocities and its parameters
w_adim=[0:0.01:0.9];
% Wake advace ratio
J_wake=p_design.J_0*(1+w_adim);
% Mass coefficient
k=J2k(J_wake);
%  Axial loss factor
for i=1:length(k)
eps_k(i)=kJ2epsk(k(i),J_wake(i));
end
% Power coefficient
c_P=(2*k'.*w_adim.*(w_adim+1)).*(eps_k.*w_adim+1);


% Design total power coefficient
c_P_total_design=P/(0.5*rho*V^3*pi*R^2);
% Interpolation to find w_adim that matches total power coefficient
p_design.w_adim=interp1(c_P,w_adim,c_P_total_design);

% Design advance ratios
p_design.J=p_design.J_0*(1+0.5*p_design.w_adim);
p_design.J_wake=p_design.J_0*(1+p_design.w_adim);
% Design mass coefficient and axial loss factor
k_design=J2k(p_design.J_wake);
eps_k_design=kJ2epsk(k_design,p_design.J_wake);
% Design power coefficient check
c_P_design=(2*k_design*p_design.w_adim*(p_design.w_adim+1))*(eps_k_design*p_design.w_adim+1);

%% Rotor optimum blade loading

% Defining blade discretization
global x;
r=[0:R/control.span_elem:R];        %       [m]       Radial coordinates
x=r/R;                              %       [adim]    Radial coordinates
dx=1/control.span_elem;   

% True wind angle, circulation and sigma-cL product distribution
global W;
for i=1:length(x)
    phi(i)      =   atan(1/pi*p_design.J_0*(1+0.5*p_design.w_adim)/x(i));
    phi_deg(i)  =   phi(i)*180/pi;
    switch method
        case 'goldstein'
            K(i)        =   goldstein_circ(x(i),p_design.J_wake);
        case 'prandtl'
            K(i)        =   prandtl_circ(x(i),p_design.J);
    end
    W(i)=V*(1+0.5*p_design.w_adim*cos(phi(i))^2)/sin(phi(i));
    sigma_cL(i)=2*p_design.w_adim*K(i)*F(p_design.w_adim,phi(i));
end

figure
plot(x,W);
xlabel('x=r/R');
ylabel('True Wind Speed Distribution');

figure
plot(x,sigma_cL);
xlabel('x=r/R');
ylabel('\sigma*c_L Distribution');

%% Blade design

% Blade design function
[sigma,chord,cL,cD,alpha,beta,Re,M]=blade_design(phi_deg,sigma_cL,control);

% Defining outputs
p_design.sigma=sigma;
p_design.chord=chord;
p_design.cL=cL;
p_design.cD=cD;
p_design.alpha=alpha;
p_design.beta=beta;
p_design.Re=Re;
p_design.M=M;

%% Efficiency Calcultions by Borst

% Hub position
pos.hub=round(hub*control.span_elem);

% Calculation of Induced Efficiency (gamma=0)
c_T_ind=0;
c_Q_ind=0;
for i=pos.hub:length(x)
    gamma=0;
    Z=(pi*x(i)^2*p_design.J_0^2/8)*((1+p_design.w_adim*(cos(phi(i)))^2)/sin(phi(i)))...
        ^2*sin(phi(i));
    c_T_ind=c_T_ind+sigma(i)*cL(i)*2*Z*(cot(phi(i))-tan(gamma))/x(i)*dx;
    c_Q_ind=c_Q_ind+sigma(i)*cL(i)*Z*(1+tan(gamma)/tan(phi(i)))*dx;
end
p_design.c_P_ind=2*pi*c_Q_ind;
p_design.c_T_ind=c_T_ind;
% Induced Efficiency
p_design.eff_ind=p_design.J_0*p_design.c_T_ind/p_design.c_P_ind;

% Calculation of Total Efficiency (with profile losses)
c_T=0;
c_Q=0;
for i=pos.hub:length(x)
    gamma=atan(cD(i)/cL(i));
    Z=(pi*x(i)^2*p_design.J_0^2/8)*((1+p_design.w_adim*(cos(phi(i)))^2)/sin(phi(i)))...
        ^2*sin(phi(i));
    c_T=c_T+sigma(i)*cL(i)*2*Z*(cot(phi(i))-tan(gamma))/x(i)*dx;
    c_Q=c_Q+sigma(i)*cL(i)*Z*(1+tan(gamma)/tan(phi(i)))*dx;
end
c_P=2*pi*c_Q;
p_design.c_T=c_T; p_design.c_P=c_P;
% Total efficiency
p_design.eff=p_design.J_0*c_T/c_P;

%% Efficiency Calculations by Crigler

% % Induced thrust coefficient 
% c_g_design=2*k_design*w_adim_design*(1+w_adim_design*(0.5+eps_k_design));
% 
% % Power-mass coeff ratio
% P_k_ratio=P_c_design/k_design;
% 
% % Induced efficiency
% eff_ind=c_g_design/P_c_design;
% 
% % Drag Effect on efficiency
% t_r=0;
% t_a=0;
% for i=1:length(x)
%     t_r=t_r+sigma(i)*cD(i)/sin(phi(i))*x(i)^3*dx;
%     t_a=t_a+sigma(i)*cD(i)/sin(phi(i))*x(i)*dx;
% end
% t_a=t_a*2;
% t_r=t_r*2/(J_0/pi);
%     
% % Net thrust coefficient
% c_g_T=c_g_design-t_a;
% 
% % Power coefficient
% P_c_T=P_c_design+t_r;
% 
% % Efficiency
% eff=c_g_T/P_c_T;

end