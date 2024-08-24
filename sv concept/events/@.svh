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
