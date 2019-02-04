function [re,RHe] = fhum(re,dr,Te,pe,z,hbl,iRH)

% prescribed RH in free troposphere/cloud layer
RHcl = .6;
% heights
tmp = abs(z-hbl/2);
bl1 = find(tmp==min(tmp));
tmp = abs(z-hbl);
bl2 = find(tmp==min(tmp));

if sum(isnan(re(:)))==numel(re)
    re(1:end) = RH2r(iRH,Te(1),pe(1));
    RHe = r2RH(re,Te,pe);
    RHe(bl2+1:end) = RHcl;
    re(bl2+1:end) = RH2r(RHe(bl2+1:end),Te(bl2+1:end),pe(bl2+1:end));
else
    re = re;
    re(1:bl1) = re(1:bl1) + dr;
    RHe = r2RH(re,Te,pe);
end




end