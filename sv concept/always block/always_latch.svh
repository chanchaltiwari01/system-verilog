module d_latch(input en , din ,
               output reg q );

  always_latch begin
    if(en)
      q <= din ;
    else
      q <= q ;
  end 
endmodule 

module test_d_latch;
  reg en ,din ;
  wire q ;


  d_latch dut(.din(din),.en(en),.q(q));

  always #5 en = ~en ;

  initial begin
    en =0 ; din=0;
    #10 din =1;
    #10 din=0 ;
    #10 din=1;
   #10  $finish;
  end 
initial begin
  $monitor("en=%0b,din=%0b,q=%0b",en,din,q);
end 

endmodule 
