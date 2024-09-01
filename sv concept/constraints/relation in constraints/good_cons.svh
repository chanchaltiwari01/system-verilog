class good_cons ;
  rand bit [7:0] low, med, high ;
  
  constraint good{ low < med ; med < high;}
  
endclass 

module test ;
  good_cons gc ;
  
  initial begin
    gc = new();
    repeat(5) begin
      gc.randomize();
      $display("low=%0d, med=%0d, high=%0d", gc.low,gc.med,gc.high);
    end 
  end
endmodule 
