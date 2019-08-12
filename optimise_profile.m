function [cL,cD,alpha,Re,M]=optimise_profile(x,W,sigma_cL,i,profile)
% OPTIMISE PROFILE Pick optimum profile and angle of attack for a determined
% blade station
%
%% Organization:
% Inputs:
%   i               []          control position
%   x               [adim]      section adimensional position
%   W               [m/s]       section true wind speed
%   sigma_cL        [adim]      section load coefficient
%   profile         [string]    section airfoil profile
%
% Outputs:
%   cL              [adim]      optimized section lift coefficient
%   cD              [adim]      optimized section drag coefficient
%   alpha           [deg]       optimized section angle of attack
%   Re              [adim]      optimized section Reynolds number
%   M               [deg]       optimized section Mach number
%
%% Code:

global D;
global B;
global rho;
global mu;
global a;
W
a
% Mach at section
M=W/a;

% Find critical cP for this Mach
Cp_Crit=critical_cp(M);

% Minimum chord value constraint
b_min=0.05;
cL_max=D*pi*sigma_cL*x/(b_min*B);

% Maximum chord value constraint
b_max=0.15;
cL_min=D*pi*sigma_cL*x/(b_max*B);

% Section Reynolds approximation
% (considering cL around 0.5 and 0.05m minimum chord)
cL_med=0.5;
b_Re=D*pi*sigma_cL*x/(B*cL_med);
b=max([b_Re, b_min]);
Re=W*b*(rho/mu)

% Showing control number and profile
disp(['Control station number ', num2str(i), ' optimisation.'])
disp(['Control profile ', profile , ' optimisation.'])

% Loading XFOIL data
[alpha_data,cL_data,cD_data,cM_data,cPmin_data]=load_xfoil(profile,Re,M);

% Manual or Auto Optimisation
prompt = 'Choose angle of attack (alpha) manually (1) or to maximize CL/CD automatically (2)?';
answer = input(prompt)

if answer==1
    
    % Max cL/cD calculation
    cLcD=cL_data./cD_data;
    [max_cLcD,I]=max(cLcD);      

    % Designer plots
    figure
    subplot(2,2,1)
    plot(alpha_data,cL_data,[-3 15],[cL_max cL_max],[-3 15],[cL_min cL_min]);
    xlabel('\alpha')
    ylabel('Lift Coefficient')
    legend('c_L','c_L_{max}','c_L_{min}')
    axis tight
    grid on
    
    subplot(2,2,2)
    plot(alpha_data,cD_data)
    xlabel('\alpha')
    ylabel('Drag Coefficient')
    axis tight
    grid on
    
    subplot(2,2,3)
    plot(alpha_data,cLcD,'r-',alpha_data(I),max_cLcD,'b*')
    xlabel('\alpha')
    ylabel('c_L/c_D')
    legend('c_L/c_D','(c_L/c_D)_{max}')
    axis tight
    grid on
    
    subplot(2,2,4)
    plot(alpha_data,cPmin_data,'r-',[-3 15],[Cp_Crit Cp_Crit],'b-')
    xlabel('\alpha')
    ylabel('Pressure Coefficient')
    legend('c_P_{min}','c_P_{crit}')
    axis tight
    grid on
    
    % Manual choice of angle of attack
    prompt2 = 'What is the chosen AoA (-3:0.5:15 degrees)?';
    manual_alpha = input(prompt2);
    I=find(abs(alpha_data-manual_alpha)<0.1);
    if numel(I) == 0
        prompt2 = 'No data for the previous AoA, choose another AoA.';
        manual_alpha = input(prompt2);
        I=find(abs(alpha_data-manual_alpha)<0.1);
    end
    close
    
else
    % Max cL/cD calculation
    cLcD=cL_data./cD_data;
    [max_cLcD,I]=max(cLcD);    
    M;
    Cp_Crit;
    cPmin_data(I);
    
    % cP minimum constraint
        if cPmin_data(I) < Cp_Crit
            [cP_min,I]=max(cPmin_data);
            pause(0.01);
            disp(['Critical Mach conditio at pos ',num2str(pos),', x=',num2str(x),'.']);
        end
end
    
    cL=cL_data(I);
    cD=cD_data(I);
    alpha=alpha_data(I);

end