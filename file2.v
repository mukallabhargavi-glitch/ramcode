module test(clk,rst,out);
  input clk,rst;
  output reg[3:0]out;
  reg[1:0]cnt;
  wire q;
  
  always@(posedge clk)begin
    if(rst)
      cnt<=0;
    else
      cnt<=cnt+1;
  end
  
  assign q=cnt[1];
  
  always@(posedge q or posedge rst)begin
    if(rst)
      out<=4'b0;
//     else if(out==4'b1010)
//       out<=0;
    else
      out<=out+1;
  end
endmodule


