class sample ;
  rand int num;
  constraint num_cons{num > 10 ; num < 100 ;} 
endclass 

class sample1;
  randc bit [7:0] num ;
  constraint c1{num >10 ;}
  constraint c2{num <100 ; } 
endclass

class sample2 ;
  rand bit[7:0] num ;
  constraint c{num < max ; num > min ; } 
  int min , max ;
  
endclass

class sample3;
  rand bit [7:0] num ;
  constraint c{num > min ;}
  constraint c1{num < max ; } 
  int max , min ;
endclass 

module tb ;
  sample sm ;
  
  initial begin
    sm = new();
    sm.randomize();
    $display("num =%0d", sm.num);
  end
endmodule 
