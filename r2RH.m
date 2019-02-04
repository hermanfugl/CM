function RH = r2RH(r,T,p)
% Convert from mixing ratio r to relative humidity RH
eps = .622;
pvstar = satvappr(T);
pv = r.*p./(r+eps);
RH = pv./pvstar;

end

