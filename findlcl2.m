function [zlcl,ilcl] = findlcl2(T0,pe,RH0,i0,z,dz)
% Find LCL height of a parcel. If LCL is below level z(i0), i.e. parcel is
% already saturated, function returns zlcl at z(i0).

p0 = pe(i0);
%% Constants 
g = 9.81;
cpd = 1003.5;
gammad = g/cpd;

ptrip = 611.65; % Pa
Ttrip = 273.16; % K
Lv = 2.3740e6; % J/kg

Rv = 461; % J/kg/K
cvv = 1418; % J/kg/K
cvl = 4119; % J/kg/K
cpv = cvv + Rv; % J/kg/K

eps = .622;

%% Make Tp a dry adiabat 
Tp = NaN(size(z));
Tp(i0) = T0;
for i = i0+1:length(z)
    Tp(i) = Tp(i-1) - gammad*dz;
end
%% Calculate saturation vapour pressure at every level (CC)
pvstar = NaN(size(z));
for i = i0:length(z)
pvstar(i) = ptrip.*(Tp(i)./Ttrip).^((cpv-cvl)/Rv).* ...
        exp((Lv - (cvv-cvl).*Ttrip)./Rv.*(1./Ttrip - 1./Tp(i)));
end

%% Set mixing ratio rp constant for every level
rp = NaN(size(z));
rp(i0:end) = RH2r(RH0,T0,p0);
%% Calculate vapour pressure at every level
pv = NaN(size(z));
pv = (rp.*pe)./(rp + eps);
%% Intersection of pvstar and pv is LCL
tmp = abs(pvstar-pv);
ilcl = find(tmp==min(tmp));
zlcl = z(ilcl);

% figure(11);clf
% plot(pvstar,z,'.',pv,z,'.c',pv(ilcl),z(ilcl),'or')
% grid on

end



