module xor_gate(a, b, c);
  input logic a, b;
  output logic c;
  
  always_comb
    begin
    c = a ^ b;
  end 
endmodule
///////////////////// interface ////////////////////////////////////////
interface intf ;
  bit a ;
  bit b ;
  logic c ;
endinterface 
///////////////////////////// transaction class ///////////////////////
class transaction ;
  randc bit a;
  randc bit b;
  logic c;
  
  function void display(string name="");
    $display("[%0s]: a=%0b,b=%0b,c=%0b",name,a,b,c);
  endfunction
  
endclass
//////////////////////////////// generator class /////////////////////////////////
`include "transaction.sv"
class generator;
   rand transaction tr; 
  mailbox mbx;
  
  function new(mailbox mbx );
    this.mbx = mbx;
  endfunction
  
  task run();
    repeat(7) begin
      tr=new();
      tr.randomize();
      mbx.put(tr);
      tr.display("GENERATOR");
      #1;
    end 
  endtask 
endclass
////////////////////////////////////// driver class ////////////////////////////////////////
class driver;
  mailbox mbx ;
  virtual intf vif ;
  
  function new(virtual intf vif , mailbox mbx);
    this.mbx = mbx ;
    this.vif =  vif;
  endfunction
  
  task run();
    repeat(7) begin
      transaction tr ;
      mbx.get(tr);
      vif.a <= tr.a ;
      vif.b <= tr.b ;
      tr.display("DRIVER");
      #1;
    end 
  endtask
endclass 
////////////////////////// monitor class //////////////////////////////////////////
class monitor ;
  virtual intf vif ;
  mailbox mts ;
  
  function new(virtual intf vif , mailbox mts);
    this.mts =  mts ;
    this.vif = vif ;
  endfunction 
  
  task run();
    repeat(7) begin
      transaction tr ;
      tr=new();
      tr.a = vif.a;
      tr.b = vif.b;
      tr.c = vif.c;
      mts.put(tr);
      tr.display("MONITOR");
      #1;
    end 
  endtask 
endclass
///////////////////////////////// scoreboard class /////////////////////////////////////////////
class scoreboard;
  mailbox mts;
  
  function new(mailbox mts);
    this.mts = mts;
  endfunction 
  
  task run();
      transaction tr;
    repeat(7) begin
      mts.get(tr);
      if((tr.a ^ tr.b ) == (tr.c))begin
        tr.display("SCOREBOARD");
        $display("result is passed");
      end else begin
        tr.display("SCOREBOARD");
        $display("result is faild");
      end 
      #1;
    end 
  endtask 
endclass 
////////////////////////////////////////////environment class ///////////////////////////////
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment ;
  generator gen ;
  driver dv;
  monitor mn;
  scoreboard sb;
  mailbox m1 , m2 ;
  virtual intf vif ;
  
  function new (virtual intf vif );
    this.vif = vif;
    m1 = new();
    m2 = new();
    gen = new(m1);
    dv = new(vif , m1);
    mn = new(vif , m2);
    sb = new(m2);
  endfunction 
  
  task run();
    fork
    gen.run();
    dv.run();
    mn.run();
    sb.run();
    join
  endtask 
endclass   
///////////////////////////// test block ///////////////////////////////
`include "environment.sv"

program test(intf vit);
  environment env;
  initial begin
    env = new(vit);
    env.run();
  end 
endprogram 
/////////////////////////// top module //////////////////////////////
`include "interface.sv"
`include "xor_design.sv"
`include "test.sv"

module top;
  
  intf vit();
  test t1(vit);
  
  xor_gate x1(.a(vit.a),
              .b(vit.b),
              .c(vit.c));
  
  initial begin
    $dupmfile("dump.vcd");
    $dumpvars(1);
  end 
endmodule 
////////////////////////////// run.do ///////////////////////////////////////
# Set FPGA device for synthesis
# This step is necessary and command should be applied before any other actions
setup_fpga -tech VIRTEX7 -part xc7v585t

# Create and map 'work' library
hlib create ./work
hlib map work ./work

# Compile Verilog sources to 'work' library
hcom -lib work -sv design.sv

# Set synthesis output files (EDF and VM)
setoption output_edif "gate_xor.synth.edf"
setoption output_verilog "gate_xor.synth.vm"
setoption output_schematicsvg "diag.svg"
