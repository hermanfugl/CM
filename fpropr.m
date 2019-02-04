function [cvel,cpl] = fpropr(cvel,cpl,nc,nr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        cvel(nc)   = 0;
        cvel(nr)   = +1;
        cpl(nc)    = 0;
        cpl(nr)    = 1;


end

