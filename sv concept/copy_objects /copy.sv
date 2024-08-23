class ch;
  bit id;
  function new( bit id);
    this.id =id;
endfunction 
  function void display();
    $display("id=%0d",id);
  endfunction
  
endclass 
 

class pkt ;
 
  bit [15:0] adder;
  bit [7:0] data;
  int status ;
  ch c;
  function new();
    c=new(1);
    adder=10+($urandom)%10;
    data=5+($urandom)%15;
    status=15+($urandom)%8;
  endfunction
  
  function void display();
    $display("adder=%0d, data=%0d,status=%0d,id=%0d", adder,data,status,c.id);
  endfunction
    
endclass

module top;
   
  pkt O,C;
  initial begin 
    O=new();
    C = O; // copy to C handle 
    
//     $display(C.adder, C.data, C.status);
//     $display(O.adder, O.data, O.status);
    C.c.id=0;
    
    O.display;
    C.display;
    
    O.c.id=1;
    
    O.display;
    C.display;
   
  end 
endmodule
