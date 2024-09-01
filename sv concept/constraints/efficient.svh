class packet ;
   rand bit [31:0] addr_s , addr_f;
    constraint slow { addr_s % 4096 inside{[0:20],[4075:4095]};}
     constraint fast{ addr_f[11:0] inside{[0:20],[4075:4095]};}
  
 endclass 

 module test ;
   packet p;
  
   initial begin
     p = new();
     repeat(5)begin
       if(p.randomize()) 
        $display("addr_s :%0d , addr_f :%0d ", p.addr_s,p.addr_f);
       else 
         $error("not randomize");
     end 
   end
 endmodule 
