function [the,Te,re] = fmixlat(the,re,hbl,pe,z)

Rsd = 287; % J/kg/K
cpd = 1003.5; % J/kg/K

tmp = abs(z-hbl);
bl2 = find(tmp==min(tmp));
    

ther = [the(1:bl2,2:end) the(1:bl2,1)];
thec = the(1:bl2,:);
thel = [the(1:bl2,end) the(1:bl2,1:end-1)];
rer = [re(1:bl2,2:end) re(1:bl2,1)];
rec = re(1:bl2,:);
rel = [re(1:bl2,end) re(1:bl2,1:end-1)];

the(1:bl2,:) = .0001*ther + .9998*thec + .0001*thel;
re(1:bl2,:)  = .0001*rer  + .9998*rec  + .0001*rel;

%% Ambient absolute temperature
S = size(the);
pes = repmat(pe,1,S(2));
Te = the.*(pe(1)./pes).^(-Rsd/cpd);

%%
% A = randi(5,1,10);
% Al = [A(end) A(1:end-1)];
% Ar = [A(2:end) A(1)];
% figure(2);clf
% hold on
% plot(A)
% 
% AA = (Ar + A + Al)/3;
% plot(AA,'x-m')
% AAA = .25*Ar + .5*A + .25*Al;
% plot(AAA,'x-g')
% AAAA = .15*Ar + .7*A + .15*Al;
% plot(AAAA,'x-c')
% AAAAA = .1*Ar + .8*A + .1*Al;
% plot(AAAAA,'x-r')
end

