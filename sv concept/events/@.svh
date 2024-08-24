module events_ex;
  event ev_1; //declaring event ev_1

  initial begin
    fork
      //process-1, triggers the event
      begin
        #40;
        $display($time,"\tTriggering The Event");
        ->ev_1;
      end
    
      //process-2, wait for the event to trigger
      begin
        $display($time,"\tWaiting for the Event to trigger");
        @(ev_1.triggered);
        $display($time,"\tEvent triggered");
      end
    join
  end
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////
module events_ex;

  event ev_1; //declaring event ev_1

  initial begin
    fork
      //process-1, triggers the event
      begin
        #40;
        $display($time,"\tTriggering The Event");
        ->ev_1;
      end
    
      //process-2, wait for the event to trigger
      begin
        $display($time,"\tWaiting for the Event to trigger");
        #60;
        @(ev_1.triggered);
        $display($time,"\tEvent triggered");
      end
    join
  end
  initial begin
    #100;
    $display($time,"\tEnding the Simulation");
    $finish;
  end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
     @(event_a);
    $display ("[%0t] Thread2: received event_a trigger ", $time);
  end

  // Thread3: Starts waiting for the event using "wait" at 20ns
  initial begin
    $display ("[%0t] Thread3: waiting for trigger ", $time);
    wait (event_a.triggered);
    $display ("[%0t] Thread3: received event_a trigger", $time);
  end
endmodule
