function [the,Te,re,r_int,s1,l1,cond,evap] = fconv2(the,re,pe,z,dz,rhoe,hbl,e,d,n,N)

%% Test inputs
% N = 3;
% n = 2;
% 
% the = NaN(length(z),N);
% the(1:bl2,:) = 295;
% the(1:bl2,2) = 300;
% the(bl2+1:end,:) = 302;
% 
% re = NaN(length(z),N);
% re(1:bl2,:) = .0133;
% re(1:bl2,2) = .0181;
% re(bl2+1:end,:) =  [linspace(.0204,0,952);linspace(.0204,0,952);linspace(.0204,0,952)]' ;

%% Indices and circular boundary conditions
nl = n-1;
nc = n;
nr = n+1;
if n==1
    nl = N;
elseif n==N
    nr = 1;
end

%% Constants
Lv = 2.3740e6; % J/kg
Rsd = 287; % J/kg/K
cpd = 1003.5; % J/kg/K


%% BL heights
tmp = abs(z-hbl);
bl2 = find(tmp==min(tmp));

tmp = abs(z-hbl/2);
bl1 = find(tmp==min(tmp));

% hbl1 = z(bl1);
% hbl2 = z(bl2) - z(bl1);
% hcl  = z(end) - z(bl2);

%% Masses
Mbl1 = sum(rhoe(1:bl1))*dz;     % kg/m2
Mbl2 = sum(rhoe(bl1+1:bl2))*dz; % kg/m2
Mbl  = Mbl1 + Mbl2;               % kg/m2
Mcl  = sum(rhoe(bl2+1:end))*dz;  % kg/m2  

%% Example profiles plot
% figure(6);clf
%   subplot(1,3,1)
%         plot(the(:,nl),z,'r--')
%         xlim([290 325])
%         ylim([0 4000])
%         hline(hbl,'--')
%        subplot(1,3,2)
%         plot(the(:,nc),z,'r--')
%         xlim([290 325])
%         ylim([0 4000])
%         hline(hbl,'--')
%        subplot(1,3,3)
%         plot(the(:,nr),z,'r--')
%         xlim([290 325])
%         ylim([0 4000])
%         hline(hbl,'--') 
%  
% figure(7);clf
%   subplot(1,3,1)
%         plot(re(:,nl),z,'r--')
%         xlim([.01 .02])
%         ylim([0 9000])
%         hline(hbl,'--')
%        subplot(1,3,2)
%         plot(re(:,nc),z,'r--')
%         xlim([.01 .02])
%         ylim([0 9000])
%         hline(hbl,'--')
%        subplot(1,3,3)
%         plot(re(:,nr),z,'r--')
%         xlim([.01 .02])
%         ylim([0 9000])
%         hline(hbl,'--') 
        
%% Segments
thblnc = mean(the(1:bl2,nc));
thblnl = mean(the(1:bl2,nl));
thblnr = mean(the(1:bl2,nr));
thres  = mean(nanmean(the(bl2+1:end,1:N)));
reres  = re(bl2+1:end,:);

rblnc = mean(re(1:bl2,nc));
rblnl = mean(re(1:bl2,nl));
rblnr = mean(re(1:bl2,nr));

% rain intensity
r_int = (1-d)*rblnc*Mbl;% [kg/m2/event] ! d !

%% Rearrange
% bl air into reservoir
the(bl2+1:end,:) = (N*Mcl*thres + Mbl*thblnc)/(N*Mcl + Mbl);
    R  = sum(rhoe(bl2+1:end).*reres(:,1))*dz;
    dR = Mbl*d*rblnc; % ! d !
    C  = (R+dR)/R;
re(bl2+1:end,:)  = C*reres;
% condense moisture from bl
thelhc = Lv/cpd*(1-d)*rblnc; % ! d !
the(bl2+1:end,:) = the(bl2+1:end,:) + Mbl/(N*Mcl + Mbl)*thelhc;
% blnl+blnr air into empty blnc
the(1:bl2,nc) = (thblnl + thblnr)/2;
re(1:bl2,nc)  = (rblnl + rblnr)/2;
% mass Mbl/2 of reservoir air into blnl+blnr 
the(1:bl2,nl) = ( mean(mean(the(bl2+1:end,:))) + mean(the(1:bl2,nl)) )/2; % ! 
the(1:bl2,nr) = ( mean(mean(the(bl2+1:end,:))) + mean(the(1:bl2,nr)) )/2; % !

reresm = (sum(re(bl2+1:end,1).*rhoe(bl2+1:end)*dz))/Mcl;
re(1:bl2,nl)  = ( reresm + mean(re(1:bl2,nl)) )/2; % !
re(1:bl2,nr)  = ( reresm + mean(re(1:bl2,nr)) )/2; % !
                                                                                            % re(1:bl2,nl)  =  (mean(mean(re(bl2+1:end,:))) +  mean(re(1:bl2,nl)))/2; % !
                                                                                            % re(1:bl2,nr)  =  (mean(mean(re(bl2+1:end,:))) +  mean(re(1:bl2,nr)))/2; % !
% remove moisture from reservoir
    R = sum(rhoe(bl2+1:end).*re(bl2+1:end,1))*dz;
    dR2 = Mbl*reresm;
    C = (R-dR2)/R;
re(bl2+1:end,:) = C*re(bl2+1:end,:);

% re-evaporate precipitation in blnc
thelhe = -Lv/cpd*e*(1-d)*rblnc; % ! d !
the(1:bl2,nc) = the(1:bl2,nc) + thelhe;
re(1:bl2,nc)  = re(1:bl2,nc) + e*(1-d)*rblnc; % ! d !

% disp(rblnc)
% disp(thelhe)

% heat flux
s1 = (thblnc-(mean(nanmean(the(bl2+1:end,:)))))*Mbl*cpd/300;
l1 = (dR-dR2)*Lv/300;
% phase changes
cond  = Lv*Mbl*(1-d)*rblnc/300;
evap  = Lv*Mbl*e*(1-d)*rblnc/300;
%% Ambient absolute temperature
S = size(the);
pes = repmat(pe,1,S(2));
Te = the.*(pe(1)./pes).^(-Rsd/cpd);

%%
% figure(6)
%   subplot(1,3,1)
%   hold on
%   plot(the(:,nl),z,'m--')
%   subplot(1,3,2)
%   hold on
%   plot(the(:,nc),z,'m--')
%   subplot(1,3,3)
%   hold on
%   plot(the(:,nr),z,'m--')
% 
% figure(7)
%   subplot(1,3,1)
%   hold on
%   plot(re(:,nl),z,'m--')
%   subplot(1,3,2)
%   hold on
%   plot(re(:,nc),z,'m--')
%   subplot(1,3,3)
%   hold on
%   plot(re(:,nr),z,'m--')
% 
% 
% 
