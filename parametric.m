%% Parametric Study



%% Checking Mach at tip

D_grid=1.5:0.1:3;
for i=1:length(D_grid)
    M_tip(i)=(V^2+(D_grid(i)*pi*n)^2)^0.5/340;
end
plot(D_grid,M_tip);

% Something to choose the diameter would be in here
% Present model includes manual choice