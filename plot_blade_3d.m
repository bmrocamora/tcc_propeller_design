function []=plot_blade_3d(control,design)

cd('Perfis');

origin=[0.25,0];
x=0:1/control.span_elem:1;
% chord_design=0.1*ones(1,span_elem+1);
% beta_design=77:-(77-34)/span_elem:34;

for i=1:numel(control.pos)
    % Control station number
    control.station(i);
    % Chord, profile, foil data and blade angle at station
    control.chord(i)=design.chord(control.station(i));
    control.profiles{i};
    foil{1,i}=csvread([control.profiles{i},'2.dat'],1);
    control.beta(i)=design.beta(control.station(i))*pi/180;

    % Dimensional foil data
    foil{1,i}=foil{1,i}*control.chord(i);
    
    % Rotational parameters and matrix
    sin_beta(i)=sin(control.beta(i));
    cos_beta(i)=cos(control.beta(i));
    rot=[];
    rot=[cos_beta(i), -sin_beta(i);...
         sin_beta(i), cos_beta(i)];
    
    % Local origin
    origin_local=origin*control.chord(i);
    
    % New foil data
    new_foil{1,i}(:,1)=foil{1,i}(:,1)-origin_local(1);
    new_foil{1,i}(:,2)=foil{1,i}(:,2)-origin_local(2);
    new_foil{1,i}=new_foil{1,i}*rot;
    new_foil{1,i}(:,1)=new_foil{1,i}(:,1);%+origin_local(1);
    new_foil{1,i}(:,2)=new_foil{1,i}(:,2);%+origin_local(2);
%     plot(new_foil{1,i}(:,1),new_foil{1,i}(:,2));
    
    % Foil radial coordinate
    new_foil{1,i}(:,3)=control.pos(i); 
	dlmwrite(['foil',num2str(control.pos(i)),'.txt'],new_foil{1,i});
end


figure
for i=4:numel(control.pos)
plot3(new_foil{1,i}(:,1),new_foil{1,i}(:,3),new_foil{1,i}(:,2));
hold on;
end
axis equal;
matlab2tikz('resultado_pa_3D.tikz', 'height', '\figureheight', 'width', '\figurewidth');
cd ..

end