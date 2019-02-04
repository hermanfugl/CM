function [z,dz,pe,rhoe] = fmodlvls(p,sfctemp,atm)
% Model height and pressure levels

%% Levels, pressure
n = 1000; % # of levels
h = 15000; % height m
z = linspace(0,h,n)'; % levels m
dz = z(2)-z(1); % m

[pe,rhoe] = fpres(p,sfctemp,z,atm); % pressure profile



end

