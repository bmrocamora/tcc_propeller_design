function K=goldstein_circ(x,J_wake)
% GOLDSTEIN CIRCULATION FACTOR Loads (corrected) Goldstein factor K against
% advance ratio at the wake (J_wake).
%
%   Code to interpolate circulation data related to advance ratio J and
%   adimensional radial coordinate x=r/R.
%   Data calculated by Crigler (1948), using a extrapolation of a method 
%   developed by Lock (1935);
%   Graph digitilized using digitalize2.m (A. Prasad,2009)
%
%   References:
%       CRIGLER, J. L. Application of Theodorsen's Theory to Propeller 
%   Design. NACA REPORT 924, 1948.
%       LOCK, C. N. H; YEATMAN, D. Tables for Use in an Inproved Method of
%   Airscrew Strip Theory Calculation. R. & M. No. 1674, British A. R. C.,
%   1935.
%
%% Organization:
% Inputs:
% x         [adim]      Radial coordinate (x=r/R)
% J_wake    [adim]      Advance ratio at the wake
%
% Outputs:
% K         [adim]      Circulation factor
%
%% Code:
% Loading graph data and curve fitting

KJ6B2R=csvread('KJ6B2R.csv',1,1);
J_KJ6B2R=KJ6B2R(:,1);
K_KJ6B2R=KJ6B2R(:,2);
[J2K6B2R]=rationalfit(J_KJ6B2R,K_KJ6B2R);

KJ6B3R=csvread('KJ6B3R.csv',1,1);
J_KJ6B3R=KJ6B3R(:,1);
K_KJ6B3R=KJ6B3R(:,2);
[J2K6B3R]=rationalfit(J_KJ6B3R,K_KJ6B3R);

KJ6B45R=csvread('KJ6B45R.csv',1,1);
J_KJ6B45R=KJ6B45R(:,1);
K_KJ6B45R=KJ6B45R(:,2);
[J2K6B45R]=rationalfit(J_KJ6B45R,K_KJ6B45R);

KJ6B6R=csvread('KJ6B6R.csv',1,1);
J_KJ6B6R=KJ6B6R(:,1);
K_KJ6B6R=KJ6B6R(:,2);
[J2K6B6R]=rationalfit(J_KJ6B6R,K_KJ6B6R);

KJ6B7R=csvread('KJ6B7R.csv',1,1);
J_KJ6B7R=KJ6B7R(:,1);
K_KJ6B7R=KJ6B7R(:,2);
[J2K6B7R]=rationalfit(J_KJ6B7R,K_KJ6B7R);

KJ6B8R=csvread('KJ6B8R.csv',1,1);
J_KJ6B8R=KJ6B8R(:,1);
K_KJ6B8R=KJ6B8R(:,2);
[J2K6B8R]=rationalfit(J_KJ6B8R,K_KJ6B8R);

KJ6B95R=csvread('KJ6B95R.csv',1,1);
J_KJ6B95R=KJ6B95R(:,1);
K_KJ6B95R=KJ6B95R(:,2);
[J2K6B95R]=rationalfit(J_KJ6B95R,K_KJ6B95R);

%% Data 3-D interpolation

J_grid=[0.5:0.05:3]';
x_grid=ones(length(J_grid),1);
x_values=[0,0.2,0.3,0.45,0.6,0.7,0.8,0.95,1];

xJK=[   [x_values(1)*x_grid,    J_grid,     zeros(length(J_grid),1)     ];
        [x_values(2)*x_grid,    J_grid,     J2K6B2R(J_grid)             ];
        [x_values(3)*x_grid,    J_grid,     J2K6B3R(J_grid)             ];
        [x_values(4)*x_grid,    J_grid,     J2K6B45R(J_grid)            ];
        [x_values(5)*x_grid,    J_grid,     J2K6B6R(J_grid)             ];
        [x_values(6)*x_grid,    J_grid,     J2K6B7R(J_grid)             ];
        [x_values(7)*x_grid,    J_grid,     J2K6B8R(J_grid)             ];
        [x_values(8)*x_grid,    J_grid,     J2K6B95R(J_grid)            ];
        [x_values(9)*x_grid,    J_grid,     zeros(length(J_grid),1)     ];
                                                                        ];
K=griddata(xJK(:,1),xJK(:,2),xJK(:,3),x,J_wake,'cubic');
    
end