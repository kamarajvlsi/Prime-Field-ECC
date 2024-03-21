module negmod(in,p,neg_mod);
  input signed[11:0]in;
  input signed[4:0]p;
  output reg signed[9:0]neg_mod;
  reg signed[5:0]mod_x;
  reg signed[11:0]check;
    reg signed[9:0]tt;
//    reg signed[11:0]in;
reg [11:0]a1,b1,p1;
integer i;
always @(*)
begin
  if(in<12'sb0) begin
                  check=-in;
                  //check%p;
                  a1=check;
                  b1=p;
                  p1=0;
                  for(i=0;i<12;i=i+1)
                  begin
                    p1={p1[10:0],a1[11]};
                    a1[11:1]=a1[10:0];
                    p1=p1-b1;
                    if(p1[11]==1)
                    begin
                      a1[0]=0;
                      p1=p1+b1;
                    end
                    else
                    begin
                      a1[0]=1;
                    end
                  end
                  mod_x=p1;
                  
                  if(mod_x==0) begin
                    neg_mod=8'sb0;
                    end
                  else begin
                    //tt=check/p;
                    
                    a1=check;
                    b1=p;
                    p1=0; 
                    for(i=0;i<12;i=i+1)
                    begin
                      p1={p1[10:0],a1[11]};
                      a1[11:1]=a1[10:0];
                      p1=p1-b1;
                      if(p1[11]==1)
                      begin
                        a1[0]=0;
                        p1=p1+b1;
                      end
                      else
                      begin
                        a1[0]=1;
                      end
                    end
                    tt=a1;
                    neg_mod=((tt+8'sb1)*p)+in;
                    end
      end
end
endmodule
                  