//////////////////////final  block ////////////////////////////////////////

module final_example;
  initial begin
    $display("Inside initial block");
    #10;
    $display("Before calling $finish");
    $finish;
  end
  
  final begin
    $display("Inside final block at %0t", $time);
  end
endmodule
////////////////////////////////////////////////////////////////////

program tb ;
  reg a ,b ;
  
  initial begin
    $display("start initial block :[time=%0t]: a=%0d, b=%0d",$time,a,b);
    a=1;
    #5 ;
    b=1;
     $display("end initial block :[time=%0t]: a=%0d, b=%0d",$time,a,b);
  end 
 
  final begin
    $display("final block start at=%0t",$time);
    $display("final block end at=%0t",$time);
  end 
  
endprogram
