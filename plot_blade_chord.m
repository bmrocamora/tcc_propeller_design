function []=plot_blade_chord(inputs,design,control)

% HUB
t=-pi/6:pi/180:pi/6;
a=inputs.hub*cos(t);
b=inputs.hub*sin(t);

% BLADE
x=0:1/control.span_elem:1;
upper_chord_design=design.chord*1/4;
lower_chord_design=-design.chord*3/4;

figure
plot(a,b,'k-',x(31:101),upper_chord_design(31:101),'r-',x(31:101),lower_chord_design(31:101),'r-');
axis equal
axis tight
matlab2tikz('resultado_planta_pa.tikz', 'height', '\figureheight', 'width', '\figurewidth');


end
