/////////////////////////// without interface /////////////////////

module adder(
  input bit clk,
  input logic[3:0] a ,b,
  output logic[4:0] sum);
  
  always@(posedge clk )
    begin
      sum = a + b;
    end 
endmodule

program tb(
  input bit clk ,
  input logic [4:0] sum ,
  output reg [3:0] a ,b );
  
  initial begin
    $monitor("a=%0d, b=%0d, sum=%0d",a,b,sum);
    forever begin
      a=$random;
      b=$random ;
      #10;
    end 
  end
endprogram 

module top;
  bit clk = 1'b0;
  logic [3:0] a,b;
  logic [4:0] sum;
  
  always #5 clk = ~clk ;
  
  adder a0(.*);
  tb t0(.*);
  
  initial begin
    $dumpfile("adder.vcd");
    $dumpvars(1);
    #50 $finish;
  end 
endmodule 
//////////////////////////////////////with interface  ////////////////////////////////
interface intf (input bit clk);
  logic [3:0] a , b;
  logic [4:0] sum;
endinterface 

module adder(intf inf);
  
  always@(posedge inf.clk) begin
    inf.sum = inf.a + inf.b ;
    end 
endmodule

program tb(intf inf);
  
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
  
  intf inf(clk);
  
  adder a0(inf);
  tb t0(inf);
  
    initial begin
    $dumpfile("adder.vcd");
    $dumpvars(1);
    #50 $finish;
  end 
  
endmodule 
    
