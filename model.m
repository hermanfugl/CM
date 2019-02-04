clc; clearvars; 

tic

%% path to functions
addpath('/Functions')

%% constants
N = 100;

dt = 5*60; % s
T = 1000*60*60; % s
condur = 10; % *dt
propdur = 10; % *dt


hbl = 700; % boundary layer depth

%% initial conditions
% normal distribution
mu = 297;
sigma = 1.1;
iBLtemp = normrnd(mu,sigma,N,1);

%% Boundary conditions
Tbc = 300; % K
RHbc = 1;
e = .1; % re-evaporation fraction
d = .1; % detrainment fraction

%%
iRH = .6*ones(1,N);
p = 100000*ones(1,N); % Pa
cpl = zeros(1,N);
org = zeros(1,N);
cvel = zeros(1,N);
utconv = NaN(1,N);
utprop = NaN(1,N);
utcol  = NaN(1,N);
conv = zeros(1,N);
col = zeros(1,N);
cin = NaN(1,N);
cape = NaN(1,N);
colcin = NaN(1,N);
ccase = NaN(1,N);
shs = NaN(1,N);

atm = 2;
T0p = 300; % K
[z,dz,pe,rhoe] = fmodlvls(p(1),T0p,atm);

thp = NaN(length(z),N);
Tvp = NaN(length(z),N);
the = NaN(length(z),N);
Te  = NaN(length(z),N);
re  = NaN(length(z),N);
rp  = NaN(length(z),N);
RHe = NaN(length(z),N);
hrate = NaN(1,N);
mflux = NaN(1,N);
dT  = zeros(1,N);
dr  = zeros(1,N);
    tmp = abs(z-hbl);
    bl2 = find(tmp==min(tmp));
    tmp = abs(z-hbl/2);
    bl1 = find(tmp==min(tmp));
    tmp = abs(z-hbl);

    Mbl1 = sum(rhoe(1:bl1))*dz;     % kg/m2
    Mbl2 = sum(rhoe(bl1+1:bl2))*dz; % kg/m2
    Mbl  = Mbl1 + Mbl2;             % kg/m2

for n=1:N
[the(:,n),Te(:,n)] = fLRamb4(the(:,n),dT,pe,z,hbl,iBLtemp(n));
[re(:,n),RHe(:,n)] = fhum(re(:,n),dr,Te(:,n),pe,z,hbl,iRH(n)); 
[thp(:,n),Tvp(:,n),rp(:,n)] = fLRpar5(Te(:,n),pe,RHe(:,n),z,dz);
end

%% t/n-plot variables 
BL1T       = NaN(T/dt,N);
BL1Tp      = NaN(T/dt,N);
BL2T       = NaN(T/dt,N);
CLT        = NaN(T/dt,N);
res        = NaN(T/dt,N);
BL1r       = NaN(T/dt,N);
BL2r       = NaN(T/dt,N);
CLr        = NaN(T/dt,N);
CLr2       = NaN(T/dt,N);
cvels      = NaN(T/dt,N);
cpls       = NaN(T/dt,N);
convs      = NaN(T/dt,N);
cols       = zeros(T/dt,N);
cins       = NaN(T/dt,N);
capes      = NaN(T/dt,N);
colcins    = NaN(T/dt,N);
utprops    = NaN(T/dt,N); 
utconvs    = NaN(T/dt,N);
utcols     = NaN(T/dt,N);
hrates     = NaN(T/dt,N);
mfluxs     = NaN(T/dt,N);
orgs       = NaN(T/dt,N);
ccases     = NaN(T/dt,N);
excols     = zeros(T/dt,N);
shss       = NaN(T/dt,N);
r_int      = NaN(T/dt,N);
Hb         = NaN(T/dt,N);
dE         = NaN(T/dt,N);
Hs         = NaN(T/dt,N);
Hl         = NaN(T/dt,N);
Et         = NaN(T/dt,1);
Es         = NaN(T/dt,1);
El         = NaN(T/dt,1);
s1         = zeros(T/dt,N);
l1         = zeros(T/dt,N);
co         = zeros(T/dt,N);
ev         = zeros(T/dt,N);

