function [cvel,cpl] = fpropl(cvel,cpl,nl,nc)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        cvel(nc)   = 0;
        cvel(nl)   = -1;
        cpl(nc)    = 0;
        cpl(nl)    = 1;


end

