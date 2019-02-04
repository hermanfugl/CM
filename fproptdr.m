function [the,re]   = fproptdr(the,re,BL1,BL2,ww,nc,nr)
    
        % segments
        th1nr = mean(the(1:BL1,nr));
        th1nc = mean(the(1:BL1,nc));
        th2nc = mean(the(BL1+1:BL2,nc));
        th2nr = mean(the(BL1+1:BL2,nr));

        r1nr = mean(re(1:BL1,nr));
        r1nc = mean(re(1:BL1,nc));
        r2nc = mean(re(BL1+1:BL2,nc));
        r2nr = mean(re(BL1+1:BL2,nr));
        

        % prop the to the right
        the(1:BL1,nr)   = th1nc;
        the(BL1+1:BL2,nr) = th1nr;
        the(1:BL1,nc)   = th2nc;
        the(BL1+1:BL2,nc) = th2nr;
     
        % prop re to the right
        re(1:BL1,nr)    = r1nc;
        re(BL1+1:BL2,nr)  = r1nr;
        re(1:BL1,nc)    = r2nc;
        re(BL1+1:BL2,nc)  = r2nr;
        
        % cold wake
        th1ncw = the(1:BL1,nc);
        th1nrw = the(1:BL1,nr);
        re1ncw = re(1:BL1,nc);
        re1nrw = re(1:BL1,nr);
        
        the(1:BL1,nr)   = ww(1)*th1nrw + ww(2)*th1ncw;
        the(1:BL1,nc)   = ww(1)*th1ncw + ww(2)*th1nrw;
        re(1:BL1,nr)   = ww(1)*re1nrw + ww(2)*re1ncw;
        re(1:BL1,nc)   = ww(1)*re1ncw + ww(2)*re1nrw;
   

end

