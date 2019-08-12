function eps_k=kJ2epsk(k,J)
% kJ2epsk Calculates eps/k for a given advance ratio J and mass coefficient
%
%% Organization:
% Inputs:
%   eps_k       [adim]      Axial loss factor to mass coefficient ratio
%
% Outputs:
%   k           [adim]      Mass coefficient
%   J           [adim]      Advance ratio
%
%% Code:
% Loading graph data
kvsJ_data=csvread('kvsJ.csv',1,0);
J_kvsJ_data=kvsJ_data(:,2);
k_kvsJ_data=kvsJ_data(:,3);

% Using rational fit to create interpolated function
[kvsJ] = rationalfit(J_kvsJ_data,k_kvsJ_data);

% Differenciating previous function
dk_dJ=differentiate(kvsJ,[0:0.1:5]);
dk_dlamb=dk_dJ*pi;
lamb=[0:0.1:5]/pi;

% Calculating eps/k
eps_k=1+0.5*J/(pi*k)*interp1(lamb,dk_dlamb,J/pi);

end