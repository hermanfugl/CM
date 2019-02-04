function [mflux,Hl] = fmflux2(re,Tbc,RHbc,hbl,m,z)

%% BL heights
tmp = abs(z-hbl);
bl2 = find(tmp==min(tmp));

tmp = abs(z-hbl/2);
bl1 = find(tmp==min(tmp));

%% Flux
ra = mean(re(1:bl1));

rho = 1.2; % kg/m3
Lv = 2.3740e6; % J/kg
Cl = .0015;
U = 5; % m/s

% eps = .622;
% rsat = eps*(RHbc*satvappr(Tbc)/(pe(1)-RHbc*satvappr(Tbc)));

if     Tbc==300 && RHbc==1
    rs  = .0228;   % sat. mixing ratio for Ts = 300 K
elseif Tbc==298 && RHbc==1
    rs  = .0202;    % sat. mixing ratio for Ts = 298 K 
elseif Tbc==300 && RHbc==.7
    rs  = .0158;   % .70 to rstar(300K)
elseif Tbc==300 && RHbc==.85
    rs  = .0193;   % .85 to rstar(300K)
elseif Tbc==298 && RHbc==.7
    rs  = .0140;   % .70 to rstar(298K)
end

qs = rs/(rs+1);
qa = ra/(ra+1);
% m = 820; % kg

Hl = rho*Lv*Cl*U*(qs-qa);

mflux = Hl/(m*Lv);

end
