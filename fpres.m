function [pe,rhoe] = fpres(sfcp,sfcT,z,atm)

if atm==1
% isothermal atmosphere
H = 7990; % m
pe = sfcp*exp(-z/H); % Pa
rhoe = NaN;
end

if atm==2
% adiabatic atmosphere
g = 9.81; % m/s^2
cpd = 1003.5; % J/kg/K
Rd = 287;
pe = sfcp*(1 - (g*z)/(cpd*sfcT)).^(cpd/Rd);

% rhoe = pe./(Rd.*(sfcT-g/cpd.*z));
rhoe = sfcp/(Rd.*sfcT)*(1 - g*z/(cpd*sfcT)).^(cpd/Rd-1);
end
end

