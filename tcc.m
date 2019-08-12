%% PROPELLER PERFORMANCE AND DESIGN FOR A COMMUTER AIRCRAF
% Bernardo Martinez Rocamora Junior

% Final project to be submited as a partial exigency for obtainement of 
% the Aeronautical Engineer degree at the Engineering School of Sao Carlos 
% (EESC) of the University of Sao Paulo


% Advisor Professor: Prof. Dr. Hernan Dario Ceron-Munoz

%% Aircraft Input Parameters
% The following inputs are taken from the report "Aviao Commuter para a 
% regiao Sul do Brasil: HARPIA" from the  Aircraft Design I module of the
% Aeronautical Engineering course.

clear all, close all, clc;

inputs.N=2000;                        % [rpm]         Rotational speed
inputs.n=inputs.N/60;                 % [rps]         Rotational speed
inputs.D=2;                           % [m]           Propeller diameter
inputs.P_hp=750;                      % [hp]          Engine power
inputs.P=inputs.P_hp*745.7;           % [W]           Engine power
inputs.V=80;                          % [m/s]         Forward speed
inputs.rho=1.225;                     % [kg/m3]       Air density
inputs.mu=1.72*10^-5;                 % []            Air viscosity
inputs.hub=0.3;                       % [adim]        r_hub/R
inputs.a=340;                         % [m/s]         Sound speed

%% Parametric Study
% This section aims to choose two of the most important parameters in the
% procedure of propeller design: the diameter and the number of blades. It
% will also define the hub proportion of the propeller.

% [B,D,h]=parametric(n,P,V,rho);

% N=1800:200:2200                       % [rpm]         Rotational speed
% n=N/60                                % [rps]         Rotational speed
% B=[1:4,6:2:12];                       % [units]       Number of blades
% D=1.8:0.2:2.2;                        % [m]           Chosen prop diameter
% h=0.2;                                % [m/m]         Hub diameter ratio

% % for i=1:length(n)
%     for j=1:length(B) 
% %         for k=1:length(D)
%             D_2(j)=D*(1/B(j))^0.25; % Same loading as B=1;
%             method='prandtl';
%             [eff(j),ind_eff(j),J_design(j)]=prop_design(n,P,V,B(j),rho,D_2(j),method);
% %         end
%     end
% % end

%% Design Condition
% This section aims to design a optimum propeller at cruise condition, it
% will produce a blade geometry and 

inputs.B=6;

% Control points data (choose profile and position);
control.span_elem=100;
control.pos=[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95 1];
control.station=round(control.pos*control.span_elem)+1;
% control.profiles={'eppler862','eppler862','eppler862','clarky','clarky',...
%    'eppler854','eppler853','eppler852','eppler851','eppler850','mhetip','mh120'};
control.profiles={'eppler862','eppler862','mh126','eppler857','eppler856',...
    'eppler855','eppler854','eppler853','eppler852','eppler851','mhetip','mh120'};

% Single Point Design
 method='prandtl';
 [p_design]=prop_design(inputs,method,control);

% 
% plot_blade_3d(control,p_design)
% plot_blade_chord(inputs,p_design,control)
% plot_design_parameter(inputs, control, p_design)

%% Off-Design Condition
% This section aims to calculate the performance of the propeller designed
% in the previous section at other flight and engine-power conditions
% 
% V_p=10:5:150;                         % [m/s]     Forward speed
% delta_beta=-10:2:10;
% J=V_p/(inputs.n*inputs.D);
% delta_beta=[-15 -10 -5 -0  5 10 15];
% 
% 
% for j=1:length(delta_beta)
%     beta_design_dB=p_design.beta+delta_beta(j);
%     
%     for i=1:length(V_p)
%         disp(['Analyzing performance for blade angle of ',...
%             num2str(delta_beta(j)),' degrees and forward velocity of V=',...
%             num2str(V_p(i)),'m/s.']);
%         [performance]=...
%              prop_analysis(inputs,p_design,V_p(i),beta_design_dB,control);
%          p_performance.c_T_ind(i,j)=performance.c_T_ind;
%          p_performance.c_P_ind(i,j)=performance.c_P_ind;
%          p_performance.eff_ind(i,j)=performance.eff_ind;
%          p_performance.c_T(i,j)=performance.c_T;
%          p_performance.c_P(i,j)=performance.c_P;
%          p_performance.eff(i,j)=performance.eff;
%     end
% end
% 
% plot_prop_performance(J,delta_beta,p_performance)
% 
