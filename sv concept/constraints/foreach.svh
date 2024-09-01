////////////////////////////////////////////////////////////////////////
class ABC;
    rand bit [3:0] array [5]; 

    // This constraint sets each element of the array to its index value
    constraint c_array {
      foreach (array[i]) {
        array[i] == i; }
    }
endclass

module tb;
    initial begin
        ABC abc = new(); 
        if (abc.randomize()) begin 
            $display("array = %p", abc.array); 
        end else begin
            $display("Randomization failed");
        end
    end
endmodule
/////////////////////////////////////////////////////////////////////////////////
class ABC;
    rand bit [3:0] darray[]; 
    rand bit [3:0] queue[$]; 

   
    constraint c_gsize { queue.size() == 5; }

   
    constraint c_array {
      foreach (darray[i]) darray[i] == i;     
        foreach (queue[i]) queue[i] == i + 1; 
    }

   
    function new();
        darray = new[5]; 
    endfunction
endclass

module tb;
    initial begin
        ABC abc = new();
        if (abc.randomize()) begin 
            $display("darray = %p, queue = %p", abc.darray, abc.queue); 
        end else begin
            $display("Randomization failed");
        end
    end
endmodule

      
