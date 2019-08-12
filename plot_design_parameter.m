function []=plot_design_parameter(inputs, control, p_design)

R=inputs.D/2;

x=0:1/control.span_elem:1;

figure
plotyy(x,p_design.Re,x,p_design.M,'plot','plot')
legend('Re','M')
matlab2tikz('resultado_Re_M.tikz', 'height', '\figureheight', 'width', '\figurewidth');

figure
plotyy(x,p_design.cL,x,p_design.cD,'plot','plot')
legend('c_L','c_D')
matlab2tikz('resultado_cL_cD.tikz', 'height', '\figureheight', 'width', '\figurewidth');

figure
plotyy(x,p_design.beta,x,p_design.chord*1000,'plot','plot')
legend('\beta [º]','b [mm]')
matlab2tikz('resultado_geometria.tikz', 'height', '\figureheight', 'width', '\figurewidth');


figure
plotyy(x,p_design.cL,x,p_design.alpha,'plot','plot')
legend('c_L','\alpha [º]')
matlab2tikz('resultado_alpha.tikz', 'height', '\figureheight', 'width', '\figurewidth');


figure
plot(x,p_design.cL.*p_design.sigma)
legend('(\sigma *c_L)')
matlab2tikz('resultado_carregamento.tikz', 'height', '\figureheight', 'width', '\figurewidth');


end