class constraints;
  rand bit [15:0] a,b,c;
  
  constraint cp{a < c ; b == a ; c < 25 ; b > 10 ;}
  
endclass

module test ;
  
  constraints cont ;
  
  initial begin
    cont = new();
    repeat(5) begin
      cont.randomize();
      $display("a :%0d, b :%0d, c :%0d",cont.a , cont.b, cont.c);
      #1;
    end 
  end
endmodule
