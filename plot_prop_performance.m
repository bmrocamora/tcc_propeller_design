function []=plot_prop_performance(J,delta_beta,performance)

figure
for j=1:length(delta_beta)
    [eff_max(j),I]=max(performance.eff(:,j));
    J_eff_max(j)=J(I);
    plot(J,performance.eff(:,j),'k-');
    hold on;
end
plot(J_eff_max,eff_max,'r-');
grid on;
axis ([.15 2.25 0.1 0.95]);
matlab2tikz('resultado_eficiencia.tikz', 'height', '\figureheight', 'width', '\figurewidth');


figure
for j=1:length(delta_beta)
    plot(J,performance.c_P(:,j),'k');
    legend('c_P');
    hold on;
end
    grid on;
    axis ([.15 2.25 0.1 0.8]);
matlab2tikz('resultado_cP.tikz', 'height', '\figureheight', 'width', '\figurewidth');


figure
for j=1:length(delta_beta)
    plot(J,performance.c_T(:,j),'r');
    legend('c_T'); 
    hold on;
end
    grid on;
    axis ([.15 2.25 0.05 0.45]);
matlab2tikz('resultado_cT.tikz', 'height', '\figureheight', 'width', '\figurewidth');



end