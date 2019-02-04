function [col,ccase,utcol,shs] = fcpcolyn3(col,utcol,cpl,cvel,org,ccase,shs,t,dt,n,N)

    %% Duration of collision (for update time)
    coldur = 10; % *dt
    
    %% Indices and circular boundary conditions
    n2l = n-2;
    nl  = n-1;
    nc  = n;
    nr  = n+1;
    if n==1
        nl  = N;
        n2l = N-1;
    elseif n==2
        n2l = N;
    elseif n==N
        nr = 1;
    end


    %% Determine if collision happens
    narr = [n2l nl nc nr];
    tmpcpl  = cpl(narr);
    tmpcvel = cvel(narr);
    tmporg  = org(narr);
    tmpcol  = col(narr);
    
    ns = find(tmpcpl);
    if sum(tmpcpl)==2
      rvel = tmpcvel(ns(2)) - tmpcvel(ns(1));
    end
    
    % if two cpls move into eachother -> collision
    if sum(tmpcpl)==2 && rvel<0 && tmpcol(ns(1)+1)==0 && tmpcol(ns(2)-1)==0
        % find index of cell where collision will happen
        if ns(2)-ns(1)==2
            ncol = narr(ns(2)-1);
            ccase(ncol) = 1;
        elseif ns(2)-ns(1)==3
            cands = [nl nc];
            rans = randperm(numel(cands));
            ncol = cands(rans(1));
            ccase(ncol) = 2;
            % which side must shift cpl
            [ncl,~,ncr] = fcirccond(ncol,N);
            if cpl(ncl)==0
                % move n2l to nl
                shs(ncol) = 1;
            elseif cpl(ncr)==0
                % move n2r to nr
                shs(ncol) = 2;
            end
        end
        col(ncol)    = 1;  
        utcol(ncol)  = t + coldur*dt;
    end
    
    % if two orgs occur next to eachother -> collision
    if sum(tmporg(ns))==2 && tmpcol(ns(1)+1)==0 && tmpcol(ns(2)-1)==0
        if ns(2)-ns(1)==2
            ncol = narr(ns(2)-1);
            ccase(ncol) = 1;
        elseif ns(2)-ns(1)==3
            cands = [nl nc];
            rans = randperm(numel(cands));
            ncol = cands(rans(1));
            ccase(ncol) = 2;
            % which side must shift cpl
            [ncl,~,ncr] = fcirccond(ncol,N);
            if cpl(ncl)==0
                % move n2l to nl
                shs(ncol) = 1;
            elseif cpl(ncr)==0
                % move n2r to nr
                shs(ncol) = 2;
            end
        end
        col(ncol)    = 1;
        utcol(ncol)  = t + coldur*dt;
    end
    


end

