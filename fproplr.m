function [cvel,cpl] = fproplr(cvel,cpl,nl,nc,nr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        cvel(nl) = -1;
        cvel(nr) = +1;
        cpl(nc)  = 0;
        cpl(nl)  = 1;
        cpl(nr)  = 1;


end

