%% AERODESIGN PROPELLER

clear all, close all, clc;

inputs.N=13000;                       % [rpm]         Rotational speed
inputs.n=inputs.N/60;                 % [rps]         Rotational speed
inputs.D=0.33;                        % [m]           Propeller diameter
inputs.P_hp=21.5;                     % [hp]          Engine power
inputs.P=inputs.P_hp*745.7;           % [W]           Engine power
inputs.V=1;                         % [m/s]         Forward speed
inputs.rho=1.225;                     % [kg/m3]       Air density
inputs.mu=1.72*10^-5;                 % []            Air viscosity
inputs.hub=0.05;                      % [adim]        r_hub/R
inputs.a=340;                         % [m/s]         Sound speed
inputs.B=1;

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
 
plot_blade_3d(control,p_design)
plot_blade_chord(inputs,p_design,control)
plot_design_parameter(inputs, control, p_design)
