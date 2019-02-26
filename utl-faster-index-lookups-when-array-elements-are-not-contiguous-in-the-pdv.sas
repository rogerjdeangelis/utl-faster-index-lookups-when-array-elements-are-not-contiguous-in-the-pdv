Problem: Generate random numbers in x1-x10, y1-y10 with and without permanent arrays   

Faster index lookups when array elements are not contiguous in the pdv 
                                                                                                                    
  Two Solutions                                                                                                        
                                                                                                                       
          Seconds                                                                                                      
                                                                                                                       
        1. 14.7 Using permanent Arrays                                                                                 
        2.  9.8 Using do_over or 40 assigment statements                                                               
                                                                                                                       
                                                                                                                       
This only appears to work when array elements are scrambled across the pdv(poor locality of reference).                
Ypu may need to tst.                                                                                                   
                                                                                                                       
When using an array SAS has to order the scrabled elements into adjacent slots                                         
                                                                                                                       
                                                                                                                       
macros                                                                                                                 
https://tinyurl.com/y9nfugth                                                                                           
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories                             
                                                                                                                       
                                                                                                                       
INPUT                                                                                                                  
=====                                                                                                                  
                                                                                                                       
%array(xs,values=x1-x10);                                                                                              
%array(ys,values=y1-y10);                                                                                              
%array(zs,values=z1-z10);                                                                                              
                                                                                                                       
data have;                                                                                                             
 retain z1 x10 y5 z2 x9 y4 z3 x8 y3 z4 x7 y2;                                                                          
 do rec=1 to 10000000;                                                                                                 
    %do_over(ys zs xs,phrase=%str(?ys=1;?xs=2;?zs=3;));                                                                
    output;                                                                                                            
 end;                                                                                                                  
run;quit;                                                                                                              
                                                                                                                       
* note the scrabled elements;                                                                                          
                                                                                                                       
WORK.HAVE total obs=10,000,000                                                                                         
                                                                                                                       
 Z1 X10 Y5 Z2 X9 Y4 Z3 X8 Y3 Z4 X7 Y2 Y1 X1 X2 X3 X4 X5 Z5 Y6 X6 Z6 Y7 Z7 Y8 Z8 Y9 Z9 Y10 Z10                          
                                                                                                                       
 3  2   1  3  2  1  3  2  1  3  2  1  1  2  2  2  2  2  3  1  2  3  1  3  1  3  1  3   1   3                           
 3  2   1  3  2  1  3  2  1  3  2  1  1  2  2  2  2  2  3  1  2  3  1  3  1  3  1  3   1   3                           
 3  2   1  3  2  1  3  2  1  3  2  1  1  2  2  2  2  2  3  1  2  3  1  3  1  3  1  3   1   3                           
 3  2   1  3  2  1  3  2  1  3  2  1  1  2  2  2  2  2  3  1  2  3  1  3  1  3  1  3   1   3                           
                                                                                                                       
                                                                                                                       
SOLUTIONS                                                                                                              
=========                                                                                                              
                                                                                                                       
-------------------------------                                                                                        
1. 14.7 Seconds Using permanent Arrays                                                                                 
-------------------------------                                                                                        
                                                                                                                       
data want;                                                                                                             
  set have;                                                                                                            
  array xs[10] x1-x10 ;                                                                                                
  array ys[10] y1-y10;                                                                                                 
  do idx=1 to 10;                                                                                                      
     xs[idx]=uniform(1234);                                                                                            
     ys[idx]=xs[idx];                                                                                                  
     xs[idx]=sum(xs[idx],ys[idx]);                                                                                     
     ys[idx]=sum(ys[idx],ys[idx]);                                                                                     
  end;                                                                                                                 
  drop z: idx;                                                                                                         
run;quit;                                                                                                              
                                                                                                                       
NOTE: There were 10000000 observations read from the data set WORK.HAVE.                                               
NOTE: The data set WORK.WANT has 10000000 observations and 21 variables.                                               
NOTE: DATA statement used (Total process time):                                                                        
      real time           14.78 seconds                                                                                
      cpu time            14.57 seconds                                                                                
                                                                                                                       
                                                                                                                       
------------------------------------------------                                                                       
2.  9.8 Using do_over or 20 assigment statements                                                                       
-------------------------------------------------                                                                      
                                                                                                                       
                                                                                                                       
data want_mac;                                                                                                         
  set have;                                                                                                            
    %do_over(xs ys,phrase=%str(                                                                                        
      ?xs=uniform(1234);                                                                                               
      ?ys=?xs;                                                                                                         
      ?xs=sum(?xs,?ys);                                                                                                
      ?ys=sum(?ys,?ys);                                                                                                
    ));                                                                                                                
  drop z:;                                                                                                             
run;quit;                                                                                                              
                                                                                                                       
                                                                                                                       
NOTE: There were 10000000 observations read from the data set WORK.HAVE.                                               
NOTE: The data set WORK.WANT_MAC has 10000000 observations and 21 variables.                                           
NOTE: DATA statement used (Total process time):                                                                        
      real time           9.84 seconds                                                                                 
      cpu time            9.81 seconds                                                                                 
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                       
