function    [utconv,conv] = fadjconv(utconv,conv,n,N)

    nl  = n-1;
    nc  = n;
    if n==1
        nl  = N;
    end
 
     if utconv(nc)==utconv(nl)
      cands = [nl nc];
      rans = randperm(numel(cands));
      nkill = cands(rans(1));
      utconv(nkill) = NaN;
      conv(nkill)   = NaN;
     end
    
end

