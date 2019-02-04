function pvstar = satvappr(T)
% saturation vapor pressure from the clausius-clapeyron equation
% input [K] output [Pa]

ptrip = 611.65; % Pa
Ttrip = 273.16; % K
E0v = 2.3740e6; % J/kg
Rv = 461; % J/kg/K
cvv = 1418; % J/kg/K
cvl = 4119; % J/kg/K
cpv = cvv + Rv; % J/kg/K% 

pvstar = ptrip.*(T./Ttrip).^((cpv-cvl)/Rv).* ...
            exp((E0v - (cvv-cvl).*Ttrip)./Rv.*(1./Ttrip - 1./T));


end

