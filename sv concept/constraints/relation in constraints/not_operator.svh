class packet;
  rand int addrs ;
  
  constraint limit{ !(addrs inside{[1:5],[7:11]});}
  constraint addr{ addrs < 30 ; addrs > 0 ;}
  
endclass 

module test;
  packet pkt ;
  
  initial begin
    pkt = new();
    repeat(5)begin
      pkt.randomize();
      $display("addrs=%0d",pkt.addrs);
      #1;
    end 
  end
endmodule 
