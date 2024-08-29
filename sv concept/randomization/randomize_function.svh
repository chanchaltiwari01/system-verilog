
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
