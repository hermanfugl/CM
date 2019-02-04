function [the,Te,Hb,dE] = frestemp(Te,the,rhoe,pe,hbl,z,dz,dt)

S = size(Te);
pes = repmat(pe,1,S(2));

tmp = abs(z-hbl);
bl2 = find(tmp==min(tmp));   

sig = 5.67e-8; % J/s/m^2/K^4
% Tm = 236; % K
    % Make radiation a function of mean temperature instead:
%     Tm = mean(nanmean(Te(bl2+1:end,:)));
    Tm = sum(Te(bl2+1:end,1).*rhoe(bl2+1:end))/sum(rhoe(bl2+1:end));
Rsd = 287; % J/kg/K
cpd = 1003.5; % J/kg/K

Mcl  = sum(rhoe(bl2+1:end))*dz;

% Hb = sig*Te(bl2+1:end,1).^4;
Hb = sig*Tm^4;
dthe = Hb/(Mcl*cpd)*dt;

% find dtheta
% tmp = abs(Te(:,1)-Tm);
% iref = find(tmp==min(tmp));
% pref = pe(iref);
% dthe = dT.*(pe(1)./pref).^(Rsd/cpd);

the(bl2+1:end,:) = the(bl2+1:end,:) - dthe;

dE = dthe*(Mcl*cpd)/dt;
% disp(dT)
% disp(mean(the(bl2+1:end,1)))
%% Ambient potential temperature
% S = size(Te);
% pes = repmat(pe,1,S(2));
% the = Te.*(pe(1)./pes).^(Rsd/cpd);

Te = the.*(pe(1)./pes).^(-Rsd/cpd);

end
