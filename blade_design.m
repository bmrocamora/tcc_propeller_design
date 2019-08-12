function [sigma,chord,cL,cD,alpha,beta,Re,M]=blade_design(phi_deg,sigma_cL,control)
% BLADE STATION PARAMETERS Calculates aerodynamic and planform data along 
% the blade
%
%% Organization:
%   Inputs:
%       phi_deg     [deg]       true wind angle at each blade station
%       sigma_cL    [adim]      solidity-cL product at each blade station
%       control.    [struct]    
%
%   Outputs:
%       sigma       [adim]      solidity at each station
%       chord       [adim]      chord-to-Radius ratio at each station 
%       cL          [adim]      lift coefficient at each station
%       cD          [adim]      drag coefficient at each station
%       alpha       [deg]       angle of attack at each station
%       beta        [deg]       blade angle at each station
%       Re          [adim]      Reynolds number at each station
%       M           [adim]      Mach number at each station
%
%% Code:
% Profile optimization for control stations

% Loading global variables
global x;
global R;
global B;
global W;


for i=1:length(control.pos)
    [control.cL(i),control.cD(i),control.alpha(i),control.Re(i),control.M(i)]=...
        optimise_profile(x(control.station(i)),W(control.station(i)),...
        sigma_cL(control.station(i)),i,control.profiles{i});
end

control.cL;
control.cD;
control.alpha;

% Interpolation for other stations
cL=interpn(control.pos,control.cL,x,'linear');
cD=interpn(control.pos,control.cD,x,'linear');
alpha=interpn(control.pos,control.alpha,x,'linear');
Re=interpn(control.pos,control.Re,x,'linear');
M=interpn(control.pos,control.M,x,'linear');

% Blade twist distribution
for i=1:length(x)
    beta(i)=alpha(i)+phi_deg(i);
end

% Chord distribution
for i=1:length(x)
    sigma(i)=sigma_cL(i)/cL(i);
    chord(i)=pi*x(i)*2*sigma(i)*R/B;
end

% Plotting Blade 
figure
subplot(2,3,1);
plotyy(x,cL,x,cD,'plot','plot');
legend('c_L','c_D');
xlabel('x=r/R');
ylabel('Lift and Drag Coefficients');

subplot(2,3,2);
plot(x,phi_deg,x,beta);
legend('\phi','\beta');
xlabel('x=r/R');
ylabel('True wind angle and blade angle');

subplot(2,3,3);
plot(x,alpha);
legend('\alpha');
xlabel('x=r/R');
ylabel('Angle of attack');

subplot(2,3,4);
plot(x,chord);
xlabel('x=r/R');
ylabel('Chord Distribution [m]');

subplot(2,3,5);
plot(x,sigma);
xlabel('x=r/R');
ylabel('Solidity (\sigma) Distribution');

subplot(2,3,6);
plotyy(x,Re,x,M);
xlabel('x=r/R');
legend('Re','M');
ylabel('Reynolds and Mach Distribution');


end

