function [the,Te] = fLRamb4(the,dT,pe,z,hbl,iBLtemp)

%% Constants 
Rsd = 287; % J/kg/K
cpd = 1003.5; % J/kg/K


% heights
tmp = abs(z-hbl/2);
bl1 = find(tmp==min(tmp));
tmp = abs(z-hbl);
bl2 = find(tmp==min(tmp));

% ht = 12000;
% tmp = abs(z-ht);
% iht = find(tmp==min(tmp));

%% Ambient lapse rate 
if sum(isnan(the(:)))==numel(the) % if all elements of the = NaN
    % Cloud layer
    CLtemp = 300;
    the(bl2+1:end) = CLtemp;
    % Boundary layer
    the(1:bl2) = iBLtemp;
else
    the(1:bl1) = the(1:bl1) + dT;
end


%% Ambient absolute temperature
Te = the.*(pe./pe(1)).^(Rsd/cpd);

%% Ambient humidity
% r_e = NaN(size(z));
% r_e(1:ibl) = RH2r(RH,sfctemp,pe(1));
% tmpRH = r2RH(r_e(ibl),Te(ibl),pe(ibl));
% r_e(ibl:end) = RH2r(tmpRH,Te(ibl:end),pe(ibl:end));

% RHe = RH*ones(size(z));
% r_e = RH2r(RHe,Te,pe);

% %% Virtual temperature
% Tve = Te.*(1+r_e./eps)./(1+r_e);




end

