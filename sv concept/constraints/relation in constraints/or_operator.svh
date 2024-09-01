class packet ;
  rand int data ;
  constraint limit{
    ((data == 5 ) || ( data == 7 ) || (data == 9) ) ;}
  
  // there is a better way of providing such constraints
  // constraint limit{ data inside { 5,7,9};}
  
endclass 

module test;
  
  packet pkt ;
  
  initial begin 
    pkt = new();
    repeat(5) begin
      pkt.randomize();
      $display("data=%0d",pkt.data );
    #1;
    end 
  end 
endmodule 
