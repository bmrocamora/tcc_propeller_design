function k=J2k(J)
% J2k Calculates mass coefficient k for a given advance ratio J
%
%% Organization:
% Inputs:
%   J       [adim]      Advance ratio
%
% Outputs:
%   k       [adim]      Mass coefficient
%
%% Code:
% Loading graph data
kvsJ_data=csvread('kvsJ.csv',1,0);
J_kvsJ_data=kvsJ_data(:,2);
k_kvsJ_data=kvsJ_data(:,3);

% Using rational fit to create interpolated function
[kvsJ] = rationalfit(J_kvsJ_data,k_kvsJ_data);

% Calculating k
k=kvsJ(J);

end

