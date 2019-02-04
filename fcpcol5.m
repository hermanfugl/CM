function [the,Te,re,colcin] = fcpcol5(the,re,pe,ccase,colcin,cpl,z,dz,rhoe,hbl,n,N)

%% Indices and circular boundary conditions
n2l = n-2;
nl  = n-1;
nc  = n;
nr  = n+1;
n2r = n+2;
if n==1
    nl  = N;
    n2l = N-1;
elseif n==2
    n2l = N;
elseif n==N
    nr  = 1;
    n2r = 2;
elseif n==N-1
    n2r = 1;
end

%% BL heights
tmp = abs(z-hbl);
BL2 = find(tmp==min(tmp));

tmp = abs(z-hbl/2);
BL1 = find(tmp==min(tmp));


%% Collision
%     if ccase==1
%         [the,re,colcin(nc)] = fcpcol3cc(the,re,pe,z,dz,rhoe,hbl,n,N);
%     elseif ccase==2
%         % move one cpl to make collision
%         if cpl(nl)==0
%             %% move n2l to nl
%              % segments
%         th1nl = mean(the(1:BL1,nl));
%         th1n2l = mean(the(1:BL1,n2l));
%         th2n2l = mean(the(BL1+1:BL2,n2l));
%         th2nl = mean(the(BL1+1:BL2,nl));
% 
%         r1nl = mean(re(1:BL1,nl));
%         r1n2l = mean(re(1:BL1,n2l));
%         r2n2l = mean(re(BL1+1:BL2,n2l));
%         r2nl = mean(re(BL1+1:BL2,nl));
%         
% 
%         % prop the to the right
%         the(1:BL1,nl)   = th1n2l;
%         the(BL1+1:BL2,nl) = th1nl;
%         the(1:BL1,n2l)   = th2n2l;
%         the(BL1+1:BL2,n2l) = th2nl;
%      
%         % prop re to the right
%         re(1:BL1,nl)    = r1n2l;
%         re(BL1+1:BL2,nl)  = r1nl;
%         re(1:BL1,n2l)    = r2n2l;
%         re(BL1+1:BL2,n2l)  = r2nl;
%             
%             %%
%         elseif cpl(nr)==0
%             %% move n2r to nr
%             % segments
%         th1nr = mean(the(1:BL1,nr));
%         th1n2r = mean(the(1:BL1,n2r));
%         th2n2r = mean(the(BL1+1:BL2,n2r));
%         th2nr = mean(the(BL1+1:BL2,nr));
% 
%         r1nr = mean(re(1:BL1,nr));
%         r1n2r = mean(re(1:BL1,n2r));
%         r2n2r = mean(re(BL1+1:BL2,n2r));
%         r2nr = mean(re(BL1+1:BL2,nr));
% 
%         
%         % prop the to the left
%         the(1:BL1,nr)   = th1n2r;
%         the(BL1+1:BL2,nr) = th1nr;
%         the(1:BL1,n2r)   = th2n2r;
%         the(BL1+1:BL2,n2r) = th2nr;  
%      
%         % prop re to the left
%         re(1:BL1,nr)    = r1n2r;
%         re(BL1+1:BL2,nr)  = r1nr;
%         re(1:BL1,n2r)    = r2n2r;
%         re(BL1+1:BL2,n2r)  = r2nr;  
%            disp(['Col in ' num2str(n) '. Prop from ' num2str(n2r) ' to ' num2str(nr)])
%         end
%         [the,re,colcin(nc)] = fcpcol3cc(the,re,pe,z,dz,rhoe,hbl,n,N); % fcpcol3c1 and c2 identical
%     end
%% Collision 2.0
% if ccase==2
%      % move one cpl to make collision
%         if cpl(nl)==0
%             %% move n2l to nl
%              % segments
%         th1nl = mean(the(1:BL1,nl));
%         th1n2l = mean(the(1:BL1,n2l));
%         th2n2l = mean(the(BL1+1:BL2,n2l));
%         th2nl = mean(the(BL1+1:BL2,nl));
% 
%         r1nl = mean(re(1:BL1,nl));
%         r1n2l = mean(re(1:BL1,n2l));
%         r2n2l = mean(re(BL1+1:BL2,n2l));
%         r2nl = mean(re(BL1+1:BL2,nl));
%         
% 
%         % prop the to the right
%         the(1:BL1,nl)   = th1n2l;
%         the(BL1+1:BL2,nl) = th1nl;
%         the(1:BL1,n2l)   = th2n2l;
%         the(BL1+1:BL2,n2l) = th2nl;
%      
%         % prop re to the right
%         re(1:BL1,nl)    = r1n2l;
%         re(BL1+1:BL2,nl)  = r1nl;
%         re(1:BL1,n2l)    = r2n2l;
%         re(BL1+1:BL2,n2l)  = r2nl;
%             
%             %%
%         elseif cpl(nr)==0
%             %% move n2r to nr
%             % segments
%         th1nr = mean(the(1:BL1,nr));
%         th1n2r = mean(the(1:BL1,n2r));
%         th2n2r = mean(the(BL1+1:BL2,n2r));
%         th2nr = mean(the(BL1+1:BL2,nr));
% 
%         r1nr = mean(re(1:BL1,nr));
%         r1n2r = mean(re(1:BL1,n2r));
%         r2n2r = mean(re(BL1+1:BL2,n2r));
%         r2nr = mean(re(BL1+1:BL2,nr));
% 
%         
%         % prop the to the left
%         the(1:BL1,nr)   = th1n2r;
%         the(BL1+1:BL2,nr) = th1nr;
%         the(1:BL1,n2r)   = th2n2r;
%         the(BL1+1:BL2,n2r) = th2nr;  
% 
%         % prop re to the left
%         re(1:BL1,nr)    = r1n2r;
%         re(BL1+1:BL2,nr)  = r1nr;
%         re(1:BL1,n2r)    = r2n2r;
%         re(BL1+1:BL2,n2r)  = r2nr; 
%         end  
% end

[the,re,colcin(nc)] = fcpcolcc6(the,re,pe,z,dz,rhoe,hbl,n,N);
   
%% Ambient absolute temperature
Rsd = 287; % J/kg/K
cpd = 1003.5; % J/kg/K

S = size(the);
pes = repmat(pe,1,S(2));
Te = the.*(pe(1)./pes).^(-Rsd/cpd);

end