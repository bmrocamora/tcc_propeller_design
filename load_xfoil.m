function [alpha,Cl,Cd,Cm,Cpmin]=load_xfoil(profile,Re,M)
%% LOAD PROFILE Loads profile aerodynamics from XFoil
% Uses Reynolds and Mach numbers to load aerodynamics from a determined
% profile
%
%% Organization:
% Inputs:
%   profile         [string]    Airfoil section
%   Re              [adim]      Reynolds number
%   M               [adim]      Mach number
%
% Outputs:
%   alpha           [deg]       section angle of attack
%   cL              [adim]      section lift coefficient
%   cD              [adim]      section drag coefficient
%   cM              [adim]      section moment coefficient
%   cPmin           [adim]      section minimum pressure coefficient
%
%% Code

arquivo = [profile '-Re' num2str(Re,2) '-M' num2str(M,2) '.txt'];

% Defining angle of attack range and step
aseq='-3 15 0.5';

if ~exist(['Perfis\' arquivo], 'file')

    cd('Perfis')
    
    arquivoCmd = fopen('cmdXfoil.txt','wt');
    fprintf(arquivoCmd,['load ' profile '.dat\n\n']);
    fprintf(arquivoCmd,'pane\n');
    fprintf(arquivoCmd,'oper\n');
    fprintf(arquivoCmd,'iter 100\n');
    fprintf(arquivoCmd,['visc ' num2str(Re,2) ' \n']);
    fprintf(arquivoCmd,['mach ' num2str(M,2) ' \n']);
    fprintf(arquivoCmd,'a 0\n');
    fprintf(arquivoCmd,'a -2\n');
    fprintf(arquivoCmd,'a -3\n');
    fprintf(arquivoCmd,'cinc\n');
    fprintf(arquivoCmd,'pacc\n');
    fprintf(arquivoCmd,[arquivo '\n']);
    fprintf(arquivoCmd,'\n');
    fprintf(arquivoCmd,'init\n');
    fprintf(arquivoCmd,['aseq ' aseq ' \n']);
    fprintf(arquivoCmd,'pacc\n');
    fprintf(arquivoCmd,'\n');
    fprintf(arquivoCmd,'quit\n');
    fclose(arquivoCmd);
    
    system('xfoil < cmdXfoil.txt');
    
    system('del cmdXfoil.txt');
    
    cd('..')
    
end


file = fopen(['Perfis\' arquivo]);
temp = fgets(file);
while ischar(temp)
    if ~isempty(strfind(temp,'---'))
        break
    end
    temp = fgets(file);
end

data = [];
temp = fgets(file);
while ischar(temp)
    data = [data; temp];
    temp = fgets(file);
end

fclose(file);

data = str2num(data);

data(any(isnan(data),2),:) = [];

alpha = data(:,1);
Cl = data(:,2);
Cd = data(:,3);
Cm = data(:,5);
Cpmin = data(:,6);


end