function [cpl,cvel,org,conv,utconv,col,utcol,ccase] = fconvdyn(cpl,cvel,org,conv,utconv,col,utcol,ccase,n,N)


    nl  = n-1;
    nc  = n;
    nr  = n+1;
    if n==1
        nl  = N;
    elseif n==N
        nr = 1;
    end
       
    % form cold pool
    cpl(nc)          = 1;
    org(nc)          = 1;
    cvel(nc)         = 0;
    
    % deactivate neighbouring ongoing convection events and this one
    conv([nl nc nr]) = 0;
    utconv([nl nc nr]) = NaN;
    
    % deactivate neighbouring cold pools (removed by overturning)
    cpl([nl nr]) = 0;
    cvel([nl nr]) = 0;
    
    % stop collisions in this or neighbouring cells (overturning)
    col([nl nc nr]) = 0;
    utcol([nl nc nr]) = NaN;
    ccase([nl nc nr]) = NaN;
end

