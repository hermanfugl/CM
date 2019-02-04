function [thp,Tvp,rp] = fLRpar4(Te,pe,RH,col,hbl,z,dz)

%% BL height
    tmp = abs(z-hbl);
    bl2 = find(tmp==min(tmp));
    
%% Shift surface to top of bl if cp collision
if col==0
    i0    = 1;
    T0    = Te(i0);
    RH0   = RH(i0);
    p0    = pe(i0);
elseif col==1
    i0    = bl2+1;
    T0    = Te(i0);
    RH0   = RH(i0);
    p0    = pe(i0);
end

%% Constants 
g = 9.81; % m/s^2
cpd = 1003.5; % J/kg/K
gammad = g/cpd;

Hv = 2501000; % J/kg
eps = .622;
Rsd = 287; % J/kg/K
ptrip = 611.65; % Pa
Ttrip = 273.16; % K
E0v = 2.3740e6; % J/kg

Rv = 461; % J/kg/K

cvv = 1418; % J/kg/K
cvl = 4119; % J/kg/K
cpv = cvv + Rv; % J/kg/K

%% Find LCL
% RH = r2RH(re,sfctemp,p_e(1));
[~,ilcl] = findlcl2(T0,pe,RH0,i0,z,dz);

%% Parcel LR below LCL
rp = NaN(size(z));
rp(i0:ilcl) = RH2r(RH0,T0,p0);
Tp = NaN(size(z));
Tp(i0) = T0; 
for i=i0+1:ilcl
    Tp(i) = Tp(i-1) - gammad*dz;
end

%% Parcel LR above LCL
gammaw = NaN(size(z));
pvstar = NaN(size(z));
pv = NaN(size(z));
gammaw(ilcl) = g*(1+(Hv*rp(ilcl))/(Rsd*Tp(ilcl)))/ ...
                (cpd+(Hv^2*rp(ilcl)*eps)/(Rsd*Tp(ilcl).^2));
            
for i=ilcl+1:length(z)
   Tp(i) = Tp(i-1) - gammaw(i-1)*dz; 
   
   pvstar(i) = ptrip.*(Tp(i)./Ttrip).^((cpv-cvl)/Rv).* ...
                exp((E0v - (cvv-cvl).*Ttrip)./Rv.*(1./Ttrip - 1./Tp(i)));       
   pv(i) = 1*pvstar(i);                                                 
   rp(i) = eps*pv(i)/(pe(i) - pv(i));   
   
   gammaw(i) = g*(1+(Hv*rp(i))/(Rsd*Tp(i)))/(cpd+(Hv^2*rp(i)*eps)/(Rsd*Tp(i)^2));
   
end


%% Potential temperature
% thp = Tp.*(pe(1)./pe).^(Rsd/cpd);

% find theta by integration 
thp = NaN(size(z));
dthp = NaN(size(z));
dthp(1:ilcl) = 0;
dthp(ilcl:end) = (pe(1)./pe(ilcl:end)).^(Rsd/cpd).*(-gammaw(ilcl:end) + gammad);

thp(i0) = T0*(pe(1)/pe(i0))^(Rsd/cpd);
for i=i0+1:length(z)
    thp(i) = thp(i-1) + dthp(i-1)*dz;
end

%% Virtual temperature
Tvp = Tp.*(1+rp/eps)./(1+rp);


end


