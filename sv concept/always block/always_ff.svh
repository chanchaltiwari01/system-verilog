module d_ff(input din, clk, rst ,
            output reg q );

  always_ff@(posedge clk)begin
    if(rst)
      q <= 0 ;
    else 
      q <= din ;
  end 
endmodule 

module test_d_ff;
  reg din,clk,rst;
  wire q ;

  d_ff dut(.din(din),.clk(clk),.rst(rst),.q(q));

  always #5 clk = ~clk;

  initial begin
    clk=0; rst=0; din=1;
    #10 rst=1; 
    #10 rst=0;
    #10 din=0 ;
    #10 $stop;
  end 
  initial begin
    $dumpfile("d_ff.vcd");
    $dumpvars(1);
    $monitor("[%0t]: clk=%0b,rst=%0b,din=%0b,q=%0b",$time,clk,rst,din,q);
  end 
  
endmodule

    
