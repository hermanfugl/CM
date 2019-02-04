function [the,re,colcin] = fcpcolcc6(the,re,pe,z,dz,rhoe,hbl,n,N)

    %% Indices and circular boundary conditions
    nl  = n-1;
    nc  = n;
    nr  = n+1;
    if n==1
        nl  = N;
    elseif n==N
        nr = 1;
    end
    
    %% BL heights
    tmp = abs(z-hbl);
    bl2 = find(tmp==min(tmp));

    tmp = abs(z-hbl/2);
    bl1 = find(tmp==min(tmp));
        
    %% Masses
    Mbl  = sum(rhoe(1:bl2))*dz;
    Mcl  = sum(rhoe(bl2+1:end))*dz;  % kg/m2 
    
    %% Find temp layer height (same mass as bl)
    htls = 2*hbl:2.5*hbl;
    tls = NaN(size(htls));
    for i=1:length(htls)
       tmp = abs(z-htls(i)); 
       tls(i) = find(tmp==min(tmp));
    end
    Mtls = NaN(size(htls));
    for i = 1:length(htls)
       Mtls(i) = dz*sum(rhoe(bl2+1:tls(i)));
    end
    tmp = abs(Mtls-Mbl);
    is = find(tmp==min(tmp));
    tl = tls(is(1));
    Mtl = Mtls(is(1)); % kg/m2
    
    %% PLOT TEMPORARY
%     figure(1);
%     subplot(131); hold on
%     plot(re(:,nl),z,'.b'); axis([0 .02 0 4000]);
%     subplot(132); hold on
%     plot(re(:,nc),z,'.b'); axis([0 .02 0 4000]); 
%     subplot(133); hold on
%     plot(re(:,nr),z,'.b'); axis([0 .02 0 4000]);
  
   %% save original profiles
   theorg = the(bl2+1:end,nc); %
   reorg = re(bl2+1:end,nc); % !
   
   %% move tl air into cl
%    the(tl+1:end,nc) = ((Mcl-Mtl)*nanmean(the(tl+1:end,nc)) ...
%                        + Mtl*mean(the(bl2+1:tl)))/Mcl;
   the(tl+1:end,nc) = the(bl2+1:end-(tl-bl2),nc); % !! NB changed the above to this
   re(tl+1:end,nc)  = re(bl2+1:end-(tl-bl2),nc); % shift upwards
   %% move bl to tl
   the(bl2+1:tl,nc) = Mbl/Mtl*mean(the(1:bl2,nc));
   re(bl2+1:tl,nc)  = Mbl/Mtl*mean(re(1:bl2,nc));
   
   %% move cold pools into nc
   the(1:bl2,nc)    = (mean(the(1:bl1,nl)) + mean(the(1:bl1,nr)))/2;
   re(1:bl2,nc)     = (mean(re(1:bl1,nl)) + mean(re(1:bl1,nr)))/2;
   
   %% find colcin
   colcin = fcolcin(the(:,nc),pe,re(:,nc),hbl,z,dz);
    
   %% mix bl/tl column
   the(1:tl,nc) = (mean(the(1:bl2,nc)) + mean(the(bl2+1:tl,nc)))/2;
   re(1:tl,nc)  = (mean(re(1:bl2,nc)) + mean(re(bl2+1:tl,nc)))/2;
   
    %% refill blnl+blnr with tl air
    the(1:bl2,nl) = (mean(the(bl1+1:bl2,nl)) + mean(the(bl2+1:tl,nc)))/2;
    the(1:bl2,nr) = (mean(the(bl1+1:bl2,nr)) + mean(the(bl2+1:tl,nc)))/2;
    re(1:bl2,nl)  = (mean(re(bl1+1:bl2,nl)) + mean(re(bl2+1:tl,nc)))/2;
    re(1:bl2,nr)  = (mean(re(bl1+1:bl2,nr)) + mean(re(bl2+1:tl,nc)))/2;
    
    %% refill tl with res air
%     the(bl2+1:tl,nc) = nanmean(the(tl+1:end,nc));
    the(bl2+1:end,nc)  = theorg; % !!
    re(bl2+1:end,nc) = reorg;
  

end

