module test_always ;
int a,b,c,x,y;

always@(a)
y=a^b^c;
always_comb
x=a^b^c;
initial begin
a=0; b=0; c=0;
#5 a=1; b=0; c=0;
#5 a=1; b=1; c=0;
#5 a=1; b=0; c=1;
#5 a=0; b=1; c=0;
#5 a=1; b=0; c=1;
#5 a=0; b=1; c=0;
#5 a=1; b=1; c=1;
end 
initial begin
$monitor("t=%0t,a=%0b,b=%0b,c=%0b,x=%0b,y=%0b",$time,a,b,c,x,y);
end 
endmodule 

//ex2

module test_always1 ;
int a,b,c,x,y;
//function logic xor_gate(logic ); // run at EDA playground 
function logic xor_gate(logic a,logic b,logic c);
return a^b^c;
endfunction

always@(*)
x= xor_gate(a,b,c);
always_comb
y= xor_gate(a,b,c);
initial begin
a=0; b=0; c=0;
#5 a=1; b=0; c=0;
#5 a=1; b=1; c=0;
#5 a=1; b=0; c=1;
#5 a=0; b=1; c=0;
#5 a=1; b=0; c=1;
#5 a=0; b=1; c=0;
#5 a=1; b=1; c=1;
end 
initial begin
$monitor("t=%0t,a=%0b,b=%0b,c=%0b,x=%0b,y=%0b",$time,a,b,c,x,y);
end 
endmodule 
