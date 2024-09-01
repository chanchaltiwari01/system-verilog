module and_gate(input a, b,
  output c );
  assign c = a & b;
endmodule
//////////////////////////interface//////////////////////////////////
interface intf();
  bit a,b;
  logic c;
endinterface
/////////////// transaction class ////////////////////////////////////////
class transaction ;
  randc bit a;
  randc bit b;
  logic c;
  
  function void display(string tag="");
    $display("%0s,a=%0b,b=%0b,c=%0b",tag,a,b,c);    
  endfunction
  
endclass
///////////////////// generator class  //////////////////////////////////
class generator;
  transaction tr;
  
  mailbox mbx;
  
  function new(mailbox mbx);
    this.mbx = mbx ;
  endfunction
  
  task main();
    repeat(5) begin
      tr = new();
      tr.randomize();
      mbx.put(tr);
      tr.display("generator");
      #1;
    end 
  endtask 
endclass 
///////////////////////////////////////driver class //////////////////////////////////
class driver;
  virtual intf vif ;
  mailbox mbx;
  
  function new(virtual intf vif , mailbox mbx);
    this.vif = vif;
    this.mbx = mbx;
  endfunction
  
  task main();
    repeat(5) begin
      transaction tr ;
      mbx.get(tr);
      vif.a <= tr.a;
      vif.b <= tr.b;
      tr.display("driver");
      #1;
    end 
  endtask
endclass
//////////////////////monitor class /////////////////////////////////////
class monitor ;
  virtual intf vif;
  mailbox mts ;
  
  function new(virtual intf vif , mailbox mts);
    this.mts =  mts;
    this.vif =  vif;
  endfunction
  
  task main();
    repeat(5) begin
      transaction tr =new();
      tr.a = vif.a;
      tr.b = vif.b;
      tr.c = vif.c;
      mts.put(tr);
      tr.display("monitor");
      #1;
    end 
  endtask 
endclass
////////////////////// scoreboard class //////////////////////////////////////////
class scoreboard;
  mailbox mts;
  
  function new(mailbox mts);
    this.mts =  mts ;
  endfunction
  
  task main();
    transaction tr ;
    repeat(5) begin
      mts.get(tr);
      if((tr.a & tr.b ) == ( tr. c)) begin
        $display("result is an expected ");
        end else begin 
        $error("wrong result ");
        end
      #1;
    end 
  endtask
endclass
///////////////////environment class /////////////////////////////////
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"


class enviroment ;
  generator gen ;
  driver dr;
  monitor mn;
  scoreboard sb;
  mailbox m1 ,m2 ;
 virtual intf vif ;
  function new(virtual intf vif);
    this.vif = vif ;
    m1 = new();
    m2 = new();
    gen = new(m1) ;
    dr = new(vif, m1);
    mn = new(vif , m2);
    sb = new(m2);
  endfunction 
  
  task run();
    fork 
      gen.main();
      dr.main();
      mn.main();
      sb.main();
    join
  endtask 
endclass
///////////////////////// test block ////////////////////////////////
`include "enviroment.sv"

program test(intf intp);
  enviroment env ;
  
  initial begin
    env =  new(intp);
    env.run();
  end 
endprogram 
////////////////////////// top module ////////////////////////////
`include "test.sv"
`include "interface.sv"
module top ;
  intf intp();
  
  test t1(intp);
  
  and_gate a1(.a(intp.a),
              .b(intp.b),
              .c(intp.c));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end 
endmodule
