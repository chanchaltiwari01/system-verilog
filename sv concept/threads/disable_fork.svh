module test_disable_fork;
  
  initial begin
    $display("before fork__----");
    fork 
      #3 $display("#3 occurs at %0t",$time); //at time 3
      #2 $display("#2 occurs at %0t",$time); //at time 2
      #8 $display("#8 occurs at %0t",$time);  //at time 8
      #6 $display("#6 occurs at %0t",$time);  //at time 6
      #5 $display("#5 occurs at %0t",$time);  //at time 5
    join_any
    $display("out of fork block----");
    disable fork;
      end 
endmodule
