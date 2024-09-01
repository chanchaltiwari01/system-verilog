class packet ;
  rand int data ;
  
  constraint con { data dist {0:=40 , [1:4] :=60 , [6:7] :=20};}
  // total weight = 40 + 60 + 60 + 60 + 60 + 20 + 20 = 320 .
  // data = 0 weight = 40/320 = 12.5% .
  
  
endclass 

module test ;
  packet pkt ;
  initial begin
    pkt = new();
    repeat(10) begin
      pkt.randomize();
      $display("data = %0d",pkt.data);
      #1;
    end 
  end 
endmodule 
