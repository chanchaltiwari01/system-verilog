module mailbox_example();
  mailbox mb = new(3);
  
  task process_A();
    int value = 5;
    string name = "STRING";
    mb.put(value);
    $display("Put data = %0d", value);
    mb.put("STRING");
    $display("Put data = %s", name);
  endtask

  task process_B();
    int value;
    string name;
    mb.get(value);
    $display("Retrieved data = %0d", value);
    mb.get(name);
    $display("Retrieved data = %s", name);
  endtask
  
  initial begin
    fork
      process_A();
      process_B();
    join
  end
endmodule
//////////////////////////////////////////////////////////
module generic_unbounded;
  mailbox mb; // typeless mailbox
  string s;
  int i;
  
  initial begin
    mb = new(); // unbounded mailbox default size is zero(0)
    $monitor("s=%0s, and i=%0d, at time=%0t", s, i, $time);
    
    fork
      gen_data;
      rec_data;
    join
  end
 
  task gen_data; // generate data
    // 1
    mb.put("jai shree ram");
    #3 mb.put(7);
    // 2
    #3 mb.put("jai bajaran bali ");
    #3 mb.put(8);
    // 3
    #3 mb.put("jai shero bali maa");
    #3 mb.put(9);
    // 4
    #3 mb.put("har har sambhu ");
    #3 mb.put(10);
  endtask
  
  task rec_data; // recover data
    // 1
    #1 mb.peek(s);
    #2 mb.get(s);
    #2 mb.get(i);
    // 2
    #2 mb.get(s);
    #3 mb.try_get(i);
    // 3
    #3 mb.try_get(s);    
    #3 mb.get(i);
    // 4
    #3 mb.get(s);
    #3 mb.get(i);
    //5       
    #2 void'(mb.try_get(i));
    // 3
    #2 void'(mb.try_get(s));
  endtask
endmodule
//////////////////////////////////////
//////////////// generic mailbox/////////////////////////////
module top;
  mailbox mbx = new(2); // bounded 
  
  initial begin
    for (int i = 0; i < 5; i++) begin
      #1 mbx.put(i);
      $display("[%0t] thread 0: put item# %0d, size=%0d", $time, i, mbx.num);
    end 
  end 
  
  initial begin
    forever begin
      int idx;
      #2 mbx.get(idx);
      $display("[%0t] thread 0: got item, # %0d, size=%0d", $time, idx, mbx.num);
    end 
  end 
endmodule
//////////////////////////////////////////////////
module mailbox_example();
  mailbox mb = new();
  
  task process_A();
    int value;
    repeat(10) begin
      value = $urandom_range(1, 50);
      mb.put(value);
      $display("Put data = %0d", value);
    end
    $display("----------------------");
  endtask

  task process_B();
    int value;
    repeat(10) begin
      mb.get(value);
      $display("Retrieved data = %0d", value);
    end
  endtask
  
  initial begin
    fork
      process_A();
      process_B();
    join
  end
endmodule
/////////////////////////////////////////////////////////////
///////////////////PARAMETERIZED mailbox //////////////////
module mailbox_example();
  mailbox #(string) mb = new(3);
  
  task process_A();
    string name = "Alex";
    mb.put(name);
    $display("Put data = %s", name);
    name = "Robin";
    mb.put(name);
    $display("Put data = %s", name);
  endtask

  task process_B();
    string name;
    mb.get(name);
    $display("Retrieved data = %s", name);
    mb.get(name);
    $display("Retrieved data = %s", name);
  endtask
  
  initial begin
    fork
      process_A();
      process_B();
    join
  end
endmodule
/////////////////////////////////////////////////////////
typedef mailbox #(string ) smb;

class send;
  smb name ;
  
  task put();
    for(int i=0; i<4; i++) begin
     string s =$sformatf("name%0d",i);
       //string s = { "name", i };
      name.put(s);
      #1 $display("[%0t] put: put %s",$time,s);
    end
  endtask
