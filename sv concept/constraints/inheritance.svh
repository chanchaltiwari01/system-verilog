class base ;
  rand int data ;
  
  constraint limit1{ data > 0 ; data < 100;}
  
endclass

class drive extends base ;
  constraint limit2{ data > 50 ;}
endclass 

module test ;
  base b;
  drive d ;
  
  initial begin
    b = new();
    d = new();
    repeat(5) begin
      b.randomize();
      d.randomize();
      $display("base data=%0d, drive data =%0d",b.data,d.data);
      #1;
    end 
  end
endmodule 
