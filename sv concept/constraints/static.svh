class ABC;
  rand bit [3:0] a;
  // Non-static constraints
  constraint c1 { a > 5; }  
  constraint c2 { a < 12; } 

endclass

module tb;
  initial begin
    ABC obj1 = new();
    ABC obj2 = new();
    repeat(10) begin 
      if (obj1.randomize() && obj2.randomize()) begin
        $display("obj1.a = %0d, obj2.a = %0d", obj1.a, obj2.a);
      end
      else begin
        $display("Randomization failed for one or both objects.");
      end
      #1; 
    end
  end
endmodule
//////////////////////////////////////////////////////////////////////////
class ABC;
  rand bit [3:0] a;
  
  // "c1" is non-static, but "c2" is static
  constraint c1 { a > 5 ; }
  static constraint c2 { a < 12; }
                 
endclass
                 
module top;
  
  initial begin
    ABC obj1 = new();
    ABC obj2 = new();
    
    // Turn off non-static constraint
    obj1.c1.constraint_mode(0) ;
    for (int i = 0; i < 5; i++) begin
      obj1.randomize;
      obj2.randomize;
      $display ("obj1.a = %0d, obj2.a = %0d", obj1.a, obj2.a);
    end
  end
endmodule

//////////////////////////////////////////////////////////////
class ABC;
  rand bit [3:0] a;
  
  // "c1" is non-static, but "c2" is static
  constraint c1 { a > 5 ; }
  static constraint c2 { a < 12; }
                 
endclass
                 
module top;
  
  initial begin
    ABC obj1 = new();
    ABC obj2 = new();
    
    // Turn off non-static constraint
    obj1.c2.constraint_mode(0) ;
    for (int i = 0; i < 5; i++) begin
      obj1.randomize;
      obj2.randomize;
      $display ("obj1.a = %0d, obj2.a = %0d", obj1.a, obj2.a);
    end
  end
endmodule
