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
//     #2 void'(mb.try_get(i));
//     // 3
//     #2 void'(mb.try_get(s));
  endtask
endmodule

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

/////////////////////PARAMETERIZED mailbox //////////////////

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
/////////////////// or you can write this ///////////////////


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

//////////////////////////////////////////////////////////////////////

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
   
   mb.put(1);
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
    
