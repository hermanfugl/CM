function colcin = fcolcin(the,pe,re,hbl,z,dz)

    
    Rsd = 287; % J/kg/K
    cpd = 1003.5; % J/kg/K
    kappa = Rsd/cpd;
    col = 1;
    
    Te          = the.*(pe(1)./pe).^(-kappa);
    RHe         = r2RH(re,Te,pe);
    [~,Tvp,~]   = fLRpar4(Te,pe,RHe,col,hbl,z,dz); 
    [colcin,~]  = fcincape2(Tvp,Te,re,dz); 

end


