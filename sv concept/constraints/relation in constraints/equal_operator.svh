class packet ;
  rand int addrs;
  rand int length;
  
  constraint limit{ length == addrs*5;}
  constraint addr{ addrs <25 ; addrs > 5 ;}
  
endclass 

module test;
  packet pkt ;
  
  initial begin
    pkt = new();
    repeat(2)begin
      pkt.randomize();
      $display("addrs=%0d,length=%0d",pkt.addrs,pkt.length);
      #1;
    end 
  end
endmodule 
