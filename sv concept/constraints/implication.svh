class ABC;
  rand bit [2:0] mode;
  rand bit [3:0] len;
  
  constraint c_mode { mode == 2 -> len > 10;}

endclass

module tb;
  
  initial begin
    ABC abc = new;
    for (int i = 0; i < 10; i++) begin
      abc.randomize;
      $display ("mode=%0d len=%0d", abc.mode, abc. len) ;
    end
  end 
endmodule
//////////////////////////////////////////////////////////
class ABC;
  rand bit [2:0] mode;
  rand bit [3:0] len;
  
  constraint c_mode {
    if (mode == 2) { len > 10;}
      
      else{ len < 10 ;}
      }
    constraint c { mode inside{[5:7]};}

endclass

module tb;
  
  initial begin
    ABC abc = new;
    for (int i = 0; i < 10; i++) begin
      abc.randomize;
      $display ("mode=%0d len=%0d", abc.mode, abc. len) ;
    end
  end 
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////
class abc;
  rand bit [3:0] mode;
  rand bit mod_en;
  
  constraint c_mode {
    if (mode inside {[5:11]}) 
      mod_en == 1;
    else if (mode == 1)
      mod_en == 1;
    else
      mod_en == 0;
  }
endclass

module test;
  abc ab;
  
  initial begin
    ab = new();
    repeat (10) begin
      if (ab.randomize()) begin // Check if randomization was successful
        $display("mode=%0d, mod_en=%0d", ab.mode, ab.mod_en);
      end
      else begin
        $display("Randomization failed");
      end
      #1;
    end
  end
endmodule
 
