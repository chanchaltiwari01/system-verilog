module not_gate(
  input a ,
  output y );

  assign y = !a ;

endmodule 
//////////////////// interface ///////////////////////
interface intf;
  logic y ;
  logic a ;
endinterface 
//////////////////////// transaction class /////////////////////
class transaction;
  rand bit a ;
  logic y ;

  function void  display(input string inst = "TRAN" );
    $display("[%0s]: a=%0b , y=%0b",inst,a,y);
  endfunction 
endclass 
///////////////////////////////// generator class ////////////////////
class generator;
  transaction tr ;
  mailbox gtd ;

  function new(mailbox gtd );
    this.gtd = gtd ;
  endfunction 

  task run();
    repeat(5) begin
      tr = new();
      tr.randomize();
      gtd.put(tr);
      tr.display("GEN");
      #10;
    end 
  endtask 
endclass 
/////////////////////// driver class ///////////////////////////////////
class driver ;
  mailbox gtd ;
  virtual intf vif ;

  function new(virtual intf vif , mailbox gtd);
    this.vif = vif ;
    this.gtd = gtd ;
  endfunction 

  task run();
    repeat(5) begin
      transaction tr ;
      gtd.get(tr);
      vif.a <= tr.a;
      tr.y <= vif.y;
      tr.display("DRI");
      #10;
    end 
  endtask 
endclass 
/////////////////////////////// monitor class ////////////////////////////////////////
class monitor ;
  virtual intf vif ;
  mailbox mts ;
  transaction tr ;
  
  function new(virtual intf vif , mailbox mts );
    this.mts = mts ;
    this.vif = vif ;
  endfunction

  task run();
    repeat(5) begin
      #1;
      tr = new();
      tr.a = vif.a ;
      tr.y = vif.y ;
      mts.put(tr);
      tr.display("MON");
      #10;
    end 
  endtask 
endclass 
/////////////////// scoreboard class ///////////////////////////////
class scoreboard ;
  mailbox mts ;

  function new(mailbox mts);
    this.mts = mts ;
  endfunction 

  task run();
    repeat(5) begin
      transaction tr ;
      mts.get(tr);
      if(tr.y == ! tr.a ) begin
        $display("test is passed ");
      end else begin
        $display("test is passed ");
      end 
      #10;
    end 
  endtask 
endclass 
//////////////////////// environment class //////////////////////////////
class environment ;
  generator gen ;
  driver dri ;
  monitor mn ;
  scoreboard scb ;
  virtual intf vif ;
  mailbox mts , gtd ;

  function new(virtual intf vif );
    this.vif = vif ;
    mts = new();
    gtd = new();
    gen = new(gtd);
    dri = new(vif , gtd );
    mn = new(vif , mts );
    scb = new(mts);
  endfunction 

  task run();
    fork 
      gen.run();
      dri.run();
      mn.run();
      scb.run();
    join
  endtask
endclass 
//////////////////////////// test block ////////////////////////////////
program test ( intf intf_p );
  environment env ;

  initial begin
    env = new(intf_p);
    env.run();
  end 
endprogram 
//////////////////////////////////// top module  ///////////////////////////////////
module top ;
  intf intf_p();
  test t0(intf_p);

  not_gate dut(.a(intf_p.a),.y(intf_p.y));

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end 
endmodule 