endclass

                  
class retrive;
  smb list;
  
  task get();
    forever begin
      string s;
      list.get(s);
      $display("[%0t] retrive: get %s", $time ,s);
    end
  endtask 
endclass

module tb;
  
  smb mb;
  send p;
  retrive r;
  initial begin
    mb=new();
    r=new();
    p=new();
    p.name=mb;
    r.list=mb;
    
    fork 
      p.put();
      r.get();
    join
  end 
endmodule 

///// or we can write like this /////////////////

class send;
  mailbox #(string) name;
  
  task put();
    for (int i = 0; i < 4; i++) begin
      string s = $sformatf("name%0d", i);
      name.put(s);
      $display("[%0t] put: put %s", $time, s);
      #1;
    end 
  endtask
endclass

class retrieve;
  mailbox #(string) list;
  
  task get();
    forever begin
      string s;
      list.get(s);
      $display("[%0t] retrieve: get %s", $time, s);
    end
  endtask
endclass

module tb;
  mailbox #(string) mb;
  send p;
  retrieve r;

  initial begin
    mb=new();
    p = new();
    r = new();
    p.name = mb;
    r.list = mb;
    
    fork 
      p.put();
      r.get();
    join_any
  end
endmodule

//////////////////////////try_get and try_put method////////////////////////
module mailbox_example();
  mailbox mb = new(3);
  
  task process_A();
    int value;
    repeat(5) begin
      value = $urandom_range(1, 50);
      if(mb.try_put(value))
        $display("successfully try_put data = %0d", value);
      else begin
        $display("failed while try_put data = %0d", value);
        $display("Number of messages in the mailbox = %0d", mb.num());
      end
    end
    $display("---------------------------------------");
  endtask

  task process_B();
    int value;
    repeat(5) begin
      if(mb.try_get(value))
        $display("Successfully retrieved try_get data = %0d", value);
      else begin
        $display("Failed in try_get data");
        $display("Number of messages in the mailbox = %0d", mb.num());
      end
    end
  endtask
  
  initial begin
    fork
      process_A();
      process_B();
    join
  end
endmodule
/////////////////////////////////////////////////////////
//////////////////////////peek and try_peek /////////////////////
module mailbox_example();
  mailbox mb = new(3);
  
  task process_A();
    int value;
    repeat(3) begin
      value = $urandom_range(1, 50);
      mb.put(value);
      $display("put data = %0d", value);
    end
    $display("----------------------------------");
  endtask

  task process_B();
    int value;
    mb.peek(value); // message is not removed
    $display("peek data = %0d", value);
    mb.peek(value); // message is not removed
    $display("peek data = %0d", value);
    if(mb.try_peek(value))
      $display("Successful try_peek data = %0d", value);
    else begin
      $display("Failed in try_peek");
    end
    $display("----------------------------------");
    repeat(3) begin
      mb.get(value);
      $display("get data = %0d", value);
    end
   $display("----------------------------------");
   if(mb.try_peek(value))
      $display("Successful try_peek data = %0d", value);
    else begin
      $display("Failed in try_peek");
    end
  endtask
  
  initial begin
    fork
      process_A();
      process_B();
    join
  end
endmodule
/////////////////////////////////////////////////
module top;
  mailbox #(int) mb; 
  
  int i ;
  initial begin
    mb=new(5);
    $monitor("[%0t]i=%0d",$time,i);
    
    fork 
      gen_data;
      rec_data;
    join
    
  end 
  task gen_data;
    
    #0 mb.put(1);
    #3 mb.put(2);
    #3 mb.put(3);
    #3 mb.put(4);
    #3 mb.put(5);
    #3 mb.put(6);
    #3 mb.put(27);
    #3 mb.put(8);
  endtask 
  
  task rec_data;
     #1 mb.get(i);
     #3 mb.get(i); 
     #3 mb.get(i);
     #3 mb.get(i);
     #3 mb.get(i);
     #3 mb.get(i);
     #3 mb.get(i);
     #3 mb.get(i);
  endtask 
endmodule 
