class sample ;
  rand bit [2:0] addr;
  rand bit [7:0] data ;
  
  constraint addr_limit{ addr > 'd4 ; addr < 'd7;}
  
  constraint data_limit{ data > 'd10 ; data < 'd50;}
  
endclass 

module test ;
  sample sm;
  
  initial begin
    sm=new();
    repeat(5) begin
      sm.randomize();
      $display("addr=%0d,data=%0d",sm.addr,sm.data);
    #1;
    end 
  end 
endmodule
  
