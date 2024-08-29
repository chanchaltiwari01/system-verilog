
//////////verilog  constrained rondomization ////////////////
//random in range 

module test;
  integer a,b,c;
  initial begin
    repeat(20) begin
      a=$random % 10 ; // -9 to 9 random range 
      b={$random}%10; // 0 to 9 random range 
      c=$unsigned($random) %15; // 0 to 14 range 
      $display("a=%0d,\t b=%0d,\t c=%0d",a,b,c);
    end 
  end
endmodule 


/////////////////////////////////////////////////////////////
module test;
  integer a,b,c;
  
  initial begin
    repeat(20) begin
      a= 10+{$random}%15; // 10 to 25 positive random  range 
      b= -5-{$random}%15; //-5 to -19  negitive random range 
      c= -5 +{$random}%15; // -5 to 9 mix random range 
      $display("a=%0d,\t b=%0d,\t c=%0d",a,b,c);
    end 
  end
endmodule 

/////////////$dist_uniform/////////////////////
module test ;
  integer num1,num2,num3;
  integer
  
  seed1=1,seed2=0;
  
  initial begin
    repeat(20) begin
      num1= $dist_uniform(seed1,5,15);
      num2= $dist_uniform(seed2,-5,10);
      $display("num=%0d,num2=%0d,seed=%0d\t %0d ",num1,num2,seed1,seed2);
      #2;
    end 
  end
endmodule 

/////////SV CONSTRAINED RANDOMIZATION ///////////////////////////
//////////$urandom////////////////////////////////////////
module test ;
  integer num1 ,num2;
  
  initial begin
    repeat(20) begin
    num1 = $urandom; 
    num2 = $urandom;
      $display("num1=%0d,num2=%0d,",num1,num2);
      #2;
    end 
  end
endmodule 
  

/////////////////$urandom_range//////////////////////////////////
module test;
  integer num1,num2,num3;
  initial begin
    repeat(20) begin
      num1=$urandom_range(35,20); //35 max to 25 min
      num2= $urandom_range(9); // 9 max to 0 min 
      num3= $urandom_range(10,20); //10 min to 20 max
      $display("num1=%0d,\t num2=%0d \t num3=%0d",num1,num2,num3);
      #2 ;
    end 
  end
endmodule 
