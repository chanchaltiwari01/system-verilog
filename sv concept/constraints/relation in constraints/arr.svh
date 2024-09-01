class packet ;
  int arr [] = '{6,7,5,3,18,13,19} ;
  rand int addrs ;
  
  constraint limit {addrs inside{arr};}
  
endclass

module test ;
  packet pkt ;
  
  initial begin
    pkt = new();
    $display("arr=%0p",pkt.arr);
    repeat(5) begin
      pkt.randomize();
      $display("addrs=%0d",pkt.addrs);
      #1;
    end
  end
endmodule 
