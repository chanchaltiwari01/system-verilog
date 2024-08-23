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
    adder=($urandom)%10;
    data=($urandom)%10;
    status=($urandom)%10;
  endfunction
  
  function void display();
    $display("adder=%0d, data=%0d,status=%0d,id=%0d", adder,data,status,c.id);
  endfunction
    
endclass

module top;
   
  pkt O,C;
  initial begin 
    O=new();
    C= new O; // copy to C handle 
    
//     $display(C.adder, C.data, C.status);
//     $display(O.adder, O.data, O.status);
    C.c.id=0;
    C.display;
    O.display;
    
    C.c.id=1;
    C.display();
    O.display();
   
  end 
endmodule 
///////////////////////////////////////////////////////////////////////////////////
class A;
  int j = 15;
endclass
 
class B;
  int i = 10;
  A a = new;
endclass
 
program main;
  B b1, b2;
  initial begin
    b1 = new;
    b2 = new b1; //Shallow copy of object b1 copies first level of properties to b2
    b2.i = 20;
    b2.a.j = 30; //Assigns 30 to variable “j” shared by both b1 & b2
    $display("b1.i = %0d",b1.i);
    $display("b2.i = %0d",b2.i);
    $display("b1.a.j = %0d",b1.a.j);
    $display("b2.a.j = %0d",b2.a.j); 
end
endprogram
/////////////////////////////////////////////////////////
class error_trans;
  bit [31:0] err_data;
  bit error;
  
  function new(bit [31:0] err_data, bit error);
    this.err_data = err_data;
    this.error = error;
  endfunction
endclass

class transaction;
  bit [31:0] data;
  int id;
  error_trans err_tr;
  
  function new();
    data = 100;
    id = 1;
    err_tr = new(32'hFFFF_FFFF, 1);
  endfunction
  
  function void display();
    $display("transaction: data = %0d, id = %0d", data, id);
    $display("error_trans: err_data = %0h, error = %0d\n", err_tr.err_data, err_tr.error);
  endfunction
endclass

module shallow_copy_example;
  transaction tr1, tr2;
  
  initial begin
    tr1 = new();
    $display("Calling display method using tr1");
    tr1.display();
    
    tr2 = new tr1;
    $display("After shallow copy tr1 --> tr2");
    $display("Calling display method using tr2");
    tr2.display();
    $display("--------------------------------");
    
    tr1.data = 200;
    tr1.id = 2;
    tr1.err_tr.err_data = 32'h1234;
    tr1.err_tr.error = 0;
    
    $display("Calling display method using tr1");
    tr1.display();
    $display("Calling display method using tr2");
    tr2.display();
    
  end
endmodule
