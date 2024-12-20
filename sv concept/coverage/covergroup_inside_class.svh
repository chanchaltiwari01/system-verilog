class my_class;
    // Class members
  rand  bit [3:0] m_x;
   rand int m_y;
   randc bit m_z;

    // Embedded covergroup
    covergroup cov1 @(m_z); // Added correct sensitivity list
       //option.per_instance=1 ;
        coverpoint m_x; 
        coverpoint m_y; 
    endgroup

    // Constructor
    function new();
        cov1 = new;
    endfunction
endclass

module testbench;
    // Instantiate class
    my_class cl ;

   
    initial begin
        // Create object
        cl = new();

        // Drive random values to class members
      repeat (100) begin
        cl.randomize();
        cl.cov1.sample();
            // Trigger the covergroup
        #1; // Wait for the next simulation tick
        end
      if(cl.cov1.get_coverage())
        $display("*** Functional Coverage = %.2f%% ***", cl.cov1.get_coverage());
        else $display("error");

        // Finish simulation
        $finish;
    end
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////
class c1;
 rand bit [7:0] x ;
  bit clk = 1'b0;;
  
  covergroup cv (input int arg ) @(posedge clk );
    option.at_least = arg;
    coverpoint x ;
  endgroup
  
  function new(int p1) ;
    cv = new(p1);
  endfunction 
  
endclass 

module tb ;
   c1 obj ;
  
  
  initial begin
     obj = new(4);
    repeat(20)
      begin
        obj.randomize();
        obj.cv.sample();
        $display("value of x =%0d  ", obj.x);
        @(posedge obj.clk) ;
      end 
    $display("#### Functional coverage = %.2f%% ###",obj.cv.get_coverage());
    #10 $stop ;
  end 
  
  always #5 obj.clk = ~obj.clk ;
  
endmodule 
/////////////////////////////////////////////////////////////////////////////////
class define_double_coverage;
    // Randomized members
    rand bit [3:0] m_x;
    rand bit m_z;
    randc bit m_e;
    bit clk = 1'b0;

    // Covergroups
    covergroup cv1 @(posedge clk); 
        coverpoint m_x; 
    endgroup

  covergroup cv2 @(m_e); 
        coverpoint m_z; 
    endgroup

    // Constructor
    function new();
        cv1 = new();
        cv2 = new();
    endfunction
endclass

module test;
    // Declare an instance of the class
    define_double_coverage ddc;

    initial begin
        // Instantiate the class
        ddc = new();

        // Repeat block to generate random values and sample covergroups
        repeat (10) begin
            ddc.randomize();
            ddc.cv1.sample(); // Explicit sampling for cv1
            ddc.cv2.sample(); // Explicit sampling for cv2
            @(posedge ddc.clk);
        end

        $finish; // End simulation after the loop
    end

    // Generate a clock
    always #5 ddc.clk = ~ddc.clk;
  
endmodule
