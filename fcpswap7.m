function [org,cpl,cvel,the,Te,re] = fcpswap7(org,cpl,cvel,col,the,re,pe,hbl,z,n,N)


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
    nr = 1;
    n2r = 2;
elseif n==N-1
    n2r = 1;
end

%% BL heights
tmp = abs(z-hbl);
BL2 = find(tmp==min(tmp));

tmp = abs(z-hbl/2);
BL1 = find(tmp==min(tmp));

%% Wake weights
ww = [.8 .2];

%% Swaps
if org(nc)==1          
    if sum(col([n2l nl nr n2r]))==0 && sum(cpl([n2l nl nr n2r]))==0         % org and no collisions to left and right
        org(nc)  = 0;
        % prop both directions
        [cvel,cpl] = fproplr(cvel,cpl,nl,nc,nr);
        [the,re]   = fproptdlr(the,re,BL1,BL2,ww,nl,nc,nr);
    elseif (col(n2l)==1 || col(nl)==1) && sum(col([n2r nr]))==0 && sum(cpl([n2r nr]))==0 % org but collision to the left
        org(nc)  = 0;
        % prop to the right
        [cvel,cpl] = fpropr(cvel,cpl,nc,nr);
        [the,re]   = fproptdr(the,re,BL1,BL2,ww,nc,nr);
    elseif (col(n2r)==1 || col(nr)==1) && sum(col([n2l nl]))==0 && sum(cpl([n2l nl]))==0 % org but collision to te right
        org(nc)  = 0;
        % prop to the left  
        [cvel,cpl] = fpropl(cvel,cpl,nl,nc);
        [the,re]   = fproptdl(the,re,BL1,BL2,ww,nl,nc);
    end
    
    org(nc)=0;
end


if cvel(nc)<0 
    if col(nl)~=1 && col(n2l)~=1 % trvling to the left and no cols in the way, change to sum(col([n2l nl]))==0
        % prop to the left
        [cvel,cpl] = fpropl(cvel,cpl,nl,nc);
        [the,re]   = fproptdl(the,re,BL1,BL2,ww,nl,nc);
    elseif col(n2l)==1 || col(nl)==1 % trvling to the left but col in the way
        cvel(nc)   = 0;
    end

end

if cvel(nc)>0 
    if col(nr)~=1 && col(n2r)~=1 % trvling to the right and no cols in the way, change to sum(col([n2r nr]))==0
        % prop to the right
        [cvel,cpl] = fpropr(cvel,cpl,nc,nr);
        [the,re]   = fproptdr(the,re,BL1,BL2,ww,nc,nr);
    elseif col(n2r)==1 || col(nr)==1 % trvling to the right but col in the way
        cvel(nc)   = 0;
    end 
end

if cvel(nc)==0        % the collision extinguishes the cpls
    cpl(nc) = 0;
end

%% Ambient absolute temperature
Rsd = 287; % J/kg/K
cpd = 1003.5; % J/kg/K

S = size(the);
pes = repmat(pe,1,S(2));
Te = the.*(pe(1)./pes).^(-Rsd/cpd);


end

