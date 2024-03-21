module sinv(r1,r2,x);
  input signed[7:0]r1,r2;
  output signed[7:0]x;
  reg signed[7:0]t;
  reg signed[7:0]q;
  reg signed[7:0]r;
  reg signed[7:0]t1=8'sb00000;
  reg signed[7:0]t2=8'sb00001;
  reg signed[7:0]x=8'sb00000;
  reg signed[7:0]r11;
  reg signed[7:0]r12;
  reg signed[7:0]k=8'sb0;
  always@ (r2)
  begin
    r11=r1;
    r12=r2;
    while(r11!=8'sb1)
      begin
        q=r11/r12;
        k=t2*q;
        t=t1-k;
        t1=t2;
        t2=t;
        r=r11%r12;
        r11=r12;
        r12=r;
      end
      x=t1;
  end
endmodule