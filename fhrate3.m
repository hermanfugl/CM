function [hrate,Hs] = fhrate3(the,Tbc,hbl,m,z)

%% BL heights
tmp = abs(z-hbl);
bl2 = find(tmp==min(tmp));

tmp = abs(z-hbl/2);
bl1 = find(tmp==min(tmp));


%% Flux
rho = 1.2; % kg/m3
cp = 1003.5; % J/kg/K
Cs = .0015; % 
U = 5; % m/s
Ts = Tbc; % K
Ta = mean(the(1:bl1)); % K
% m = 820; % kg

Hs = rho*cp*Cs*U*(Ts-Ta);

hrate = Hs/(m*cp);

end
