N=2000;
V=80;
n=N/60;
D=1.5:0.05:2.5;
w_adim=0.4;

for i=1:length(D)
    M_tip(i)=((V*(1+w_adim))^2+(2*pi*(D(i)/2)*n)^2)^0.5/340
end
plot(D,M_tip)
xlabel('Diametro [m]')
ylabel('Numero de Mach na ponta da pa')
grid on

matlab2tikz('Mach_D.tikz', 'height', '\figureheight', 'width', '\figurewidth');
