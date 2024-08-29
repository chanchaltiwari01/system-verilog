
class packet;
  rand  bit [2:0] addr1;
  randc bit [2:0] addr2; 
endclass

module rand_methods;
  initial begin
    packet pkt;
    pkt = new();
    repeat(8) begin
      pkt.randomize();
      $display("\taddr1 = %0d \t addr2 = %0d",pkt.addr1,pkt.addr2);
    end
  end
endmodule
/////////////////////////////////////////////////////////////////////
class pkt ;
  rand bit [1:0] a;
  randc bit [1:0] b;
endclass

module rand_method;
  
  pkt p;
  initial begin
    p=new();
    
    repeat(5) begin
      p.randomize();
      $display("a=%0p,\t b=%0p ",p.a,p.b); // one value of b repeat 
     end 
  end 
endmodule
////////RANDOMIZE() FUNCTION //////////////////////////

module test;
  bit[3:0] num1,num2;
  
   initial begin
     repeat(10) begin
       if(randomize(num1,num2))
         $display("randomization is successful ..... num=%0d, num=%0d",num1,num2);
       else 
         $display("randomization is fail");
       #2;
     end 
   end
endmodule 

/////////randomize function with constraint ///////////////////////

module test;
  integer num;
  
 initial begin
   repeat(10) begin
     if(randomize(num) with {num >10 ; num<20 ;})
       $display("randomization successful ..... num=%0d",num);
    else
      $display("randomization is fail ..........");
   #2;
   end
 end
endmodule 
//////////////////////pre and post randomize function ////////////////////////////////////////////////
class packet ;
  rand bit [3:0] data ;
  
  function void pre_randomize();
    $display("pre_randomize : data=%0d",data);
  endfunction 
  
  function void post_randomize();
    $display("post_randomize: data=%0d",data);
  endfunction
  
endclass

module test ;
  
  packet pkt ;
  
  initial begin
    pkt = new();
    repeat(5) begin
      pkt.randomize();
      #1;
    end 
  end
endmodule 
      
    
