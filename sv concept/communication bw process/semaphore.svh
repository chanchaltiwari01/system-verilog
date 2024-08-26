
module without_sem();
  int a,b,y;
   
  task automatic shared_resource(string s ,int a,b);
    
    $display("%0s :\t time=%0t : writing start",s,$time);
    #5 y=a+b;    
    $display("%0s :\t time=%0t : writing complet : a=%0d ,b=%0d, y=%0d", s,$time,a,b,y); 

  endtask 
  
  initial begin
    fork 
      shared_resource("1st",10,20);
      shared_resource("2nd",20,30);
      shared_resource("3rd",30,40);
    join 
  end 
endmodule
////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

module with_sem();
  int a,b,y;
  
  semaphore sem; // semaphore hendle 
  
  task automatic shared_resource(string s ,int a,b);
    
    sem.get(1); // try to get key 
    $display("%0s :\t time=%0t : writing start",s,$time);
    #5  y=a+b;    
    $display("%0s :\t time=%0t : writing complet : a=%0d ,b=%0d, y=%0d", s,$time,a,b,y);  
    sem.put(1); // put return the key 

  endtask 
  
  initial begin
   sem=new(1);
    fork 
      shared_resource("1st",10,20);
      shared_resource("2nd",20,30);
      shared_resource("3rd",30,40);
    join 
  end 
endmodule
///////////////////////////////////////////////////////////////////////////////////////
module top;
  
  semaphore key;
  
  initial begin
    key = new(1);    
    fork
      personA();
      personB();
      #20 personA();
    join 
  end 
  ////////////////////////////////////////////////////
  
  task getroom(bit[1:0] id );
    $display("[%0t] tring to get a room for id [%0d] .....",$time,id);
    key.get(1);
    $display("[%0t] room key retrieved  for id [%0d] .....",$time,id);    
  endtask 
  
  task putroom(bit[1:0] id );
    $display("[%0t] leaving room id [%0d] ....",$time,id);
    key.put(1);
    $display("[%0t] room key put back id[%0d]....",$time,id);
  endtask 
  
  task personA();
    getroom(1);
    #20 putroom(1);
  endtask 
  
  task personB();
    #5 getroom(2);
    #10 putroom(2);
  endtask 
  
endmodule 
