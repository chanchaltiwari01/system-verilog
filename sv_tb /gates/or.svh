module or_gate(input a,
               input b,
               output c );
  
  assign c =  a | b ;
  
endmodule 
///////////////interface //////////////////////
interface intf;
  
  bit a , b ;
  logic c;
  
endinterface 
////////////////transaction class///////////////////////////////
class transaction ;
  randc bit a;
  randc bit b;
  logic c;
  
  function void display(string name="");
    $display("[%0s],a=%0b,b=%b,c=%b",name,a,b,c);
  endfunction 
  
endclass
////////////// generator class ///////////////////////////////////
`include "transaction.sv"
class generator ;
  transaction tr;
  mailbox mbx;
  
  function new (mailbox mbx);
    this.mbx=mbx;
  endfunction 
    
  task run();
    repeat(7) begin
      tr=new();
      tr.randomize();
      mbx.put(tr);
      tr.display("GEN");
      #1;
    end 
  endtask 
endclass
////////////// driver class ///////////////////////////////
class driver;
  virtual intf vif;
  mailbox mbx;
  
  function new(virtual intf vif , mailbox mbx);
    this.vif = vif;
    this.mbx = mbx ;
  endfunction 
  
  
  task run();
    repeat(7) begin
      transaction tr;
      mbx.get(tr);
      vif.a <= tr.a;
      vif.b <= tr.b;
      tr.display("DIR");
      #1;
    end 
  endtask 
endclass
////////////////// monitor class //////////////////////////////
class monitor;
  virtual intf vif;
  mailbox mts;
  
  function new(virtual intf vif ,mailbox mts);
    this.vif = vif ;
    this.mts = mts ;
  endfunction 
  
  task run();
    repeat(7) begin 
      transaction tr;
      tr = new();
      tr.a = vif.a;
      tr.b = vif.b;
      tr.c = vif.c;
      mts.put(tr);
      tr.display("MON");
      #1;
    end 
  endtask 
endclass
//////////////////////////// scoreboard class ////////////////////////////////
class scoreboard;
  mailbox mts;
  
  function new(mailbox mts);
    this.mts = mts;
  endfunction
  
  task run();
    transaction tr;
    repeat(7) begin
      mts.get(tr);
      if((tr.a | tr.b ) ==(tr.c)) begin
        tr.display("SCOREBOARD");
        $display("output is correct ");
      end else begin
          tr.display("SCOREBOARD");
        $display("output is worng ");
      end 
      #1;
    end 
  endtask 
endclass
///////////////////////////////// environment class ////////////////////////////
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment ;
  generator gen;
  driver dr;
  monitor mn;
  scoreboard sb;
  mailbox m1 ,m2;
  virtual intf vif ;
  
  function new(virtual intf vif);
    this.vif =  vif ;
    m1 = new();
    m2 = new();
    gen = new(m1);
    dr = new(vif , m1);
    mn = new(vif , m2);
    sb = new(m2);
  endfunction
  
  task run();
    fork
      gen.run();
      dr.run();
      mn.run();
      sb.run();
    join
  endtask 
endclass
//////////////////////////////////// test ///////////////////////////////////
`include "environment.sv"

program test(intf inp);
  environment env;
  
  initial begin
    env = new(inp);    
    env.run();
  end 
endprogram
//////////////// top module /////////////////////
`include "interface.sv"
`include "test.sv"

module top;
  intf inp();
  test t1(inp);
  
  or_gate o1(.a(inp.a),
           .b(inp.b),
           .c(inp.c));

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(1);
end 
endmodule
