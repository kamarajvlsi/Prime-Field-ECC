module pointdouble(g1_x,g1_y,double_x,double_y);
  input signed[8:0]g1_x,g1_y;
  output reg signed[8:0]double_x,double_y;
  reg signed[8:0]p=9'sb1011;
  reg signed[8:0]mu,mu1;
  reg signed[8:0]temp11,temp12,temp1,temp2;
  reg signed[8:0]t_x,t_y;
  reg signed[8:0]temp3,temp4,x13,y13,x3,y3;
  reg signed[8:0]comparator=9'sb0;
  reg signed[8:0]t1,t2,k1,r1,r2,t,q,r,r11,r12,x,y,lambda1,lambda_pd;
	reg signed[8:0]a=9'sb1;
  reg signed[8:0]const1=9'sb011;
  reg signed[8:0]const2=9'sb010;
  reg signed[5:0]mod_x,mod_y;
  reg [11:0]a1,b1,p1;
  integer comp_flag;
  integer z,i;
  always @ (*)
  begin
  temp1=g1_x*g1_x;
  temp2=3*temp1;
  temp11=temp2+1;
  temp12=2*g1_y;
  if(temp11<comparator && temp12<comparator)
  begin
                temp3=-temp11;
                temp4=-temp12;
                comp_flag=0;
            end
            if((temp11<comparator && temp12>comparator)||(temp11>comparator && temp12<comparator))
            begin
                comp_flag=1;
                if(temp11<comparator)
                begin
                  temp3=-temp11;
                  temp4=temp12;
                end
                else
                begin
                  temp3=temp11;
                  temp4=-temp12;
              end
            end
            if(temp11>comparator && temp12>comparator)
            begin
                temp3=temp11;
                temp4=temp12;
                comp_flag=0;
            end
            if(temp11==comparator || temp12==comparator)
            begin
                temp3=temp11;
                temp4=temp12;
                comp_flag=0;
            end
            x=temp3;
            y=temp4;
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
                if(mod_x==0 && mod_y==0)
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
                  //t_y=y/z;
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
                temp3=t_x;
                temp4=t_y;
            end
            else
            begin
                temp3=-t_x;
                temp4=t_y;
            end
            r12=temp4;
                case(r12)
                  4'b0000: begin
                    mu=5'sb0000;   
                    end
                  4'b0001: begin
                    mu=5'sb0001;   
                    end
                  4'b0010: begin
                    mu=5'sb0110;
                    end
                  4'b0011: begin
                    mu=5'sb0100;
                    end
                  4'b0100: begin
                    mu=5'sb0011;   
                    end
                  4'b0101: begin
                    mu=5'sb1001;   
                    end
                  4'b0110: begin
                    mu=5'sb0010;   
                    end
                  4'b0111: begin
                    mu=5'sb1000;   
                    end
                  4'b1000: begin
                    mu=5'sb0111;   
                    end
                  4'b1001: begin
                    mu=5'sb0101;   
                    end
                  4'b1010: begin
                    mu=5'sb1010;   
                    end
                  4'b1100: begin
                    mu=5'sb0001;   
                    end
                  4'b1110: begin
                    mu=5'sb0100;   
                    end
                  5'b10010: begin
                    mu=6'sb1000;   
                    end
                  5'b10100: begin
                    mu=6'sb0101;   
                    end
                  endcase
                lambda1=temp3*mu;
            //lambda1%p
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
                  lambda_pd=p1;
            x13=pointdoubling_x(lambda_pd,g1_x);
            y13=pointdoubling_y(lambda_pd,g1_x,x13,g1_y);
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
            double_x=x3;
            double_y=y3;
     end
 ///////     Point doubling      /////////
  function signed[7:0]pointdoubling_x;
     input signed[7:0]lambda_pd,x1;
     reg signed[7:0]temp1,temp2,x13;
      begin
       temp1=lambda_pd*lambda_pd;
       temp2=const2*x1;
        x13=temp1-temp2;
        pointdoubling_x=x13;
     end
  endfunction

  function signed[7:0]pointdoubling_y;
     input signed[7:0]lambda_pd,x1,x3,y1;
      reg signed[7:0]temp1,temp2,y13;
     begin
       temp1=x1-x3;
       temp2=lambda_pd*temp1;
       y13=temp2-y1;
       pointdoubling_y=y13;
     end
  endfunction
endmodule