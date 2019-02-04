function [the,re]   = fproptdlr(the,re,BL1,BL2,ww,nl,nc,nr)
    
 % segments
        th12nc = mean(the(1:BL2,nc));
        th1nl = mean(the(1:BL1,nl));
        th2nlr = mean([the(BL1+1:BL2,nl) ; the(BL1+1:BL2,nr)]);
        th1nr = mean(the(1:BL1,nr));
        
        r12nc = mean(re(1:BL2,nc));
        r1nl = mean(re(1:BL1,nl));
        r2nlr = mean([re(BL1+1:BL2,nl) ; re(BL1+1:BL2,nr)]);
        r1nr = mean(re(1:BL1,nr));

 % prop the to left and right
        the(1:BL1,nl)   = th12nc;
        the(BL1+1:BL2,nl) = th1nl;
        the(1:BL2,nc)   = th2nlr;
        the(1:BL1,nr)   = th12nc;
        the(BL1+1:BL2,nr) = th1nr;
        
  % prop re to left and right
        re(1:BL1,nl)    = r12nc;
        re(BL1+1:BL2,nl)  = r1nl;
        re(1:BL2,nc)    = r2nlr;
        re(1:BL1,nr)    = r12nc;
        re(BL1+1:BL2,nr)  = r1nr;
        
  % cold wake
        th1nlw = the(1:BL1,nl);
        th1ncw = the(1:BL1,nc);
        th1nrw = the(1:BL1,nr);
        re1nlw = re(1:BL1,nl);
        re1ncw = re(1:BL1,nc);
        re1nrw = re(1:BL1,nr);
        
        the(1:BL1,nl)   = ww(1)*th1nlw + ww(2)*th1ncw;
        the(1:BL1,nc)   = ww(1)*th1ncw + ww(2)*th1nlw;
        re(1:BL1,nl)   = ww(1)*re1nlw + ww(2)*re1ncw;
        re(1:BL1,nc)   = ww(1)*re1ncw + ww(2)*re1nlw;
        
        the(1:BL1,nr)   = ww(1)*th1nrw + ww(2)*th1ncw;
        the(1:BL1,nc)   = ww(1)*th1ncw + ww(2)*th1nrw;
        re(1:BL1,nr)   = ww(1)*re1nrw + ww(2)*re1ncw;
        re(1:BL1,nc)   = ww(1)*re1ncw + ww(2)*re1nrw;
   

end

