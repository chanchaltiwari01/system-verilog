class ch;
  bit id;
  
  function new(bit id);
    this.id = id;
  endfunction
  
  function void display();
    $display("id=%0d", id);
  endfunction
endclass

class pkt;
  bit [15:0] adder;
  bit [7:0] data;
  int status;
  ch c;

  function new();
    c = new(1);
    adder = 5+ ($urandom)%10 ;
    data = 10 + ($random)%5;
    status =10 + ($random)%8;
  endfunction
  
  function void copy(pkt pk);
    pk.adder = this.adder;
    pk.data = this.data;
    pk.status = this.status;
    pk.c = new(this.c.id);
  endfunction
  
  task display();
    $display("adder=%0d, data=%0d, status=%0d, id=%0d", adder, data, status, c.id);
  endtask
  
endclass

module top;
  pkt O, C;

  initial begin
    O =new();
    C=new();
    
     C.copy(O); // call manualy copy function 
    
    O.display();
    C.display();
    
      
    O.c.id = 0;
    O.display();
    C.display();
  end
endmodule
///////////////////////////////////////////////////////////////
class A;
  int j = 15;
endclass
 
class B;
  int i = 10;
  A a = new;
 
  function void copy(B obj_b); //In order to do a â€œdeepâ€ copy, a custom copy method must be created
    this.i = obj_b.i;
    this.a = new obj_b.a;
	this.a.j = obj_b.a.j;
  endfunction : copy
endclass
 
program main;
  
  B b1=new, b2=new;
 
  initial begin
    b2.copy(b1);
    b2.i = 20;
    b2.a.j = 30;
    $display("b1.i = %0d",b1.i);
    $display("b2.i = %0d",b2.i);
    $display("b1.a.j = %0d",b1.a.j);
    $display("b2.a.j = %0d",b2.a.j);  
  end
endprogram
///////////////////////////////////////////////////////////////
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
  
  function deep_copy(transaction tr);
    this.data = tr.data;
    this.id = tr.id;
    this.err_tr.err_data = tr.err_tr.err_data;
    this.err_tr.error = tr.err_tr.error;
  endfunction
endclass

module deep_copy_example;
  transaction tr1, tr2;
  
  initial begin
    tr1 = new();
    $display("Calling display method using tr1");
    tr1.display();
    
    tr2 = new();
    tr2.deep_copy(tr1);
    $display("After deep copy tr1 --> tr2");
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
