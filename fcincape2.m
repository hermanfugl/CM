function [cin,cape] = fcincape2(Tvp,Te,re,dz)

g = 9.81; % m/s^2
eps = .622;

% Virtual temperature
Tve = Te.*(1+re/eps)./(1+re);

    deltaTv = (Tvp - Tve);

    
    icin = find(deltaTv<-0.1);
    icape = find(deltaTv>0);
    if ~isempty(icape)
        ilnb = icape(end); % level of neutral buoyancy
        icin = icin(icin<ilnb); % don't count CIN above LNB
    end 

    cin = -g*sum(deltaTv(icin)./Tve(icin)*dz);
    cape = g*sum(deltaTv(icape)./Tve(icape)*dz);


end

