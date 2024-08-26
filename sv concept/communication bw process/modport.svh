///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////               modport           ////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

interface intf (input bit clk);
  logic [3:0] a , b;
  logic [4:0] sum;
  
  modport dut(input clk,a,b,output sum);
  modport tb(input sum,clk,output a,b);
  
endinterface 

module adder(intf.dut inf);
  
  always@(posedge inf.clk) begin
    inf.sum = inf.a + inf.b ;
    end 
endmodule

program tb(intf.tb inf);
  
  initial begin
    $monitor("a=%0d,b=%0d,sum=%0d",inf.a,inf.b,inf.sum);
    
    forever begin
      inf.a <= $random ;
      inf.b <= $random ;
      #10 ;
    end 
  end 
endprogram 

module top;
  bit clk = 1'b0;
  
  always #5 clk = ~clk ;
  
  intf inf(.*);  
  adder a0(.*);
  tb t0(.*);
  
    initial begin
    $dumpfile("adder.vcd");
    $dumpvars(1);
    #50 $finish;
  end 
  
endmodule 
    
