module pointadd(g1_x,g1_y,q_x,q_y,add_x,add_y);
  input signed[8:0]g1_x,g1_y,q_x,q_y;
  output reg signed[8:0]add_x,add_y;
  reg signed[8:0]p=9'sb1011;
  reg signed[8:0]mu,mu1;
  reg signed[8:0]temp11,temp12,temp1,temp2;
  reg signed[8:0]t_x,t_y;
  reg signed[8:0]temp3,temp4,x13,y13,x3,y3;
  reg signed[8:0]comparator=9'sb0;
  reg signed[8:0]x,y,lambda1,lambda_pa;
	reg signed[8:0]a=9'sb1;
	reg signed[5:0]mod_x,mod_y;
  reg [11:0]a1,b1,p1;
  integer comp_flag;
  integer z,i;
  always@(*)
  begin
  temp11=g1_y-q_y;
  temp12=g1_x-q_x;
    if(temp11<comparator && temp12<comparator)
    begin
      temp1=-temp11;
      temp2=-temp12;
      comp_flag=0;
    end
    if((temp11<comparator && temp12>comparator)||(temp11>comparator && temp12<comparator))
    begin
      comp_flag=1;
      if(temp11<comparator)
      begin
         temp1=-temp11;
         temp2=temp12;
      end
      else
      begin
         temp1=temp11;
         temp2=-temp12;
      end
    end
    if(temp11>comparator && temp12>comparator)
    begin
      temp1=temp11;
      temp2=temp12;
      comp_flag=0;
    end
    if(temp11==comparator || temp12==comparator)
    begin
      temp1=temp11;
      temp2=temp12;
      comp_flag=0;
    end
    x=temp1;
    y=temp2;
    for(z=11;z>1;z=z-1)
    begin
      t_x=x;
      t_y=y;
      //t_x%z
      a1=t_x;
                  b1=z;
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
                  //t_y%z
                  a1=t_y;
                  b1=z;
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
                  mod_y=p1;
      if(mod_x == 0 && mod_y == 0)
      begin
         //t_x=x/z;
         a1=x;
                    b1=z;
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
                    t_x=a1;
       //  t_y=y/z;
       a1=y;
                    b1=z;
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
                    t_y=a1;
      end
      x=t_x;
      y=t_y;
    end
    if(comp_flag==0)
    begin
      temp1=t_x;
      temp2=t_y;
    end
    else
    begin
       temp1=-t_x;
       temp2=t_y; 
    end
  case(temp2)
      9'b0000:
      begin
        mu1=9'sb0000;   
      end
      9'b0001:
      begin
        mu1=9'sb0001;   
      end
      9'b0010:
      begin
        mu1=9'sb0110;
      end
      9'b0011:
      begin
        mu1=9'sb0100;
      end
      9'b0100:
      begin
        mu1=9'sb0011;   
      end
      9'b0101:
      begin
        mu1=9'sb1001;   
      end
      9'b0110:
      begin
        mu1=9'sb0010;   
      end
      9'b0111:
      begin
        mu1=9'sb1000;   
      end
      9'b1000:
      begin
        mu1=9'sb0111;   
      end
      9'b1001:
      begin
        mu1=9'sb0101;   
      end
      9'b1010:
      begin
        mu1=9'sb1010;   
      end
      9'b1100:
      begin
        mu1=9'sb0001;   
      end
      9'b1110:
      begin
        mu1=9'sb0100;   
      end
      9'b10010:
      begin
        mu1=9'sb1000;   
      end
      9'b10100:
      begin
        mu1=9'sb0101;   
      end
  endcase
  mu=mu1;
  lambda1=temp1*mu; 
  //lambda_pa=lambda1%p;
  a1=lambda1;
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
                  lambda_pa=p1;
  x13=pointaddition_x(lambda_pa,q_x,g1_x);
  y13=pointaddition_y(lambda_pa,q_x,x13,q_y);
  if(x13<9'sb0)
  begin
     x3=x13+p;
  end
  else
  begin
    x3=x13;
  end
  if(y13<9'sb0)
  begin
    y3=y13+p;
  end
  else
  begin
      y3=y13;
  end
   add_x=x3;
   add_y=y3;
   end
//////////       Point addition       ////////////////
  function signed[7:0] pointaddition_x;
    input signed[7:0] lambda_pa,x1,x2;
    reg signed[7:0]temp3,temp4,x13;
    begin
    temp3=lambda_pa*lambda_pa;
    temp4=temp3-x1;
    pointaddition_x=temp4-x2;
    end
  endfunction
  
  function signed[7:0] pointaddition_y;
    input signed[7:0] lambda_pa,x1,x3,y1;
    reg signed[7:0]y13;
    reg signed[7:0]temp5,temp6;
    begin
    temp5=x1-x3;
    temp6=temp5*lambda_pa;
    pointaddition_y=temp6-y1;
    end
  endfunction
endmodule