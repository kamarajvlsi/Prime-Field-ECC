module lfsr(clk,rst,x);
  input clk,rst;
  output [5:0]x;
wire xx0,xx1,xx2;
dff m0 (clk,rst,xx2,x[0]);
dff m1 (clk,rst,x[0],x[1]);
dff m2 (clk,rst,x[1],x[2]);
dff m3 (clk,rst,x[2],x[3]);
dff m4 (clk,rst,x[3],x[4]);
dff m5 (clk,rst,x[4],x[5]);
assign xx0=x[2]^x[1];
assign xx1=x[1]^xx0;
assign xx2=x[0]^xx1;
endmodule
