class bad_cons ;
  rand bit [7:0] low, med, high ;
  
  constraint bad{ low < med < high;}
  
endclass 

module test ;
  bad_cons bc ;
  
  initial begin
    bc = new();
    repeat(5) begin
      bc.randomize();
      $display("low=%0d, med=%0d, high=%0d", bc.low,bc.med,bc.high);
    end 
  end
endmodule 
