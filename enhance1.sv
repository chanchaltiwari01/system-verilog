module print();
rag a = 1 , b=0 ;
initial begin
$display("a:%0d,b:%0d",a,b);
end 
initial begin
    $display("first change ");
end
initial begin
    $display("version 5 ");
end
initial begin
    $display("version 6");
end
initial begin
    $display("inhance ");
end
initial begin
    $display("inhance branch  ");
end
endmodule 