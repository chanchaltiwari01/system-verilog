class Item;
  rand bit [7:0] id;
  
  // Constraint to restrict id values to be less than 25
  constraint c_id { id < 25; }
endclass

module tb;
  initial begin
    Item itm = new();
    
    // Randomize with in-line constraint
    if (itm.randomize() with { id == 10; }) begin
      $display("Item Id = %0d", itm.id);
    end
    else begin
      $display("Randomization failed or id did not meet the constraint.");
    end
  end
endmodule
///////////////////////////////////////////////////////////////
class Item;
  rand bit [7:0] id; // Correct bit-width syntax

  // Constraint to set id to 25
  constraint c_id { id == 25; }
endclass

module tb;
  initial begin
    Item itm = new(); // Correct instantiation
    
    // Randomize with an in-line constraint
    if (!itm.randomize() with { id < 10; }) begin 
      $display("Randomization failed"); 
    end
    else begin
      $display("Item Id = %0d", itm.id);
    end
  end
endmodule
