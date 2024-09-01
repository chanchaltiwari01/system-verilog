module tb;
  bit [3:0] m_data;
  bit flag; // Correctly declare flag
  
  initial begin
    for (int i = 0; i < 5; i++) begin
      m_data = $random;
      // Used in a ternary operator
      flag = m_data inside {[4:9]} ? 1 : 0;
      // Used with "if-else" operators
      if (m_data inside {[4:9]})
        $display ("m_data=%0d INSIDE [4:9], flag=%0d", m_data, flag);
      else
        $display ("m_data=%0d outside [4:9], flag=%0d", m_data, flag);
    end
  end
endmodule
////////////////////////////////////////////////////
class ABC;
  rand bit [3:0] m_var; // Fixed bit width and syntax
  
  // Constrain m_var to be either 3, 4, 5, 6, or 7
  constraint c_var {
    m_var inside {[3:7]};
  }
endclass

module to;
  initial begin
    ABC abc = new;
    repeat (5) begin
      if (abc.randomize()) begin // Check if randomization was successful
        $display("abc.m_var = %0d", abc.m_var);
      end
      else begin
        $display("Randomization failed");
      end
    end
  end
endmodule
/////////////////////////////////////////////////////////////////////////////////////
//To limit address in range from 1 to 5, 7 to 11, and to a set of value 15, 12, 25.
class packet;
  rand int addrs ;
  
  constraint limit{ addrs inside{[1:5],[7:11],15,18,25};}
  
endclass 

module test;
  packet pkt ;
  
  initial begin
    pkt = new();
    repeat(5)begin
      pkt.randomize();
      $display("addrs=%0d",pkt.addrs);
      #1;
    end 
  end
endmodule 
