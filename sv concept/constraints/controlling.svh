class packet ;
  rand int lenght ;
  
  constraint c_s{lenght inside {[1:31]};}
  constraint c_l{lenght inside {[1000:1023]};}
  
endclass

module test;
  packet pkt;
  
  initial begin
    pkt = new();
    pkt.c_s.constraint_mode(0);
    assert(pkt.randomize())
      $display("length = %0d ", pkt.lenght);
    pkt.constraint_mode(0);
    $display("length = %0d ", pkt.lenght);
    pkt.c_s.constraint_mode(1);
    assert(pkt.randomize());
    $display("length = %0d ", pkt.lenght);
  end 
  
endmodule 
