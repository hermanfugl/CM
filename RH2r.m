function r = RH2r(RH,T,p)
% Convert from relative humidity RH to mixing ratio r 
eps = .622;
pvstar = satvappr(T);
pv = RH.*pvstar;
r = eps*pv./(p-pv);

end


