module tb;
  // Create an event variable that processes can use to trigger and wait
  event event_a;

  // Thread1: Triggers the event using "->" operator at 20ns
  initial begin
    #20 -> event_a;
    $display ("[%0t] Thread1: triggered event_a", $time);
  end

  // Thread2: Starts waiting for the event using "@" operator at 20ns
  initial begin
    $display ("[%0t] Thread2: waiting for trigger ", $time);
    #20 @(event_a);
    $display ("[%0t] Thread2: received event_a trigger ", $time);
  end

  // Thread3: Starts waiting for the event using "wait" at 20ns
  initial begin
    $display ("[%0t] Thread3: waiting for trigger ", $time);
    #20 wait (event_a.triggered);
    $display ("[%0t] Thread3: received event_a trigger", $time);
  end
endmodule
///////////////////////////////////////////////////////////////////////////////////////
//ex2////////////////////////////////////////////////////////////////////
module test_event7;
int count ;
event myevent ;
initial begin
$monitor(count); 
-> myevent;
wait(myevent.triggered);
count+=1; // count =1;
end 
endmodule

// //ex3//////////////////////////////////
module test_event8;
int count ;
event myevent ;
initial begin
fork
$monitor(count); 
-> myevent;
wait(myevent.triggered);
count+=1; // count =1;
join
end 
endmodule
