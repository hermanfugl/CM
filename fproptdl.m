function [the,re]   = fproptdl(the,re,BL1,BL2,ww,nl,nc)
    
        % segments
        th1nl = mean(the(1:BL1,nl));
        th1nc = mean(the(1:BL1,nc));
        th2nc = mean(the(BL1+1:BL2,nc));
        th2nl = mean(the(BL1+1:BL2,nl));

        r1nl = mean(re(1:BL1,nl));
        r1nc = mean(re(1:BL1,nc));
        r2nc = mean(re(BL1+1:BL2,nc));
        r2nl = mean(re(BL1+1:BL2,nl));

        
        % prop the to the left
        the(1:BL1,nl)   = th1nc;
        the(BL1+1:BL2,nl) = th1nl;
        the(1:BL1,nc)   = th2nc;
        the(BL1+1:BL2,nc) = th2nl;  
     
        % prop re to the left
        re(1:BL1,nl)    = r1nc;
        re(BL1+1:BL2,nl)  = r1nl;
        re(1:BL1,nc)    = r2nc;
        re(BL1+1:BL2,nc)  = r2nl;  
        
        % cold wake
        th1nlw = the(1:BL1,nl);
        th1ncw = the(1:BL1,nc);
        re1nlw = re(1:BL1,nl);
        re1ncw = re(1:BL1,nc);
        
        the(1:BL1,nl)   = ww(1)*th1nlw + ww(2)*th1ncw;
        the(1:BL1,nc)   = ww(1)*th1ncw + ww(2)*th1nlw;
        re(1:BL1,nl)   = ww(1)*re1nlw + ww(2)*re1ncw;
        re(1:BL1,nc)   = ww(1)*re1ncw + ww(2)*re1nlw;
   

end

