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
