function [performance]=prop_analysis(inputs,p_design,V_off,beta,control)
%   PROPELLER ANALYSIS Gives thrust coefficiency, power coefficiency and 
%   efficiency for a given propeller design
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
%   p_design.               [struct]
%       sigma               [adim]      Design solidity distribution 
%       chord               [adim]      Design chord distribution
%       cL                  [adim]      Design lift coefficient distribution 
%       cD                  [adim]      Design drag coefficient distribution
%       alpha               [adim]      Design angle of attack distribution 
%   V_off                   [m/s]       Off-Design Velocity
%   beta                    [m/s]       Off-Design Pitch Distribution
% Outputs:
%   performance.
%       c_T                 [adim]      Thrust coefficient
%       c_T_ind             [adim]      Thrust coefficient
%       c_P                 [adim]      Thrust coefficient
%       c_P_ind             [adim]      Induced Power coefficient
%       eff                 [adim]      Efficiency
%       eff_ind             [adim]      Induced Efficiency
%% Code:

global n, n=inputs.n;
global V, V=inputs.V;
global B, B=inputs.B;
global P, P=inputs.P;
global rho, rho=inputs.rho;
global mu, mu=inputs.mu;
global D, D=inputs.D;
global a, a=inputs.a;
global hub, hub=inputs.hub;
global R, R=D/2;

r=0:R/control.span_elem:R;    % [m]           Radial coordinates


global x, 
x=r/R;                  % [adim]        Radial coordinates
dx=1/control.span_elem;

hub_pos=round(hub*control.span_elem);

global V_0
V_0=inputs.V;

global J
J=V_off/(n*D);

global J_0
J_0=V_0/(n*D);

global V_ratio
V_ratio=V_off/V_0;

% Method of Analysis: with or without forward speed

if V_off == 0

    % TO BE CODED...
    
else
    %% Performance Analysis: Flight Condition (V>0)
    % Aerodynamics calculations
    for i=1:length(control.pos)
        x(control.station(i));
        M_a=V_0/a;
        phi_0=atan(J/(pi*x(control.station(i))));
        M(i)=M_a*csc(phi_0)*V_ratio;
        p_design.chord(control.station(i));
        Re(i)=a*M(i)*p_design.chord(control.station(i))*(rho/mu)+100000;
        p_design.sigma(control.station(i));
        beta(control.station(i));
        [cL_control(i),cD_control(i),alpha_control(i),phi_control(i),w_adim_control(i)]=...
            off_design_V(x(control.station(i)),p_design.sigma(control.station(i)),...
            beta(control.station(i)),control.profiles{i},Re(i),M(i));  
    end
    
    % Interpolation for other stations
    cL=interpn(control.pos,cL_control,x,'linear');
    cD=interpn(control.pos,cD_control,x,'linear');
    alpha=interpn(control.pos,alpha_control,x,'linear');
    w_adim=interpn(control.pos,w_adim_control,x,'linear');
    RE=interpn(control.pos,Re,x,'linear');
    MACH=interpn(control.pos,M,x,'linear');
    phi=interpn(control.pos,phi_control,x,'linear');
    phi_deg=phi*180/pi;
    
%     Check plots
%
%     figure
%     subplot(1,3,1)
%     plotyy(x,cL,x,cD,'plot','plot');
%     legend('c_L','c_D');
%     ylabel('Lift and Drag Coefficients');
%     xlabel('x=r/R');
%     
%     subplot(1,3,2)
%     plot(x,alpha,x,phi_deg/10);
%     ylabel('Angle of attack and True Wind Angle [deg]');
%     xlabel('x=r/R');
%     legend('\alpha','\phi/10');
%     
%     subplot(1,3,3)
%     plot(x,w_adim);
%     ylabel('w_{adim}');
%     xlabel('x=r/R');  
% 
if V_off == V_0
    subplot(1,2,1);
    plotyy(x,RE,x,MACH,'plot','plot');
    legend('Reynolds','Mach');
    ylabel('Reynolds and Mach Numbers');
    xlabel('x=r/R');    
    subplot(1,2,2);
    plot(x,w_adim);
    ylabel('w_{adim}');
    xlabel('x=r/R');  
end
    
    % Efficiency Calculations by Borst
    % Induced Efficiency
    c_T_ind=0;
    c_Q_ind=0;
    for i=hub_pos:length(x)-5
        gamma=0;
        Z=(pi*x(i)^2*J^2/8)*((1+w_adim(i)*(cos(phi(i)))^2)/sin(phi(i)))...
            ^2*sin(phi(i));
        c_T_ind=c_T_ind+p_design.sigma(i)*cL(i)*2*Z*(cot(phi(i))-tan(gamma))/x(i)*dx;
        c_Q_ind=c_Q_ind+p_design.sigma(i)*cL(i)*Z*(1+tan(gamma)/tan(phi(i)))*dx;
    end
    c_P_ind=2*pi*c_Q_ind;
    performance.c_T_ind=c_T_ind;
    performance.c_P_ind=c_P_ind;
    performance.eff_ind=J*c_T_ind/c_P_ind;

    % Efficiency
    c_T=0;
    c_Q=0;
    for i=hub_pos:length(x)-5
        gamma=atan(cD(i)/cL(i));
        Z=(pi*x(i)^2*J^2/8)*((1+w_adim(i)*(cos(phi(i)))^2)/sin(phi(i)))...
            ^2*sin(phi(i));
        c_T=c_T+p_design.sigma(i)*cL(i)*2*Z*(cot(phi(i))-tan(gamma))/x(i)*dx;
        c_Q= c_Q+p_design.sigma(i)*cL(i)*Z*(1+tan(gamma)/tan(phi(i)))*dx;
    end
    c_P=2*pi*c_Q;
    c_T; c_P;
    performance.c_T=c_T;
    performance.c_P=c_P;
    performance.eff=J*c_T/c_P;
end


end

