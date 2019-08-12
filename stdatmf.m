%   *********** 1976 STANDARD ATMOSPHERE SUBROUTINE **********
%
%     Mason's BASIC program, converted to FORTRAN - Sept. 1, 1989
%     converted to MATLAB, by Paul Buller, 1998
%     converted to a MATLAB function by w.h. mason, 2001
%
%
%     W.H. Mason
%     Department of Aerospace and Ocean Engineering
%     Virginia Tech, Blacksburg, VA 24061
%     email: mason@aoe.vt.edu
%
%     k  -  = 0 - metric units
%          <> 0 - English units
%
%     KK -   0 - good return
%            1 - error: altitude out of table,
%                 do not use output (max altitude for this
%                 routine is 84.85 km or 282,152 ft.)
%
%     Z  - input altitude, in feet or meters (depending on k)
%
%     output:
%                      units: metric        English
%     T  - temp.               deg K         deg R
%     P  - pressure            N/m^2         lb/ft^2
%     R  - density (rho)       Kg/m^3        slug/ft^3
%     A  - speed of sound      m/sec         ft/sec
%     MU - viscosity           Kg/(m sec)    slug/<ft sec)
%     
%     TS - t/t at sea level
%     RR - rho/rho at sea level
%     PP - p/p at sea level
%
%     RM - Reynolds number per Mach per unit of length
%     QM - dynamic pressure/Mach^2
%

function [T,R,P,A,MU,TS,RR,PP,RM,QM,KK] = stdatmf(Z,k)
KK = 0;
K = 34.163195;
C1 = 3.048e-4;
T = 1;
PP = 0;

if (k==0)
 TL = 288.15;
 PL = 101325;
 RL = 1.225;
 C1 = 0.001;
 AL = 340.294;
 ML = 1.7894e-5;
 BT = 1.458e-6;
else
 TL = 518.67;
 PL = 2116.22;
 RL = 0.0023769;
 AL = 1116.45;
 ML = 3.7373e-7;
 BT = 3.0450963e-8;
end

H = C1*Z/(1 + C1*Z/6356.766);

if (H<11)
 T = 288.15 - 6.5*H;
 PP = (288.15/T)^(-K/6.5);
elseif (H<20)
 T = 216.65;
 PP = 0.22336*exp(-K*(H-11)/216.65);
elseif (H<32)
 T = 216.65 + (H-20);
 PP = 0.054032*(216.65/T)^K;
elseif (H<47)
 T = 228.65 + 2.8*(H-32);
 PP = 0.0085666*(228.65/T)^(K/2.8);
elseif (H<51)
 T = 270.65;
 PP = 0.0010945*exp(-K*(H-47)/270.65);
elseif (H<71)
 T = 270.65 - 2.8*(H-51);
 PP = 0.00066063*(270.65/T)^(-K/2.8);
elseif (H<84.852)
 T = 214.65 - 2*(H-71);
 PP = 3.9046e-5*(214.65/T)^(-K/2);
else
% chosen altitude too high
 KK = 1;
end

M1 = sqrt(1.4*287*T);
RR = PP/(T/288.15);
MU = BT*T^1.5/(T+110.4);
TS = T/288.15;
A = AL*sqrt(TS);
T = TL*TS;
R = RL*RR;
P = PL*PP;
RM = R*A/MU;
QM = 0.7*P;
