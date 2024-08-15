///////////////////////design.sv////////////////////////////////
module xnor_gate(a,b,c);
  input logic a,b;
  output logic c ;
  
  always_comb begin
    c =  a ~^ b ;
  end
endmodule

///////////////////interface.sv /////////////////////////////////////////
interface intf ;
  bit a;
  bit b;
  logic c ;
endinterface 

////////////////transaction.sv ////////////////////////////////
class transaction ;
  rand bit a;
  rand bit b;
  logic c;
  
  function void display(string name="");
    $display("[%0s]: a=%0b,b=%0b,c=%0b",name,a,b,c);
  endfunction 
  
endclass 

/////////////////generator.sv////////////////////////////////////////
`include "transaction.sv"

class generator ;
  mailbox mbx ;
  transaction tr;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    repeat(10) begin
      tr=new();
      tr.randomize;
      mbx.put(tr);
      tr.display("Generator");
      #1;
    end 
  endtask 
endclass
////////////////////////////driver.sv///////////////////////////////////
class driver ;
  virtual intf vif;
  mailbox mbx;
  
  function new(virtual intf vif , mailbox mbx );
    this.mbx =  mbx;
    this.vif = vif;
  endfunction 
  
  task run();
    repeat(10) begin
      transaction tr;
      mbx.get(tr);
      vif.a <= tr.a;
      vif.b <= tr.b;
      tr.display("Dirver");
      #1;
    end 
  endtask 
endclass 
/////////////////////monitor.sv///////////////////////
class monitor;
  virtual intf vif ;
  mailbox mts ;
  
  function new(virtual intf vif , mailbox mts );
    this.mts =  mts ;
    this.vif = vif ;
  endfunction 
  
  task run();
    repeat(10)begin
      transaction tr ;
      tr =  new();
      tr.a = vif.a;
      tr.b = vif.b;
      tr.c =  vif.c;
      mts.put(tr) ;
      tr.display("Monitor");
      #1;
    end
  endtask 
endclass 
/////////////////////////scoreboard.sv /////////////////////////
class scoreboard ;
  mailbox mts;
  
  function new(mailbox mts);
    this.mts = mts;
  endfunction 
  
  task run();
     transaction tr;
    repeat(10) begin     
      mts.get(tr);
      if((tr.a ~^ tr.b) == (tr.c)) begin
        $display("result is successfully passed ");
        tr.display("Scoreboard");
      end else begin
        $display("result is failed");
        tr.display("Scoreboard");
      end 
      #1;
    end 
  endtask 
endclass 
//////////////////////////////////environment.sv//////////////////
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  virtual intf vif ;
  mailbox m1 , m2 ;
  generator gen;
  driver dr;
  monitor mn;
  scoreboard sb;
  
  
  function new(virtual intf vif );
    this.vif = vif;
    m1 = new();
    m2 = new();
    
    gen = new(m1);
    dr = new(vif , m1);
    mn = new(vif , m2 );
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
///////////////////////////test.sv//////////////////////////////////////
`include "environment.sv"

program test(intf vit);
  environment env;
  initial begin
    env = new(vit);
    env.run();
  end 
endprogram 
////////////////top module .sv ///////////////////////////////////
`include "test.sv"
`include "interface.sv"

module top;
  
  intf vit();
  test t1(vit);
  
  xnor_gate dut(.a(vit.a),
                .b(vit.b),
                .c(vit.c));
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end 
endmodule 
