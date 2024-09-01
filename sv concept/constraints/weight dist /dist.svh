class packet ;
  rand int data ;
  
  constraint con { data dist {0:=40 , [1:4] :=60 , [6:7] :=20};}
  // total weight = 40 + 60 + 60 + 60 + 60 + 20 + 20 = 320 .
  // data = 0 weight = 40/320 = 12.5% .
  
  
endclass 

module test ;
  int count ;
  packet pkt ;
  initial begin
    pkt = new();
    repeat(10) begin
      pkt.randomize();
      $display("data = %0d",pkt.data);
      if(pkt.data == 6) begin
        count = count + 1;
        $display(count);
        end 
      #1;
    end 
  end 
endmodule 
//////////////////////////////////////////////////////////////////////////
class packet ;
  rand int data ;
  constraint con { data dist{0:/20 , [1:3]:/60, [6:7]:/20};}
  // total weight = 20 + 60 + 40 = 100.
  // data = 0  weight = 20/100 = 20%;
  // data = 1 weight = 20/100 = 20%.
  // data = 6 weight = 10/100 = 10%
  
endclass 

module test;
  
  packet pkt ;
  
  initial begin
    pkt = new();
    repeat(10) begin
      pkt.randomize();
      $display("data=%0d",pkt.data);
      #1;
    end
  end
endmodule 
