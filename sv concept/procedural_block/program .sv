module dut_example (output bit [3:0] out);
  
  initial begin
    out <= 2;
  end
endmodule

module tb_mod_top;
  wire [3:0] out;
  
  dut_example DUT(out);
  initial begin
    if(out == 2)
      $display("Design assigned out is 2");
    else
      $display("Design assigned out = %0d", out);
  end
endmodule

program tb_pro(input [3:0] out);
  initial begin
    if(out == 2)
      $display("Design assigned out is 2");
    else
      $display("Design assigned out = %0d", out);
  end
endprogram

module tb_mod_top;
  wire [3:0] out;
  
  dut_example DUT(out);
  tb_pro tb(out);
endmodule
////////////////////////////////////////////////////////////////////
module tff(q,clk,t);
  input clk,t;
  output reg q=1'b0;
  
  always@(posedge clk)begin
    if(t)
      q <= ~q;
    else 
      q <= q;
  end 
endmodule

module test_tff;
  reg clk=1'b0,t=1'b1;
  wire q;
  
  always #5 clk=~clk;
  
  tff u0(q,clk,t);
  always@(posedge clk)
    $display($time,"q=%0b",q);
  initial begin 
    #50 $stop;
  end 
  
endmodule
//////////////////////////////////////

module tff(q,clk,t);
  input clk,t;
  output reg q=1'b0;
  
  always@(posedge clk)begin
    if(t)
      q <= ~q;
    else 
      q <= q;
  end 
endmodule

program tb(output reg t ,input  clk, input q  );
  
  initial begin
    
    forever@(posedge clk)begin
      $display($time,"Q=%0d",q);
    end
  end 
  
  initial t = 1;
  
endprogram 

module test_tff;
  reg clk=1'b0,t;
  wire q;
  
  always #5 clk=~clk;
  
  tff u0(q,clk,t);
  tb t0(t,clk,q);
  
  initial begin 
    #50 $stop;
  end 
  
endmodule
/////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------
//design code
//-------------------------------------------------------------------------
module design_ex(output bit [7:0] addr);
  initial begin
    addr <= 10;
  end   
endmodule

//-------------------------------------------------------------------------
//testbench
//-------------------------------------------------------------------------
module testbench(input bit [7:0] addr);
  initial begin
    $display("\t Addr = %0d",addr);
  end
endmodule

//-------------------------------------------------------------------------
//testbench top
//-------------------------------------------------------------------------
module tbench_top;
  wire [7:0] addr;

  //design instance
  design_ex dut(addr);

  //testbench instance
  testbench test(addr);
endmodule

//-------------------------------------------------------------------------
//design code
//-------------------------------------------------------------------------
module design_ex(output bit [7:0] addr);
  initial begin
    addr <= 10;
  end   
endmodule

//-------------------------------------------------------------------------
//testbench
//-------------------------------------------------------------------------

program testbench(input bit [7:0] addr);
  initial begin
    $display("\t Addr = %0d",addr);
  end
endprogram

//-------------------------------------------------------------------------
//testbench top
//-------------------------------------------------------------------------
module tbench_top;
  wire [7:0] addr;

  //design instance
  design_ex dut(addr);
  //testbench instance
  testbench test(addr);
  
endmodule