tt = 1;
BL1T(tt,:) = the(1,:);
BL1Tp(tt,:) = thp(1,:);
res(tt,:)  = re(1,:);

%% loop over time and cells
for t=1:dt:T
% execute convection events
for n=1:N
	if t==utconv(n)
    [the,Te,re,r_int(tt,n),s1(tt,n),l1(tt,n),co(tt,n),ev(tt,n)] = fconv2(the,re,pe,z,dz,rhoe,hbl,e,d,n,N);       
    [cpl,cvel,org,conv,utconv,col,utcol,ccase] = fconvdyn(cpl,cvel,org,conv,utconv,col,utcol,ccase,n,N);
	end  
end
% shift case2-collision cpls
for n=1:N
    if t==utcol(n) && ccase(n)==2
        
        tmp = abs(z-hbl);
        BL2 = find(tmp==min(tmp));
        tmp = abs(z-hbl/2);
        BL1 = find(tmp==min(tmp));

        n2l = n-2;
        nl  = n-1;
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
        if shs(n)==1
            % move n2l to nl
        % segments
        th1nl = mean(the(1:BL1,nl));
        th1n2l = mean(the(1:BL1,n2l));
        th2n2l = mean(the(BL1+1:BL2,n2l));
        th2nl = mean(the(BL1+1:BL2,nl));

        r1nl = mean(re(1:BL1,nl));
        r1n2l = mean(re(1:BL1,n2l));
        r2n2l = mean(re(BL1+1:BL2,n2l));
        r2nl = mean(re(BL1+1:BL2,nl));
        

        % prop the to the right
        the(1:BL1,nl)   = th1n2l;
        the(BL1+1:BL2,nl) = th1nl;
        the(1:BL1,n2l)   = th2n2l;
        the(BL1+1:BL2,n2l) = th2nl;
     
        % prop re to the right
        re(1:BL1,nl)    = r1n2l;
        re(BL1+1:BL2,nl)  = r1nl;
        re(1:BL1,n2l)    = r2n2l;
        re(BL1+1:BL2,n2l)  = r2nl;
            
        elseif shs(n)==2
            % move n2r to nr
        % segments
        th1nr = mean(the(1:BL1,nr));
        th1n2r = mean(the(1:BL1,n2r));
        th2n2r = mean(the(BL1+1:BL2,n2r));
        th2nr = mean(the(BL1+1:BL2,nr));

        r1nr = mean(re(1:BL1,nr));
        r1n2r = mean(re(1:BL1,n2r));
        r2n2r = mean(re(BL1+1:BL2,n2r));
        r2nr = mean(re(BL1+1:BL2,nr));

        
        % prop the to the left
        the(1:BL1,nr)   = th1n2r;
        the(BL1+1:BL2,nr) = th1nr;
        the(1:BL1,n2r)   = th2n2r;
        the(BL1+1:BL2,n2r) = th2nr;  

        % prop re to the left
        re(1:BL1,nr)    = r1n2r;
        re(BL1+1:BL2,nr)  = r1nr;
        re(1:BL1,n2r)    = r2n2r;
        re(BL1+1:BL2,n2r)  = r2nr; 
        end  
    end
end
% execute collisions
for n=1:N
    if t==utcol(n)
    excols(tt,n) = 1;
    [the,Te,re,colcin] = fcpcol5(the,re,pe,ccase(n),colcin,cpl,z,dz,rhoe,hbl,n,N);
    col(n)   = 0;
    utcol(n) = NaN;
    ccase(n) = NaN;
    end
end

