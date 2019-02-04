function [then,Ten,ren] = fmixbl(then,ren,hbl,Mbl1,Mbl2,pe,z)
     % [the(:,n),Te(:,n),re(:,n)] (the(:,n),re(:,n))

%% weighted average
     w = [.9998 .0002];
     
     tmp = abs(z-hbl);
     bl2 = find(tmp==min(tmp));
     tmp = abs(z-hbl/2);
     bl1 = find(tmp==min(tmp));
     
        thbl1 = mean(then(1:bl1));
        thbl2 = mean(then(bl1+1:bl2));
        rebl1 = mean(ren(1:bl1));
        rebl2 = mean(ren(bl1+1:bl2));
        
        then(1:bl1)     = (Mbl1*w(1)*thbl1 + Mbl2*w(2)*thbl2)/(w(1)*Mbl1+w(2)*Mbl2); 
        then(bl1+1:bl2) = (Mbl2*w(1)*thbl2 + Mbl1*w(2)*thbl1)/(w(1)*Mbl2+w(2)*Mbl1);
        ren(1:bl1)      = (Mbl1*w(1)*rebl1 + Mbl2*w(2)*rebl2)/(w(1)*Mbl1+w(2)*Mbl2);
        ren(bl1+1:bl2)  = (Mbl2*w(1)*rebl2 + Mbl1*w(2)*rebl1)/(w(1)*Mbl2+w(2)*Mbl1);
        
%         disp(mean(then(1:bl2)))
        
%% Ambient absolute temperature
Rsd = 287; % J/kg/K
cpd = 1003.5; % J/kg/K
Ten = then.*(pe(1)./pe).^(-Rsd/cpd);
end