% sfc fluxes
for n=1:N
    [hrate(n),Hs(tt,n)] = fhrate3(the(:,n),Tbc,hbl,Mbl1,z);
    [mflux(n),Hl(tt,n)] = fmflux2(re(:,n),Tbc,RHbc,hbl,Mbl1,z);
    dT(n) = hrate(n)*dt;
	dr(n) = mflux(n)*dt;
end

% calculate profiles
for n=1:N
    [the(:,n),Te(:,n)] = fLRamb4(the(:,n),dT(n),pe,z,hbl,iBLtemp(n));
    [re(:,n),RHe(:,n)] = fhum(re(:,n),dr(n),Te(:,n),pe,z,hbl,iRH(n));
    [thp(:,n),Tvp(:,n),rp(:,n)] = fLRpar5(Te(:,n),pe,RHe(:,n),z,dz);
end

for n=1:N
    % find cin
    if isnan(colcin(n))
    [cin(n),cape(n)] = fcincape2(Tvp(:,n),Te(:,n),re(:,n),dz);
    end  
    if ~isnan(colcin(n))
    cin(n) = colcin(n);
    colcins(tt,:) = colcin;
    colcin(n) = NaN;
    end
    % initiate convection/assign utconvs
    if isnan(utconv(n))
    conv(n) = fisconv(cin(n));
      if conv(n)==1
         utconv(n) = t + condur*dt;
         utprop(n) = NaN;
      end
    end
end

% pick one cell for adjacent convection events
for n=1:N
    [utconv,conv] = fadjconv(utconv,conv,n,N);
end

% find and initiate cpl collisions
for n=1:N
    [col,ccase,utcol,shs] = fcpcolyn3(col,utcol,cpl,cvel,org,ccase,shs,t,dt,n,N);
end

% propagate cold pools
for n=1:N
	if t==utprop(n)
    [org,cpl,cvel,the,~,re] = fcpswap7(org,cpl,cvel,col,the,re,pe,hbl,z,n,N);
    utprop(n) = NaN;
	end
end

% find cold pools and assign propagation update times
for n=1:N
    if cpl(n)==1 && isnan(utprop(n)) && isnan(utconv(n))
    utprop(n) = t + propdur*dt;
    end
end

% mix bl laterally
[~,Te,re] = fmixlat(the,re,hbl,pe,z); 
% mix bl vertically
for n=1:N
    [~,Te(:,n),re(:,n)] = fmixbl(the(:,n),re(:,n),hbl,Mbl1,Mbl2,pe,z);
end
% reservoir radiation heat loss
[the,Te,Hb(tt,:),dE(tt,:)] = frestemp(Te,the,rhoe,pe,hbl,z,dz,dt);

% total energy
mprf = mean(the,2);
cp = 1003.5;
Es(tt) = sum(mprf.*rhoe.*cp)*dz;

mprf = mean(re,2);
Lv = 2.3740e6; % J/kg
El(tt) = sum(mprf.*rhoe.*Lv)*dz;

BL1r(tt,:)    = re(bl1,:);
BL2r(tt,:)    = re(bl2,:);
CLr(tt,:)     = mean(re(bl2+1:end,:));
BL1T(tt,:)    = the(bl1,:);
BL2T(tt,:)    = the(bl2,:);
CLT(tt,:)     = mean(the(bl2+1:end,:));
cins(tt,:)    = cin;
capes(tt,:)   = cape;
hrates(tt,:)  = hrate;
mfluxs(tt,:)  = mflux;
cols(tt,:)    = col;
cvels(tt,:)   = cvel;
cpls(tt,:)    = cpl;
convs(tt,:)   = conv;
utprops(tt,:) = utprop;
utconvs(tt,:) = utconv;
utcols(tt,:)  = utcol;
orgs(tt,:)    = org;
ccases(tt,:)  = ccase;
shss(tt,:)    = shs;
tt = tt + 1;

disp(num2str(tt/(T/dt)))
end

toc/60


