/*R0 ? 0
  R1 ? P
  for i from m downto 0 do
      if di = 0 then
          R1 ? point_add(R0, R1)
          R0 ? point_double(R0)
      else
          R0 ? point_add(R0, R1)
          R1 ? point_double(R1)
  return R0*/
  module ecc_montgomeryk(clk,rst,inp_msg,out_msg);
  input clk,rst;
  input [3:0]inp_msg;
  output [3:0]out_msg;
  wire [2:0]nb;
  wire signed[4:0]g_x,g_y;
  reg signed[7:0]pb_x,pb_y;
  wire [2:0]k;
 // reg [2:0]nb=3'b100;
  wire [3:0]g;

  wire signed[4:0]pm_x,pm_y;
 // reg signed[7:0]g_x = 8'sb1000;
 // reg signed[7:0]g_y = 8'sb0111;
  reg signed[7:0]cipher1_x,cipher1_y,kpb_x,kpb_y,cipher2_x,cipher2_y,dc1_x,dc1_y,out_x,out_y;
  reg signed[7:0]const_3=8'sb11;
  reg signed[7:0]const_2=8'sb10;
  reg signed[7:0]a=8'sb1;
  reg signed[7:0]x13,x3,y13,y3;
  reg signed[7:0]lambda_pd,lambda_pa;
  reg signed[11:0]lambda1;
  reg signed[7:0]mu,r12,tt,check;
  reg signed[4:0]p=5'sb1011;
  integer comp_flag,z;
  reg signed[7:0]q_x=8'sb0;
  reg signed[7:0]q_y=8'sb0;
  reg signed[7:0]g_x1,g_y1,g_x2,g_y2;
  reg signed[8:0]temp11,temp12,temp1,temp2,x,y,t_x,t_y,temp3,temp4,divisor_copy,dividend_copy;
  reg signed[4:0]mod_x;
  reg signed[4:0]mod_y;
  reg [8:0]temp;

  lfsr3 l31(clk,rst,nb);
  lfsr3 l32(clk,rst,k);
  lfsr l1(clk,rst,g);
  lfsr l2(clk,rst,inp_msg);
  lut11with0 lu1(g,g_x,g_y);
  lut11with0 lu2(inp_msg,pm_x,pm_y);
  
  integer i;
  always@(g_x or g_y) 
  begin
    if(rst==0)
    begin
                  ///////// Pb = nb*G  ////////////
      g_x1=g_x;
      g_y1=g_y;
      for(i=2;i>-1;i=i-1)
      begin
        if(nb[i]==1'sb0)
        begin
        // P=Q+P starts
        
        if((q_x==8'sb0 && q_y==8'sb0)||(g_x1==8'sb0 && g_y1==8'sb0)||(q_x==g_x1 && q_y==-g_y1))begin
            if(q_x==g_x1 && q_y==-g_y1) begin
              g_x1=8'sb0;
              g_y1=8'sb0;
            end
            if(g_x1==8'sb0 && g_y1==8'sb0)begin
              g_x1=q_x;
              g_y1=q_y;
            end
            end
          else begin
            if(q_x==g_x1 && q_y==g_y1)begin
              //pd
              temp11=g_x1*g_x1;
              temp12=const_3*temp11;
              temp1=temp12+a;
              temp2=const_2*g_y1;
              if(temp2==9'sb0)begin
                g_x1=8'sb0;
                g_y1=8'sb0;
                end
              else begin
                if(temp1<9'sb0 && temp2<9'sb0) begin
                  comp_flag=0;
                  temp3=-temp1;
                  temp4=-temp2;
                  end
                if(temp1>9'sb0 && temp2>9'sb0) begin
                  comp_flag=0;
                  temp3=temp1;
                  temp4=temp2;
                  end
                if(temp1<9'sb0 && temp2>9'sb0) begin
                  comp_flag=1;
                  temp3=-temp1;
                  temp4=temp2;
                  end
                if(temp1>9'sb0 && temp2<9'sb0) begin
                  comp_flag=1;
                  temp3=temp1;
                  temp4=-temp2;
                  end
                x=temp3;
                y=temp4;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp3=t_x;
                  temp4=t_y;
                  end
                else begin
                  temp3=-t_x;
                  temp4=t_y;
                  end  
                r12=temp4;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp3*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pd=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pd=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pd=lambda1%p;
                  end
                x13=pointdoubling_x(lambda_pd,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                g_x1=x3;
                g_y1=y3;             
                end
              end   //pd when pa must be done
            else begin
              //pa
              temp11=g_y1-q_y;
              temp12=g_x1-q_x;
              if(temp12==8'sb0) begin
                g_x1=8'sb0;
                g_y1=8'sb0;
                end
              else begin
                if(temp11<9'sb0 && temp12<9'sb0) begin
                  temp1=-temp11;
                  temp2=-temp12;
                  comp_flag=0;
                  end
                if((temp11<9'sb0 && temp12>9'sb0)||(temp11>9'sb0 && temp12<9'sb0)) begin
                  comp_flag=1;
                  if(temp11<9'sb0) begin
                    temp1=-temp11;
                    temp2=temp12;
                   end
                  else begin
                    temp1=temp11;
                    temp2=-temp12;
                    end
                  end
                if(temp11>9'sb0 && temp12>9'sb0) begin
                  temp1=temp11;
                  temp2=temp12;
                  comp_flag=0;
                  end
                x=temp1;
                y=temp2;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp1=t_x;
                  temp2=t_y;
                  end
                else begin
                  temp1=-t_x;
                  temp2=t_y;
                  end  
                r12=temp2;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp1*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pa=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pa=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pa=lambda1%p;
                  end
                //end
                x13=pointaddition_x(lambda_pa,q_x,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointaddition_y(lambda_pa,q_x,x3,q_y);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                g_x1=x3;
                g_y1=y3;
                end   
              end// pa when pa must be done
            end
        
        // P=Q+P ends 
        // Q=2Q starts
        temp11=q_x*q_x;
        temp12=const_3*temp11;
        temp1=temp12+a;
        temp2=const_2*q_y;
        if(temp2==9'sb0) begin
          q_x=8'sb0;
          q_y=8'sb0;
          end
        else begin
          if(temp1<9'sb0 && temp2<9'sb0) begin
            comp_flag=0;
            temp3=-temp1;
            temp4=-temp2;
            end
          if(temp1>9'sb0 && temp2>9'sb0) begin
            comp_flag=0;
            temp3=temp1;
            temp4=temp2;
            end
          if(temp1<9'sb0 && temp2>9'sb0) begin
            comp_flag=1;
            temp3=-temp1;
            temp4=temp2;
            end
          if(temp1>9'sb0 && temp2<9'sb0) begin
            comp_flag=1;
            temp3=temp1;
            temp4=-temp2;
            end
          x=temp3;
          y=temp4;  
          for(z=21;z>1;z=z-1) begin
            t_x=x;
            t_y=y;
            if(t_x%z == 0 && t_y%z == 0) begin
              t_x=x/z;
              t_y=y/z;
              end
            x=t_x;
            y=t_y;
          end
          if(comp_flag==0) begin
            temp3=t_x;
            temp4=t_y;
            end
          else begin
            temp3=-t_x;
            temp4=t_y;
            end  
          r12=temp4;
          case(r12)
            8'b0000: begin
              mu=8'sb0000;   
              end
            8'b0001: begin
              mu=8'sb0001;   
              end
            8'b0010: begin
              mu=8'sb0110;
              end
            8'b0011: begin
              mu=8'sb0100;
              end
            8'b0100: begin
              mu=8'sb0011;   
              end
            8'b0101: begin
              mu=8'sb1001;   
              end
            8'b0110: begin
              mu=8'sb0010;   
              end
            8'b0111: begin
              mu=8'sb1000;   
              end
            8'b1000: begin
              mu=8'sb0111;   
              end
            8'b1001: begin
              mu=8'sb0101;   
              end
            8'b1010: begin
              mu=8'sb1010;   
              end
            8'b1100: begin
              mu=8'sb0001;   
              end
            8'b1110: begin
              mu=8'sb0100;   
              end
            8'b10010: begin
              mu=8'sb1000;   
              end
            8'b10100: begin
              mu=8'sb0101;   
              end
            endcase
          lambda1=temp3*mu;
          if(lambda1<12'sb0) begin
            check=-lambda1;
            if(check%p==0) begin
              lambda_pd=8'sb0;
              end
            else begin
              tt=check/p;
              lambda_pd=((tt+8'sb1)*p)+lambda1;
              end
            end
          else begin
            lambda_pd=lambda1%p;
            end
          x13=pointdoubling_x(lambda_pd,q_x);
          if(x13<8'sb0) begin
            check=-x13;
            if(check%p==0) begin
              x3=8'sb0;
              end
            else begin
              tt=check/p;
              x3=((tt+8'sb1)*p)+x13;
              end
            end
          else begin
            x3=x13%p;
            end
          y13=pointdoubling_y(lambda_pd,q_x,x3,q_y);
          if(y13<8'sb0) begin
            check=-y13;
            if(check%p==0) begin
              y3=8'sb0;
              end
            else begin
              tt=check/p;
              y3=((tt+8'sb1)*p)+y13;
              end
            end
          else begin
            y3=y13%p;
            end
          q_x=x3;
          q_y=y3;             
          end 
        
        // Q=2Q ends
        end//nb[i] is 0
        else
        begin
          // Q=Q+P starts
          
          if((q_x==8'sb0 && q_y==8'sb0)||(g_x1==8'sb0 && g_y1==8'sb0)||(q_x==g_x1 && q_y==-g_y1))begin
            if(q_x==g_x1 && q_y==-g_y1) begin
              q_x=8'sb0;
              q_y=8'sb0;
            end
            if(q_x==8'sb0 && q_y==8'sb0)begin
              q_x=g_x1;
              q_y=g_y1;
            end
            end
          else begin
            if(q_x==g_x1 && q_y==g_y1)begin
              //pd
              temp11=g_x1*g_x1;
              temp12=const_3*temp11;
              temp1=temp12+a;
              temp2=const_2*g_y1;
              if(temp2==9'sb0)begin
                q_x=8'sb0;
                q_y=8'sb0;
                end
              else begin
                if(temp1<9'sb0 && temp2<9'sb0) begin
                  comp_flag=0;
                  temp3=-temp1;
                  temp4=-temp2;
                  end
                if(temp1>9'sb0 && temp2>9'sb0) begin
                  comp_flag=0;
                  temp3=temp1;
                  temp4=temp2;
                  end
                if(temp1<9'sb0 && temp2>9'sb0) begin
                  comp_flag=1;
                  temp3=-temp1;
                  temp4=temp2;
                  end
                if(temp1>9'sb0 && temp2<9'sb0) begin
                  comp_flag=1;
                  temp3=temp1;
                  temp4=-temp2;
                  end
                x=temp3;
                y=temp4;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp3=t_x;
                  temp4=t_y;
                  end
                else begin
                  temp3=-t_x;
                  temp4=t_y;
                  end  
                r12=temp4;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp3*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pd=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pd=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pd=lambda1%p;
                  end
                x13=pointdoubling_x(lambda_pd,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                q_x=x3;
                q_y=y3;             
                end
              end   //pd when pa must be done
            else begin
              //pa
              temp11=g_y1-q_y;
              temp12=g_x1-q_x;
              if(temp12==8'sb0) begin
                q_x=8'sb0;
                q_y=8'sb0;
                end
              else begin
                if(temp11<9'sb0 && temp12<9'sb0) begin
                  temp1=-temp11;
                  temp2=-temp12;
                  comp_flag=0;
                  end
                if((temp11<9'sb0 && temp12>9'sb0)||(temp11>9'sb0 && temp12<9'sb0)) begin
                  comp_flag=1;
                  if(temp11<9'sb0) begin
                    temp1=-temp11;
                    temp2=temp12;
                   end
                  else begin
                    temp1=temp11;
                    temp2=-temp12;
                    end
                  end
                if(temp11>9'sb0 && temp12>9'sb0) begin
                  temp1=temp11;
                  temp2=temp12;
                  comp_flag=0;
                  end
                x=temp1;
                y=temp2;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp1=t_x;
                  temp2=t_y;
                  end
                else begin
                  temp1=-t_x;
                  temp2=t_y;
                  end  
                r12=temp2;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp1*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pa=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pa=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pa=lambda1%p;
                  end
                //end
                x13=pointaddition_x(lambda_pa,q_x,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointaddition_y(lambda_pa,q_x,x3,q_y);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                q_x=x3;
                q_y=y3;
                end   
              end// pa when pa must be done
            end
          // Q=Q+P ends
          
          // P=2P starts
          
        temp11=g_x1*g_x1;
        temp12=const_3*temp11;
        temp1=temp12+a;
        temp2=const_2*g_y1;
        if(temp2==9'sb0) begin
          g_x1=8'sb0;
          g_y1=8'sb0;
          end
        else begin
          if(temp1<9'sb0 && temp2<9'sb0) begin
            comp_flag=0;
            temp3=-temp1;
            temp4=-temp2;
            end
          if(temp1>9'sb0 && temp2>9'sb0) begin
            comp_flag=0;
            temp3=temp1;
            temp4=temp2;
            end
          if(temp1<9'sb0 && temp2>9'sb0) begin
            comp_flag=1;
            temp3=-temp1;
            temp4=temp2;
            end
          if(temp1>9'sb0 && temp2<9'sb0) begin
            comp_flag=1;
            temp3=temp1;
            temp4=-temp2;
            end
          x=temp3;
          y=temp4;  
          for(z=21;z>1;z=z-1) begin
            t_x=x;
            t_y=y;
            if(t_x%z == 0 && t_y%z == 0) begin
              t_x=x/z;
              t_y=y/z;
              end
            x=t_x;
            y=t_y;
          end
          if(comp_flag==0) begin
            temp3=t_x;
            temp4=t_y;
            end
          else begin
            temp3=-t_x;
            temp4=t_y;
            end  
          r12=temp4;
          case(r12)
            8'b0000: begin
              mu=8'sb0000;   
              end
            8'b0001: begin
              mu=8'sb0001;   
              end
            8'b0010: begin
              mu=8'sb0110;
              end
            8'b0011: begin
              mu=8'sb0100;
              end
            8'b0100: begin
              mu=8'sb0011;   
              end
            8'b0101: begin
              mu=8'sb1001;   
              end
            8'b0110: begin
              mu=8'sb0010;   
              end
            8'b0111: begin
              mu=8'sb1000;   
              end
            8'b1000: begin
              mu=8'sb0111;   
              end
            8'b1001: begin
              mu=8'sb0101;   
              end
            8'b1010: begin
              mu=8'sb1010;   
              end
            8'b1100: begin
              mu=8'sb0001;   
              end
            8'b1110: begin
              mu=8'sb0100;   
              end
            8'b10010: begin
              mu=8'sb1000;   
              end
            8'b10100: begin
              mu=8'sb0101;   
              end
            endcase
          lambda1=temp3*mu;
          if(lambda1<12'sb0) begin
            check=-lambda1;
            if(check%p==0) begin
              lambda_pd=8'sb0;
              end
            else begin
              tt=check/p;
              lambda_pd=((tt+8'sb1)*p)+lambda1;
              end
            end
          else begin
            lambda_pd=lambda1%p;
            end
          x13=pointdoubling_x(lambda_pd,g_x1);
          if(x13<8'sb0) begin
            check=-x13;
            if(check%p==0) begin
              x3=8'sb0;
              end
            else begin
              tt=check/p;
              x3=((tt+8'sb1)*p)+x13;
              end
            end
          else begin
            x3=x13%p;
            end
          y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
          if(y13<8'sb0) begin
            check=-y13;
            if(check%p==0) begin
              y3=8'sb0;
              end
            else begin
              tt=check/p;
              y3=((tt+8'sb1)*p)+y13;
              end
            end
          else begin
            y3=y13%p;
            end
          g_x1=x3;
          g_y1=y3;             
          end
          // P=2P ends
        end//nb[i] is 1
      end// for loop end
      pb_x=q_x;
      pb_y=q_y;
      
        ///////////      Calculation of kG (Ciphertext1)     /////////////
  q_x=9'sb0;
  q_y=9'sb0;
  g_x1=g_x;
  g_y1=g_y;
  
  for(i=2;i>-1;i=i-1)
      begin
        if(nb[i]==1'sb0)
        begin
        // P=Q+P starts
        
        if((q_x==8'sb0 && q_y==8'sb0)||(g_x1==8'sb0 && g_y1==8'sb0)||(q_x==g_x1 && q_y==-g_y1))begin
            if(q_x==g_x1 && q_y==-g_y1) begin
              g_x1=8'sb0;
              g_y1=8'sb0;
            end
            if(g_x1==8'sb0 && g_y1==8'sb0)begin
              g_x1=q_x;
              g_y1=q_y;
            end
            end
          else begin
            if(q_x==g_x1 && q_y==g_y1)begin
              //pd
              temp11=g_x1*g_x1;
              temp12=const_3*temp11;
              temp1=temp12+a;
              temp2=const_2*g_y1;
              if(temp2==9'sb0)begin
                g_x1=8'sb0;
                g_y1=8'sb0;
                end
              else begin
                if(temp1<9'sb0 && temp2<9'sb0) begin
                  comp_flag=0;
                  temp3=-temp1;
                  temp4=-temp2;
                  end
                if(temp1>9'sb0 && temp2>9'sb0) begin
                  comp_flag=0;
                  temp3=temp1;
                  temp4=temp2;
                  end
                if(temp1<9'sb0 && temp2>9'sb0) begin
                  comp_flag=1;
                  temp3=-temp1;
                  temp4=temp2;
                  end
                if(temp1>9'sb0 && temp2<9'sb0) begin
                  comp_flag=1;
                  temp3=temp1;
                  temp4=-temp2;
                  end
                x=temp3;
                y=temp4;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp3=t_x;
                  temp4=t_y;
                  end
                else begin
                  temp3=-t_x;
                  temp4=t_y;
                  end  
                r12=temp4;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp3*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pd=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pd=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pd=lambda1%p;
                  end
                x13=pointdoubling_x(lambda_pd,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                g_x1=x3;
                g_y1=y3;             
                end
              end   //pd when pa must be done
            else begin
              //pa
              temp11=g_y1-q_y;
              temp12=g_x1-q_x;
              if(temp12==8'sb0) begin
                g_x1=8'sb0;
                g_y1=8'sb0;
                end
              else begin
                if(temp11<9'sb0 && temp12<9'sb0) begin
                  temp1=-temp11;
                  temp2=-temp12;
                  comp_flag=0;
                  end
                if((temp11<9'sb0 && temp12>9'sb0)||(temp11>9'sb0 && temp12<9'sb0)) begin
                  comp_flag=1;
                  if(temp11<9'sb0) begin
                    temp1=-temp11;
                    temp2=temp12;
                   end
                  else begin
                    temp1=temp11;
                    temp2=-temp12;
                    end
                  end
                if(temp11>9'sb0 && temp12>9'sb0) begin
                  temp1=temp11;
                  temp2=temp12;
                  comp_flag=0;
                  end
                x=temp1;
                y=temp2;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp1=t_x;
                  temp2=t_y;
                  end
                else begin
                  temp1=-t_x;
                  temp2=t_y;
                  end  
                r12=temp2;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp1*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pa=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pa=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pa=lambda1%p;
                  end
                //end
                x13=pointaddition_x(lambda_pa,q_x,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointaddition_y(lambda_pa,q_x,x3,q_y);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                g_x1=x3;
                g_y1=y3;
                end   
              end// pa when pa must be done
            end
        
        // P=Q+P ends 
        // Q=2Q starts
        temp11=q_x*q_x;
        temp12=const_3*temp11;
        temp1=temp12+a;
        temp2=const_2*q_y;
        if(temp2==9'sb0) begin
          q_x=8'sb0;
          q_y=8'sb0;
          end
        else begin
          if(temp1<9'sb0 && temp2<9'sb0) begin
            comp_flag=0;
            temp3=-temp1;
            temp4=-temp2;
            end
          if(temp1>9'sb0 && temp2>9'sb0) begin
            comp_flag=0;
            temp3=temp1;
            temp4=temp2;
            end
          if(temp1<9'sb0 && temp2>9'sb0) begin
            comp_flag=1;
            temp3=-temp1;
            temp4=temp2;
            end
          if(temp1>9'sb0 && temp2<9'sb0) begin
            comp_flag=1;
            temp3=temp1;
            temp4=-temp2;
            end
          x=temp3;
          y=temp4;  
          for(z=21;z>1;z=z-1) begin
            t_x=x;
            t_y=y;
            if(t_x%z == 0 && t_y%z == 0) begin
              t_x=x/z;
              t_y=y/z;
              end
            x=t_x;
            y=t_y;
          end
          if(comp_flag==0) begin
            temp3=t_x;
            temp4=t_y;
            end
          else begin
            temp3=-t_x;
            temp4=t_y;
            end  
          r12=temp4;
          case(r12)
            8'b0000: begin
              mu=8'sb0000;   
              end
            8'b0001: begin
              mu=8'sb0001;   
              end
            8'b0010: begin
              mu=8'sb0110;
              end
            8'b0011: begin
              mu=8'sb0100;
              end
            8'b0100: begin
              mu=8'sb0011;   
              end
            8'b0101: begin
              mu=8'sb1001;   
              end
            8'b0110: begin
              mu=8'sb0010;   
              end
            8'b0111: begin
              mu=8'sb1000;   
              end
            8'b1000: begin
              mu=8'sb0111;   
              end
            8'b1001: begin
              mu=8'sb0101;   
              end
            8'b1010: begin
              mu=8'sb1010;   
              end
            8'b1100: begin
              mu=8'sb0001;   
              end
            8'b1110: begin
              mu=8'sb0100;   
              end
            8'b10010: begin
              mu=8'sb1000;   
              end
            8'b10100: begin
              mu=8'sb0101;   
              end
            endcase
          lambda1=temp3*mu;
          if(lambda1<12'sb0) begin
            check=-lambda1;
            if(check%p==0) begin
              lambda_pd=8'sb0;
              end
            else begin
              tt=check/p;
              lambda_pd=((tt+8'sb1)*p)+lambda1;
              end
            end
          else begin
            lambda_pd=lambda1%p;
            end
          x13=pointdoubling_x(lambda_pd,q_x);
          if(x13<8'sb0) begin
            check=-x13;
            if(check%p==0) begin
              x3=8'sb0;
              end
            else begin
              tt=check/p;
              x3=((tt+8'sb1)*p)+x13;
              end
            end
          else begin
            x3=x13%p;
            end
          y13=pointdoubling_y(lambda_pd,q_x,x3,q_y);
          if(y13<8'sb0) begin
            check=-y13;
            if(check%p==0) begin
              y3=8'sb0;
              end
            else begin
              tt=check/p;
              y3=((tt+8'sb1)*p)+y13;
              end
            end
          else begin
            y3=y13%p;
            end
          q_x=x3;
          q_y=y3;             
          end 
        
        // Q=2Q ends
        end//nb[i] is 0
        else
        begin
          // Q=Q+P starts
          
          if((q_x==8'sb0 && q_y==8'sb0)||(g_x1==8'sb0 && g_y1==8'sb0)||(q_x==g_x1 && q_y==-g_y1))begin
            if(q_x==g_x1 && q_y==-g_y1) begin
              q_x=8'sb0;
              q_y=8'sb0;
            end
            if(q_x==8'sb0 && q_y==8'sb0)begin
              q_x=g_x1;
              q_y=g_y1;
            end
            end
          else begin
            if(q_x==g_x1 && q_y==g_y1)begin
              //pd
              temp11=g_x1*g_x1;
              temp12=const_3*temp11;
              temp1=temp12+a;
              temp2=const_2*g_y1;
              if(temp2==9'sb0)begin
                q_x=8'sb0;
                q_y=8'sb0;
                end
              else begin
                if(temp1<9'sb0 && temp2<9'sb0) begin
                  comp_flag=0;
                  temp3=-temp1;
                  temp4=-temp2;
                  end
                if(temp1>9'sb0 && temp2>9'sb0) begin
                  comp_flag=0;
                  temp3=temp1;
                  temp4=temp2;
                  end
                if(temp1<9'sb0 && temp2>9'sb0) begin
                  comp_flag=1;
                  temp3=-temp1;
                  temp4=temp2;
                  end
                if(temp1>9'sb0 && temp2<9'sb0) begin
                  comp_flag=1;
                  temp3=temp1;
                  temp4=-temp2;
                  end
                x=temp3;
                y=temp4;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp3=t_x;
                  temp4=t_y;
                  end
                else begin
                  temp3=-t_x;
                  temp4=t_y;
                  end  
                r12=temp4;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp3*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pd=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pd=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pd=lambda1%p;
                  end
                x13=pointdoubling_x(lambda_pd,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                q_x=x3;
                q_y=y3;             
                end
              end   //pd when pa must be done
            else begin
              //pa
              temp11=g_y1-q_y;
              temp12=g_x1-q_x;
              if(temp12==8'sb0) begin
                q_x=8'sb0;
                q_y=8'sb0;
                end
              else begin
                if(temp11<9'sb0 && temp12<9'sb0) begin
                  temp1=-temp11;
                  temp2=-temp12;
                  comp_flag=0;
                  end
                if((temp11<9'sb0 && temp12>9'sb0)||(temp11>9'sb0 && temp12<9'sb0)) begin
                  comp_flag=1;
                  if(temp11<9'sb0) begin
                    temp1=-temp11;
                    temp2=temp12;
                   end
                  else begin
                    temp1=temp11;
                    temp2=-temp12;
                    end
                  end
                if(temp11>9'sb0 && temp12>9'sb0) begin
                  temp1=temp11;
                  temp2=temp12;
                  comp_flag=0;
                  end
                x=temp1;
                y=temp2;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp1=t_x;
                  temp2=t_y;
                  end
                else begin
                  temp1=-t_x;
                  temp2=t_y;
                  end  
                r12=temp2;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp1*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pa=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pa=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pa=lambda1%p;
                  end
                //end
                x13=pointaddition_x(lambda_pa,q_x,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointaddition_y(lambda_pa,q_x,x3,q_y);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                q_x=x3;
                q_y=y3;
                end   
              end// pa when pa must be done
            end
          // Q=Q+P ends
          
          // P=2P starts
          
        temp11=g_x1*g_x1;
        temp12=const_3*temp11;
        temp1=temp12+a;
        temp2=const_2*g_y1;
        if(temp2==9'sb0) begin
          g_x1=8'sb0;
          g_y1=8'sb0;
          end
        else begin
          if(temp1<9'sb0 && temp2<9'sb0) begin
            comp_flag=0;
            temp3=-temp1;
            temp4=-temp2;
            end
          if(temp1>9'sb0 && temp2>9'sb0) begin
            comp_flag=0;
            temp3=temp1;
            temp4=temp2;
            end
          if(temp1<9'sb0 && temp2>9'sb0) begin
            comp_flag=1;
            temp3=-temp1;
            temp4=temp2;
            end
          if(temp1>9'sb0 && temp2<9'sb0) begin
            comp_flag=1;
            temp3=temp1;
            temp4=-temp2;
            end
          x=temp3;
          y=temp4;  
          for(z=21;z>1;z=z-1) begin
            t_x=x;
            t_y=y;
            if(t_x%z == 0 && t_y%z == 0) begin
              t_x=x/z;
              t_y=y/z;
              end
            x=t_x;
            y=t_y;
          end
          if(comp_flag==0) begin
            temp3=t_x;
            temp4=t_y;
            end
          else begin
            temp3=-t_x;
            temp4=t_y;
            end  
          r12=temp4;
          case(r12)
            8'b0000: begin
              mu=8'sb0000;   
              end
            8'b0001: begin
              mu=8'sb0001;   
              end
            8'b0010: begin
              mu=8'sb0110;
              end
            8'b0011: begin
              mu=8'sb0100;
              end
            8'b0100: begin
              mu=8'sb0011;   
              end
            8'b0101: begin
              mu=8'sb1001;   
              end
            8'b0110: begin
              mu=8'sb0010;   
              end
            8'b0111: begin
              mu=8'sb1000;   
              end
            8'b1000: begin
              mu=8'sb0111;   
              end
            8'b1001: begin
              mu=8'sb0101;   
              end
            8'b1010: begin
              mu=8'sb1010;   
              end
            8'b1100: begin
              mu=8'sb0001;   
              end
            8'b1110: begin
              mu=8'sb0100;   
              end
            8'b10010: begin
              mu=8'sb1000;   
              end
            8'b10100: begin
              mu=8'sb0101;   
              end
            endcase
          lambda1=temp3*mu;
          if(lambda1<12'sb0) begin
            check=-lambda1;
            if(check%p==0) begin
              lambda_pd=8'sb0;
              end
            else begin
              tt=check/p;
              lambda_pd=((tt+8'sb1)*p)+lambda1;
              end
            end
          else begin
            lambda_pd=lambda1%p;
            end
          x13=pointdoubling_x(lambda_pd,g_x1);
          if(x13<8'sb0) begin
            check=-x13;
            if(check%p==0) begin
              x3=8'sb0;
              end
            else begin
              tt=check/p;
              x3=((tt+8'sb1)*p)+x13;
              end
            end
          else begin
            x3=x13%p;
            end
          y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
          if(y13<8'sb0) begin
            check=-y13;
            if(check%p==0) begin
              y3=8'sb0;
              end
            else begin
              tt=check/p;
              y3=((tt+8'sb1)*p)+y13;
              end
            end
          else begin
            y3=y13%p;
            end
          g_x1=x3;
          g_y1=y3;             
          end
          // P=2P ends
        end//nb[i] is 1
      end// for loop end
      cipher1_x=q_x;
      cipher1_y=q_y;
  
                   ///////////      Calculation of kPb     /////////////
                    
  q_x=9'sb0;
  q_y=9'sb0;
  g_x1=pb_x;
  g_y1=pb_y;
  for(i=2;i>-1;i=i-1)
      begin
        if(k[i]==1'sb0)
        begin
        // P=Q+P starts
        
        if((q_x==8'sb0 && q_y==8'sb0)||(g_x1==8'sb0 && g_y1==8'sb0)||(q_x==g_x1 && q_y==-g_y1))begin
            if(q_x==g_x1 && q_y==-g_y1) begin
              g_x1=8'sb0;
              g_y1=8'sb0;
            end
            if(g_x1==8'sb0 && g_y1==8'sb0)begin
              g_x1=q_x;
              g_y1=q_y;
            end
            end
          else begin
            if(q_x==g_x1 && q_y==g_y1)begin
              //pd
              temp11=g_x1*g_x1;
              temp12=const_3*temp11;
              temp1=temp12+a;
              temp2=const_2*g_y1;
              if(temp2==9'sb0)begin
                g_x1=8'sb0;
                g_y1=8'sb0;
                end
              else begin
                if(temp1<9'sb0 && temp2<9'sb0) begin
                  comp_flag=0;
                  temp3=-temp1;
                  temp4=-temp2;
                  end
                if(temp1>9'sb0 && temp2>9'sb0) begin
                  comp_flag=0;
                  temp3=temp1;
                  temp4=temp2;
                  end
                if(temp1<9'sb0 && temp2>9'sb0) begin
                  comp_flag=1;
                  temp3=-temp1;
                  temp4=temp2;
                  end
                if(temp1>9'sb0 && temp2<9'sb0) begin
                  comp_flag=1;
                  temp3=temp1;
                  temp4=-temp2;
                  end
                x=temp3;
                y=temp4;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp3=t_x;
                  temp4=t_y;
                  end
                else begin
                  temp3=-t_x;
                  temp4=t_y;
                  end  
                r12=temp4;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp3*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pd=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pd=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pd=lambda1%p;
                  end
                x13=pointdoubling_x(lambda_pd,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                g_x1=x3;
                g_y1=y3;             
                end
              end   //pd when pa must be done
            else begin
              //pa
              temp11=g_y1-q_y;
              temp12=g_x1-q_x;
              if(temp12==8'sb0) begin
                g_x1=8'sb0;
                g_y1=8'sb0;
                end
              else begin
                if(temp11<9'sb0 && temp12<9'sb0) begin
                  temp1=-temp11;
                  temp2=-temp12;
                  comp_flag=0;
                  end
                if((temp11<9'sb0 && temp12>9'sb0)||(temp11>9'sb0 && temp12<9'sb0)) begin
                  comp_flag=1;
                  if(temp11<9'sb0) begin
                    temp1=-temp11;
                    temp2=temp12;
                   end
                  else begin
                    temp1=temp11;
                    temp2=-temp12;
                    end
                  end
                if(temp11>9'sb0 && temp12>9'sb0) begin
                  temp1=temp11;
                  temp2=temp12;
                  comp_flag=0;
                  end
                x=temp1;
                y=temp2;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp1=t_x;
                  temp2=t_y;
                  end
                else begin
                  temp1=-t_x;
                  temp2=t_y;
                  end  
                r12=temp2;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp1*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pa=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pa=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pa=lambda1%p;
                  end
                //end
                x13=pointaddition_x(lambda_pa,q_x,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointaddition_y(lambda_pa,q_x,x3,q_y);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                g_x1=x3;
                g_y1=y3;
                end   
              end// pa when pa must be done
            end
        
        // P=Q+P ends 
        // Q=2Q starts
        temp11=q_x*q_x;
        temp12=const_3*temp11;
        temp1=temp12+a;
        temp2=const_2*q_y;
        if(temp2==9'sb0) begin
          q_x=8'sb0;
          q_y=8'sb0;
          end
        else begin
          if(temp1<9'sb0 && temp2<9'sb0) begin
            comp_flag=0;
            temp3=-temp1;
            temp4=-temp2;
            end
          if(temp1>9'sb0 && temp2>9'sb0) begin
            comp_flag=0;
            temp3=temp1;
            temp4=temp2;
            end
          if(temp1<9'sb0 && temp2>9'sb0) begin
            comp_flag=1;
            temp3=-temp1;
            temp4=temp2;
            end
          if(temp1>9'sb0 && temp2<9'sb0) begin
            comp_flag=1;
            temp3=temp1;
            temp4=-temp2;
            end
          x=temp3;
          y=temp4;  
          for(z=21;z>1;z=z-1) begin
            t_x=x;
            t_y=y;
            if(t_x%z == 0 && t_y%z == 0) begin
              t_x=x/z;
              t_y=y/z;
              end
            x=t_x;
            y=t_y;
          end
          if(comp_flag==0) begin
            temp3=t_x;
            temp4=t_y;
            end
          else begin
            temp3=-t_x;
            temp4=t_y;
            end  
          r12=temp4;
          case(r12)
            8'b0000: begin
              mu=8'sb0000;   
              end
            8'b0001: begin
              mu=8'sb0001;   
              end
            8'b0010: begin
              mu=8'sb0110;
              end
            8'b0011: begin
              mu=8'sb0100;
              end
            8'b0100: begin
              mu=8'sb0011;   
              end
            8'b0101: begin
              mu=8'sb1001;   
              end
            8'b0110: begin
              mu=8'sb0010;   
              end
            8'b0111: begin
              mu=8'sb1000;   
              end
            8'b1000: begin
              mu=8'sb0111;   
              end
            8'b1001: begin
              mu=8'sb0101;   
              end
            8'b1010: begin
              mu=8'sb1010;   
              end
            8'b1100: begin
              mu=8'sb0001;   
              end
            8'b1110: begin
              mu=8'sb0100;   
              end
            8'b10010: begin
              mu=8'sb1000;   
              end
            8'b10100: begin
              mu=8'sb0101;   
              end
            endcase
          lambda1=temp3*mu;
          if(lambda1<12'sb0) begin
            check=-lambda1;
            if(check%p==0) begin
              lambda_pd=8'sb0;
              end
            else begin
              tt=check/p;
              lambda_pd=((tt+8'sb1)*p)+lambda1;
              end
            end
          else begin
            lambda_pd=lambda1%p;
            end
          x13=pointdoubling_x(lambda_pd,q_x);
          if(x13<8'sb0) begin
            check=-x13;
            if(check%p==0) begin
              x3=8'sb0;
              end
            else begin
              tt=check/p;
              x3=((tt+8'sb1)*p)+x13;
              end
            end
          else begin
            x3=x13%p;
            end
          y13=pointdoubling_y(lambda_pd,q_x,x3,q_y);
          if(y13<8'sb0) begin
            check=-y13;
            if(check%p==0) begin
              y3=8'sb0;
              end
            else begin
              tt=check/p;
              y3=((tt+8'sb1)*p)+y13;
              end
            end
          else begin
            y3=y13%p;
            end
          q_x=x3;
          q_y=y3;             
          end 
        
        // Q=2Q ends
        end//nb[i] is 0
        else
        begin
          // Q=Q+P starts
          
          if((q_x==8'sb0 && q_y==8'sb0)||(g_x1==8'sb0 && g_y1==8'sb0)||(q_x==g_x1 && q_y==-g_y1))begin
            if(q_x==g_x1 && q_y==-g_y1) begin
              q_x=8'sb0;
              q_y=8'sb0;
            end
            if(q_x==8'sb0 && q_y==8'sb0)begin
              q_x=g_x1;
              q_y=g_y1;
            end
            end
          else begin
            if(q_x==g_x1 && q_y==g_y1)begin
              //pd
              temp11=g_x1*g_x1;
              temp12=const_3*temp11;
              temp1=temp12+a;
              temp2=const_2*g_y1;
              if(temp2==9'sb0)begin
                q_x=8'sb0;
                q_y=8'sb0;
                end
              else begin
                if(temp1<9'sb0 && temp2<9'sb0) begin
                  comp_flag=0;
                  temp3=-temp1;
                  temp4=-temp2;
                  end
                if(temp1>9'sb0 && temp2>9'sb0) begin
                  comp_flag=0;
                  temp3=temp1;
                  temp4=temp2;
                  end
                if(temp1<9'sb0 && temp2>9'sb0) begin
                  comp_flag=1;
                  temp3=-temp1;
                  temp4=temp2;
                  end
                if(temp1>9'sb0 && temp2<9'sb0) begin
                  comp_flag=1;
                  temp3=temp1;
                  temp4=-temp2;
                  end
                x=temp3;
                y=temp4;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp3=t_x;
                  temp4=t_y;
                  end
                else begin
                  temp3=-t_x;
                  temp4=t_y;
                  end  
                r12=temp4;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp3*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pd=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pd=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pd=lambda1%p;
                  end
                x13=pointdoubling_x(lambda_pd,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                q_x=x3;
                q_y=y3;             
                end
              end   //pd when pa must be done
            else begin
              //pa
              temp11=g_y1-q_y;
              temp12=g_x1-q_x;
              if(temp12==8'sb0) begin
                q_x=8'sb0;
                q_y=8'sb0;
                end
              else begin
                if(temp11<9'sb0 && temp12<9'sb0) begin
                  temp1=-temp11;
                  temp2=-temp12;
                  comp_flag=0;
                  end
                if((temp11<9'sb0 && temp12>9'sb0)||(temp11>9'sb0 && temp12<9'sb0)) begin
                  comp_flag=1;
                  if(temp11<9'sb0) begin
                    temp1=-temp11;
                    temp2=temp12;
                   end
                  else begin
                    temp1=temp11;
                    temp2=-temp12;
                    end
                  end
                if(temp11>9'sb0 && temp12>9'sb0) begin
                  temp1=temp11;
                  temp2=temp12;
                  comp_flag=0;
                  end
                x=temp1;
                y=temp2;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp1=t_x;
                  temp2=t_y;
                  end
                else begin
                  temp1=-t_x;
                  temp2=t_y;
                  end  
                r12=temp2;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp1*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pa=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pa=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pa=lambda1%p;
                  end
                //end
                x13=pointaddition_x(lambda_pa,q_x,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointaddition_y(lambda_pa,q_x,x3,q_y);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                q_x=x3;
                q_y=y3;
                end   
              end// pa when pa must be done
            end
          // Q=Q+P ends
          
          // P=2P starts
          
        temp11=g_x1*g_x1;
        temp12=const_3*temp11;
        temp1=temp12+a;
        temp2=const_2*g_y1;
        if(temp2==9'sb0) begin
          g_x1=8'sb0;
          g_y1=8'sb0;
          end
        else begin
          if(temp1<9'sb0 && temp2<9'sb0) begin
            comp_flag=0;
            temp3=-temp1;
            temp4=-temp2;
            end
          if(temp1>9'sb0 && temp2>9'sb0) begin
            comp_flag=0;
            temp3=temp1;
            temp4=temp2;
            end
          if(temp1<9'sb0 && temp2>9'sb0) begin
            comp_flag=1;
            temp3=-temp1;
            temp4=temp2;
            end
          if(temp1>9'sb0 && temp2<9'sb0) begin
            comp_flag=1;
            temp3=temp1;
            temp4=-temp2;
            end
          x=temp3;
          y=temp4;  
          for(z=21;z>1;z=z-1) begin
            t_x=x;
            t_y=y;
            if(t_x%z == 0 && t_y%z == 0) begin
              t_x=x/z;
              t_y=y/z;
              end
            x=t_x;
            y=t_y;
          end
          if(comp_flag==0) begin
            temp3=t_x;
            temp4=t_y;
            end
          else begin
            temp3=-t_x;
            temp4=t_y;
            end  
          r12=temp4;
          case(r12)
            8'b0000: begin
              mu=8'sb0000;   
              end
            8'b0001: begin
              mu=8'sb0001;   
              end
            8'b0010: begin
              mu=8'sb0110;
              end
            8'b0011: begin
              mu=8'sb0100;
              end
            8'b0100: begin
              mu=8'sb0011;   
              end
            8'b0101: begin
              mu=8'sb1001;   
              end
            8'b0110: begin
              mu=8'sb0010;   
              end
            8'b0111: begin
              mu=8'sb1000;   
              end
            8'b1000: begin
              mu=8'sb0111;   
              end
            8'b1001: begin
              mu=8'sb0101;   
              end
            8'b1010: begin
              mu=8'sb1010;   
              end
            8'b1100: begin
              mu=8'sb0001;   
              end
            8'b1110: begin
              mu=8'sb0100;   
              end
            8'b10010: begin
              mu=8'sb1000;   
              end
            8'b10100: begin
              mu=8'sb0101;   
              end
            endcase
          lambda1=temp3*mu;
          if(lambda1<12'sb0) begin
            check=-lambda1;
            if(check%p==0) begin
              lambda_pd=8'sb0;
              end
            else begin
              tt=check/p;
              lambda_pd=((tt+8'sb1)*p)+lambda1;
              end
            end
          else begin
            lambda_pd=lambda1%p;
            end
          x13=pointdoubling_x(lambda_pd,g_x1);
          if(x13<8'sb0) begin
            check=-x13;
            if(check%p==0) begin
              x3=8'sb0;
              end
            else begin
              tt=check/p;
              x3=((tt+8'sb1)*p)+x13;
              end
            end
          else begin
            x3=x13%p;
            end
          y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
          if(y13<8'sb0) begin
            check=-y13;
            if(check%p==0) begin
              y3=8'sb0;
              end
            else begin
              tt=check/p;
              y3=((tt+8'sb1)*p)+y13;
              end
            end
          else begin
            y3=y13%p;
            end
          g_x1=x3;
          g_y1=y3;             
          end
          // P=2P ends
        end//nb[i] is 1
      end// for loop end
      kpb_x=q_x;
      kpb_y=q_y;
      
      
      ///////////      Calculation of Pm+kPb(Ciphertext2)     /////////////
                 
  g_x1=pm_x;
  g_y1=pm_y;
  g_x2=kpb_x;
  g_y2=kpb_y;
  if((g_x1!=g_x2 && g_y1!=g_y2)||(g_x1!=g_x2 && g_y1==g_y2))
  begin
    if((g_x1==8'sb0 && g_y1==8'sb0)||(g_x2==8'sb0 && g_y2==8'sb0))
        begin
          if(g_x1==8'sb0 && g_y1==8'sb0)
          begin
            cipher2_x=g_x2;
            cipher2_y=g_y2;
          end
          else
          begin
            cipher2_x=g_x1;
            cipher2_y=g_y1;
          end
        end
    else
    begin
              temp11=g_y1-g_y2;
              temp12=g_x1-g_x2;
              if(temp12==8'sb0) begin
                g_x2=8'sb0;
                g_y2=8'sb0;
                end
              else begin
                if(temp11<=9'sb0 && temp12<9'sb0) begin
                  temp1=-temp11;
                  temp2=-temp12;
                  comp_flag=0;
                  end
                if((temp11<9'sb0 && temp12>9'sb0)||(temp11>9'sb0 && temp12<9'sb0)) begin
                  comp_flag=1;
                  if(temp11<9'sb0) begin
                    temp1=-temp11;
                    temp2=temp12;
                   end
                  else begin
                    temp1=temp11;
                    temp2=-temp12;
                    end
                  end
                if(temp11>9'sb0 && temp12>9'sb0) begin
                  temp1=temp11;
                  temp2=temp12;
                  comp_flag=0;
                  end
                x=temp1;
                y=temp2;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp1=t_x;
                  temp2=t_y;
                  end
                else begin
                  temp1=-t_x;
                  temp2=t_y;
                  end  
                r12=temp2;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp1*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pa=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pa=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pa=lambda1%p;
                  end
                //end
                x13=pointaddition_x(lambda_pa,g_x2,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointaddition_y(lambda_pa,g_x2,x3,g_y2);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                g_x2=x3;
                g_y2=y3;
                end
                cipher2_x=g_x2;
                cipher2_y=g_y2; 
              end
  end//pt addition
  else
  begin
    if(g_x1==g_x2 && g_y1==g_y2)
    begin
        temp11=g_x1*g_x1;
        temp12=const_3*temp11;
        temp1=temp12+a;
        temp2=const_2*g_y1;
        if(temp2==9'sb0) begin
          g_x1=8'sb0;
          g_y1=8'sb0;
          end
        else begin
          if(temp1<9'sb0 && temp2<9'sb0) begin
            comp_flag=0;
            temp3=-temp1;
            temp4=-temp2;
            end
          if(temp1>9'sb0 && temp2>9'sb0) begin
            comp_flag=0;
            temp3=temp1;
            temp4=temp2;
            end
          if(temp1<9'sb0 && temp2>9'sb0) begin
            comp_flag=1;
            temp3=-temp1;
            temp4=temp2;
            end
          if(temp1>9'sb0 && temp2<9'sb0) begin
            comp_flag=1;
            temp3=temp1;
            temp4=-temp2;
            end
          x=temp3;
          y=temp4;  
          for(z=21;z>1;z=z-1) begin
            t_x=x;
            t_y=y;
            if(t_x%z == 0 && t_y%z == 0) begin
              t_x=x/z;
              t_y=y/z;
              end
            x=t_x;
            y=t_y;
          end
          if(comp_flag==0) begin
            temp3=t_x;
            temp4=t_y;
            end
          else begin
            temp3=-t_x;
            temp4=t_y;
            end  
          r12=temp4;
          case(r12)
            8'b0000: begin
              mu=8'sb0000;   
              end
            8'b0001: begin
              mu=8'sb0001;   
              end
            8'b0010: begin
              mu=8'sb0110;
              end
            8'b0011: begin
              mu=8'sb0100;
              end
            8'b0100: begin
              mu=8'sb0011;   
              end
            8'b0101: begin
              mu=8'sb1001;   
              end
            8'b0110: begin
              mu=8'sb0010;   
              end
            8'b0111: begin
              mu=8'sb1000;   
              end
            8'b1000: begin
              mu=8'sb0111;   
              end
            8'b1001: begin
              mu=8'sb0101;   
              end
            8'b1010: begin
              mu=8'sb1010;   
              end
            8'b1100: begin
              mu=8'sb0001;   
              end
            8'b1110: begin
              mu=8'sb0100;   
              end
            8'b10010: begin
              mu=8'sb1000;   
              end
            8'b10100: begin
              mu=8'sb0101;   
              end
            endcase
          lambda1=temp3*mu;
          if(lambda1<12'sb0) begin
            check=-lambda1;
            if(check%p==0) begin
              lambda_pd=8'sb0;
              end
            else begin
              tt=check/p;
              lambda_pd=((tt+8'sb1)*p)+lambda1;
              end
            end
          else begin
            lambda_pd=lambda1%p;
            end
          x13=pointdoubling_x(lambda_pd,g_x1);
          if(x13<8'sb0) begin
            check=-x13;
            if(check%p==0) begin
              x3=8'sb0;
              end
            else begin
              tt=check/p;
              x3=((tt+8'sb1)*p)+x13;
              end
            end
          else begin
            x3=x13%p;
            end
          y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
          if(y13<8'sb0) begin
            check=-y13;
            if(check%p==0) begin
              y3=8'sb0;
              end
            else begin
              tt=check/p;
              y3=((tt+8'sb1)*p)+y13;
              end
            end
          else begin
            y3=y13%p;
            end
          g_x1=x3;
          g_y1=y3;             
          end 
          cipher2_x=g_x1;
          cipher2_y=g_y1;
    end//pt doubling
    else
    begin
      if(g_x1==g_x2 && g_y1==-g_y2)
      begin
        cipher2_x=8'sb0;
        cipher2_y=8'sb0;
      end//additive inverse
      else
      begin
        if((g_x1==8'sb0 && g_y1==8'sb0)||(g_x2==8'sb0 && g_y2==8'sb0))
        begin
          if(g_x1==8'sb0 && g_y1==8'sb0)
          begin
            cipher2_x=g_x2;
            cipher2_y=g_y2;
          end
          else
          begin
            cipher2_x=g_x1;
            cipher2_y=g_y1;
          end
        end// either or 0
      end//No additive inverse
    end//No pt doubling
  end// No pt addition
  
              //////////////////     Decryption     /////////////
              //////////////////     dC1           //////////////
              
  q_x=9'sb0;
  q_y=9'sb0;
  g_x1=cipher1_x;
  g_y1=cipher1_y;
  for(i=2;i>-1;i=i-1)
      begin
        if(nb[i]==1'sb0)
        begin
        // P=Q+P starts
        
        if((q_x==8'sb0 && q_y==8'sb0)||(g_x1==8'sb0 && g_y1==8'sb0)||(q_x==g_x1 && q_y==-g_y1))begin
            if(q_x==g_x1 && q_y==-g_y1) begin
              g_x1=8'sb0;
              g_y1=8'sb0;
            end
            if(g_x1==8'sb0 && g_y1==8'sb0)begin
              g_x1=q_x;
              g_y1=q_y;
            end
            end
          else begin
            if(q_x==g_x1 && q_y==g_y1)begin
              //pd
              temp11=g_x1*g_x1;
              temp12=const_3*temp11;
              temp1=temp12+a;
              temp2=const_2*g_y1;
              if(temp2==9'sb0)begin
                g_x1=8'sb0;
                g_y1=8'sb0;
                end
              else begin
                if(temp1<9'sb0 && temp2<9'sb0) begin
                  comp_flag=0;
                  temp3=-temp1;
                  temp4=-temp2;
                  end
                if(temp1>9'sb0 && temp2>9'sb0) begin
                  comp_flag=0;
                  temp3=temp1;
                  temp4=temp2;
                  end
                if(temp1<9'sb0 && temp2>9'sb0) begin
                  comp_flag=1;
                  temp3=-temp1;
                  temp4=temp2;
                  end
                if(temp1>9'sb0 && temp2<9'sb0) begin
                  comp_flag=1;
                  temp3=temp1;
                  temp4=-temp2;
                  end
                x=temp3;
                y=temp4;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp3=t_x;
                  temp4=t_y;
                  end
                else begin
                  temp3=-t_x;
                  temp4=t_y;
                  end  
                r12=temp4;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp3*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pd=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pd=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pd=lambda1%p;
                  end
                x13=pointdoubling_x(lambda_pd,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                g_x1=x3;
                g_y1=y3;             
                end
              end   //pd when pa must be done
            else begin
              //pa
              temp11=g_y1-q_y;
              temp12=g_x1-q_x;
              if(temp12==8'sb0) begin
                g_x1=8'sb0;
                g_y1=8'sb0;
                end
              else begin
                if(temp11<9'sb0 && temp12<9'sb0) begin
                  temp1=-temp11;
                  temp2=-temp12;
                  comp_flag=0;
                  end
                if((temp11<9'sb0 && temp12>9'sb0)||(temp11>9'sb0 && temp12<9'sb0)) begin
                  comp_flag=1;
                  if(temp11<9'sb0) begin
                    temp1=-temp11;
                    temp2=temp12;
                   end
                  else begin
                    temp1=temp11;
                    temp2=-temp12;
                    end
                  end
                if(temp11>9'sb0 && temp12>9'sb0) begin
                  temp1=temp11;
                  temp2=temp12;
                  comp_flag=0;
                  end
                x=temp1;
                y=temp2;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp1=t_x;
                  temp2=t_y;
                  end
                else begin
                  temp1=-t_x;
                  temp2=t_y;
                  end  
                r12=temp2;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp1*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pa=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pa=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pa=lambda1%p;
                  end
                //end
                x13=pointaddition_x(lambda_pa,q_x,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointaddition_y(lambda_pa,q_x,x3,q_y);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                g_x1=x3;
                g_y1=y3;
                end   
              end// pa when pa must be done
            end
        
        // P=Q+P ends 
        // Q=2Q starts
        temp11=q_x*q_x;
        temp12=const_3*temp11;
        temp1=temp12+a;
        temp2=const_2*q_y;
        if(temp2==9'sb0) begin
          q_x=8'sb0;
          q_y=8'sb0;
          end
        else begin
          if(temp1<9'sb0 && temp2<9'sb0) begin
            comp_flag=0;
            temp3=-temp1;
            temp4=-temp2;
            end
          if(temp1>9'sb0 && temp2>9'sb0) begin
            comp_flag=0;
            temp3=temp1;
            temp4=temp2;
            end
          if(temp1<9'sb0 && temp2>9'sb0) begin
            comp_flag=1;
            temp3=-temp1;
            temp4=temp2;
            end
          if(temp1>9'sb0 && temp2<9'sb0) begin
            comp_flag=1;
            temp3=temp1;
            temp4=-temp2;
            end
          x=temp3;
          y=temp4;  
          for(z=21;z>1;z=z-1) begin
            t_x=x;
            t_y=y;
            if(t_x%z == 0 && t_y%z == 0) begin
              t_x=x/z;
              t_y=y/z;
              end
            x=t_x;
            y=t_y;
          end
          if(comp_flag==0) begin
            temp3=t_x;
            temp4=t_y;
            end
          else begin
            temp3=-t_x;
            temp4=t_y;
            end  
          r12=temp4;
          case(r12)
            8'b0000: begin
              mu=8'sb0000;   
              end
            8'b0001: begin
              mu=8'sb0001;   
              end
            8'b0010: begin
              mu=8'sb0110;
              end
            8'b0011: begin
              mu=8'sb0100;
              end
            8'b0100: begin
              mu=8'sb0011;   
              end
            8'b0101: begin
              mu=8'sb1001;   
              end
            8'b0110: begin
              mu=8'sb0010;   
              end
            8'b0111: begin
              mu=8'sb1000;   
              end
            8'b1000: begin
              mu=8'sb0111;   
              end
            8'b1001: begin
              mu=8'sb0101;   
              end
            8'b1010: begin
              mu=8'sb1010;   
              end
            8'b1100: begin
              mu=8'sb0001;   
              end
            8'b1110: begin
              mu=8'sb0100;   
              end
            8'b10010: begin
              mu=8'sb1000;   
              end
            8'b10100: begin
              mu=8'sb0101;   
              end
            endcase
          lambda1=temp3*mu;
          if(lambda1<12'sb0) begin
            check=-lambda1;
            if(check%p==0) begin
              lambda_pd=8'sb0;
              end
            else begin
              tt=check/p;
              lambda_pd=((tt+8'sb1)*p)+lambda1;
              end
            end
          else begin
            lambda_pd=lambda1%p;
            end
          x13=pointdoubling_x(lambda_pd,q_x);
          if(x13<8'sb0) begin
            check=-x13;
            if(check%p==0) begin
              x3=8'sb0;
              end
            else begin
              tt=check/p;
              x3=((tt+8'sb1)*p)+x13;
              end
            end
          else begin
            x3=x13%p;
            end
          y13=pointdoubling_y(lambda_pd,q_x,x3,q_y);
          if(y13<8'sb0) begin
            check=-y13;
            if(check%p==0) begin
              y3=8'sb0;
              end
            else begin
              tt=check/p;
              y3=((tt+8'sb1)*p)+y13;
              end
            end
          else begin
            y3=y13%p;
            end
          q_x=x3;
          q_y=y3;             
          end 
        
        // Q=2Q ends
        end//nb[i] is 0
        else
        begin
          // Q=Q+P starts
          
          if((q_x==8'sb0 && q_y==8'sb0)||(g_x1==8'sb0 && g_y1==8'sb0)||(q_x==g_x1 && q_y==-g_y1))begin
            if(q_x==g_x1 && q_y==-g_y1) begin
              q_x=8'sb0;
              q_y=8'sb0;
            end
            if(q_x==8'sb0 && q_y==8'sb0)begin
              q_x=g_x1;
              q_y=g_y1;
            end
            end
          else begin
            if(q_x==g_x1 && q_y==g_y1)begin
              //pd
              temp11=g_x1*g_x1;
              temp12=const_3*temp11;
              temp1=temp12+a;
              temp2=const_2*g_y1;
              if(temp2==9'sb0)begin
                q_x=8'sb0;
                q_y=8'sb0;
                end
              else begin
                if(temp1<9'sb0 && temp2<9'sb0) begin
                  comp_flag=0;
                  temp3=-temp1;
                  temp4=-temp2;
                  end
                if(temp1>9'sb0 && temp2>9'sb0) begin
                  comp_flag=0;
                  temp3=temp1;
                  temp4=temp2;
                  end
                if(temp1<9'sb0 && temp2>9'sb0) begin
                  comp_flag=1;
                  temp3=-temp1;
                  temp4=temp2;
                  end
                if(temp1>9'sb0 && temp2<9'sb0) begin
                  comp_flag=1;
                  temp3=temp1;
                  temp4=-temp2;
                  end
                x=temp3;
                y=temp4;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp3=t_x;
                  temp4=t_y;
                  end
                else begin
                  temp3=-t_x;
                  temp4=t_y;
                  end  
                r12=temp4;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp3*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pd=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pd=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pd=lambda1%p;
                  end
                x13=pointdoubling_x(lambda_pd,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                q_x=x3;
                q_y=y3;             
                end
              end   //pd when pa must be done
            else begin
              //pa
              temp11=g_y1-q_y;
              temp12=g_x1-q_x;
              if(temp12==8'sb0) begin
                q_x=8'sb0;
                q_y=8'sb0;
                end
              else begin
                if(temp11<9'sb0 && temp12<9'sb0) begin
                  temp1=-temp11;
                  temp2=-temp12;
                  comp_flag=0;
                  end
                if((temp11<9'sb0 && temp12>9'sb0)||(temp11>9'sb0 && temp12<9'sb0)) begin
                  comp_flag=1;
                  if(temp11<9'sb0) begin
                    temp1=-temp11;
                    temp2=temp12;
                   end
                  else begin
                    temp1=temp11;
                    temp2=-temp12;
                    end
                  end
                if(temp11>9'sb0 && temp12>9'sb0) begin
                  temp1=temp11;
                  temp2=temp12;
                  comp_flag=0;
                  end
                x=temp1;
                y=temp2;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp1=t_x;
                  temp2=t_y;
                  end
                else begin
                  temp1=-t_x;
                  temp2=t_y;
                  end  
                r12=temp2;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp1*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pa=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pa=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pa=lambda1%p;
                  end
                //end
                x13=pointaddition_x(lambda_pa,q_x,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointaddition_y(lambda_pa,q_x,x3,q_y);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                q_x=x3;
                q_y=y3;
                end   
              end// pa when pa must be done
            end
          // Q=Q+P ends
          
          // P=2P starts
          
        temp11=g_x1*g_x1;
        temp12=const_3*temp11;
        temp1=temp12+a;
        temp2=const_2*g_y1;
        if(temp2==9'sb0) begin
          g_x1=8'sb0;
          g_y1=8'sb0;
          end
        else begin
          if(temp1<9'sb0 && temp2<9'sb0) begin
            comp_flag=0;
            temp3=-temp1;
            temp4=-temp2;
            end
          if(temp1>9'sb0 && temp2>9'sb0) begin
            comp_flag=0;
            temp3=temp1;
            temp4=temp2;
            end
          if(temp1<9'sb0 && temp2>9'sb0) begin
            comp_flag=1;
            temp3=-temp1;
            temp4=temp2;
            end
          if(temp1>9'sb0 && temp2<9'sb0) begin
            comp_flag=1;
            temp3=temp1;
            temp4=-temp2;
            end
          x=temp3;
          y=temp4;  
          for(z=21;z>1;z=z-1) begin
            t_x=x;
            t_y=y;
            if(t_x%z == 0 && t_y%z == 0) begin
              t_x=x/z;
              t_y=y/z;
              end
            x=t_x;
            y=t_y;
          end
          if(comp_flag==0) begin
            temp3=t_x;
            temp4=t_y;
            end
          else begin
            temp3=-t_x;
            temp4=t_y;
            end  
          r12=temp4;
          case(r12)
            8'b0000: begin
              mu=8'sb0000;   
              end
            8'b0001: begin
              mu=8'sb0001;   
              end
            8'b0010: begin
              mu=8'sb0110;
              end
            8'b0011: begin
              mu=8'sb0100;
              end
            8'b0100: begin
              mu=8'sb0011;   
              end
            8'b0101: begin
              mu=8'sb1001;   
              end
            8'b0110: begin
              mu=8'sb0010;   
              end
            8'b0111: begin
              mu=8'sb1000;   
              end
            8'b1000: begin
              mu=8'sb0111;   
              end
            8'b1001: begin
              mu=8'sb0101;   
              end
            8'b1010: begin
              mu=8'sb1010;   
              end
            8'b1100: begin
              mu=8'sb0001;   
              end
            8'b1110: begin
              mu=8'sb0100;   
              end
            8'b10010: begin
              mu=8'sb1000;   
              end
            8'b10100: begin
              mu=8'sb0101;   
              end
            endcase
          lambda1=temp3*mu;
          if(lambda1<12'sb0) begin
            check=-lambda1;
            if(check%p==0) begin
              lambda_pd=8'sb0;
              end
            else begin
              tt=check/p;
              lambda_pd=((tt+8'sb1)*p)+lambda1;
              end
            end
          else begin
            lambda_pd=lambda1%p;
            end
          x13=pointdoubling_x(lambda_pd,g_x1);
          if(x13<8'sb0) begin
            check=-x13;
            if(check%p==0) begin
              x3=8'sb0;
              end
            else begin
              tt=check/p;
              x3=((tt+8'sb1)*p)+x13;
              end
            end
          else begin
            x3=x13%p;
            end
          y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
          if(y13<8'sb0) begin
            check=-y13;
            if(check%p==0) begin
              y3=8'sb0;
              end
            else begin
              tt=check/p;
              y3=((tt+8'sb1)*p)+y13;
              end
            end
          else begin
            y3=y13%p;
            end
          g_x1=x3;
          g_y1=y3;             
          end
          // P=2P ends
        end//nb[i] is 1
      end// for loop end
      dc1_x=q_x;
      dc1_y=q_y;
      
       //////////////   C2 - dC1   /////////
             
  g_x1=cipher2_x;
  g_y1=cipher2_y;
  g_x2=dc1_x;
  if(dc1_y==8'sb0)
  begin
    g_y2=dc1_y;
  end
  else
  begin
    g_y2=-dc1_y+p;
  end
  if((g_x1!=g_x2 && g_y1!=g_y2)||(g_x1!=g_x2 && g_y1==g_y2))
  begin
    if((g_x1==8'sb0 && g_y1==8'sb0)||(g_x2==8'sb0 && g_y2==8'sb0))
        begin
          if(g_x1==8'sb0 && g_y1==8'sb0)
          begin
            out_x=g_x2;
            out_y=g_y2;
          end
          else
          begin
            out_x=g_x1;
            out_y=g_y1;
          end
        end
    else
    begin
              temp11=g_y1-g_y2;
              temp12=g_x1-g_x2;
              if(temp12==8'sb0) begin
                g_x2=8'sb0;
                g_y2=8'sb0;
                end
              else begin
                if(temp11<=9'sb0 && temp12<9'sb0) begin
                  temp1=-temp11;
                  temp2=-temp12;
                  comp_flag=0;
                  end
                if((temp11<9'sb0 && temp12>9'sb0)||(temp11>9'sb0 && temp12<9'sb0)) begin
                  comp_flag=1;
                  if(temp11<9'sb0) begin
                    temp1=-temp11;
                    temp2=temp12;
                   end
                  else begin
                    temp1=temp11;
                    temp2=-temp12;
                    end
                  end
                if(temp11>9'sb0 && temp12>9'sb0) begin
                  temp1=temp11;
                  temp2=temp12;
                  comp_flag=0;
                  end
                x=temp1;
                y=temp2;
                for(z=21;z>1;z=z-1) begin
                  t_x=x;
                  t_y=y;
                  if(t_x%z == 0 && t_y%z == 0) begin
                    t_x=x/z;
                    t_y=y/z;
                    end
                  x=t_x;
                  y=t_y;
                  end
                if(comp_flag==0) begin
                  temp1=t_x;
                  temp2=t_y;
                  end
                else begin
                  temp1=-t_x;
                  temp2=t_y;
                  end  
                r12=temp2;
                case(r12)
                  8'b0000: begin
                    mu=8'sb0000;   
                    end
                  8'b0001: begin
                    mu=8'sb0001;   
                    end
                  8'b0010: begin
                    mu=8'sb0110;
                    end
                  8'b0011: begin
                    mu=8'sb0100;
                    end
                  8'b0100: begin
                    mu=8'sb0011;   
                    end
                  8'b0101: begin
                    mu=8'sb1001;   
                    end
                  8'b0110: begin
                    mu=8'sb0010;   
                    end
                  8'b0111: begin
                    mu=8'sb1000;   
                    end
                  8'b1000: begin
                    mu=8'sb0111;   
                    end
                  8'b1001: begin
                    mu=8'sb0101;   
                    end
                  8'b1010: begin
                    mu=8'sb1010;   
                    end
                  8'b1100: begin
                    mu=8'sb0001;   
                    end
                  8'b1110: begin
                    mu=8'sb0100;   
                    end
                  8'b10010: begin
                    mu=8'sb1000;   
                    end
                  8'b10100: begin
                    mu=8'sb0101;   
                    end
                  endcase
                lambda1=temp1*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  if(check%p==0) begin
                    lambda_pa=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    lambda_pa=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  lambda_pa=lambda1%p;
                  end
                //end
                x13=pointaddition_x(lambda_pa,g_x2,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  if(check%p==0) begin
                    x3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  x3=x13%p;
                  end
                y13=pointaddition_y(lambda_pa,g_x2,x3,g_y2);
                if(y13<8'sb0) begin
                  check=-y13;
                  if(check%p==0) begin
                    y3=8'sb0;
                    end
                  else begin
                    tt=check/p;
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  y3=y13%p;
                  end
                g_x2=x3;
                g_y2=y3;
                end
                out_x=g_x2;
                out_y=g_y2; 
  end// non zero conditions
  end//pt addition
  else
  begin
    if(g_x1==g_x2 && g_y1==g_y2)
    begin
        temp11=g_x1*g_x1;
        temp12=const_3*temp11;
        temp1=temp12+a;
        temp2=const_2*g_y1;
        if(temp2==9'sb0) begin
          g_x1=8'sb0;
          g_y1=8'sb0;
          end
        else begin
          if(temp1<9'sb0 && temp2<9'sb0) begin
            comp_flag=0;
            temp3=-temp1;
            temp4=-temp2;
            end
          if(temp1>9'sb0 && temp2>9'sb0) begin
            comp_flag=0;
            temp3=temp1;
            temp4=temp2;
            end
          if(temp1<9'sb0 && temp2>9'sb0) begin
            comp_flag=1;
            temp3=-temp1;
            temp4=temp2;
            end
          if(temp1>9'sb0 && temp2<9'sb0) begin
            comp_flag=1;
            temp3=temp1;
            temp4=-temp2;
            end
          x=temp3;
          y=temp4;  
          for(z=21;z>1;z=z-1) begin
            t_x=x;
            t_y=y;
            if(t_x%z == 0 && t_y%z == 0) begin
              t_x=x/z;
              t_y=y/z;
              end
            x=t_x;
            y=t_y;
          end
          if(comp_flag==0) begin
            temp3=t_x;
            temp4=t_y;
            end
          else begin
            temp3=-t_x;
            temp4=t_y;
            end  
          r12=temp4;
          case(r12)
            8'b0000: begin
              mu=8'sb0000;   
              end
            8'b0001: begin
              mu=8'sb0001;   
              end
            8'b0010: begin
              mu=8'sb0110;
              end
            8'b0011: begin
              mu=8'sb0100;
              end
            8'b0100: begin
              mu=8'sb0011;   
              end
            8'b0101: begin
              mu=8'sb1001;   
              end
            8'b0110: begin
              mu=8'sb0010;   
              end
            8'b0111: begin
              mu=8'sb1000;   
              end
            8'b1000: begin
              mu=8'sb0111;   
              end
            8'b1001: begin
              mu=8'sb0101;   
              end
            8'b1010: begin
              mu=8'sb1010;   
              end
            8'b1100: begin
              mu=8'sb0001;   
              end
            8'b1110: begin
              mu=8'sb0100;   
              end
            8'b10010: begin
              mu=8'sb1000;   
              end
            8'b10100: begin
              mu=8'sb0101;   
              end
            endcase
          lambda1=temp3*mu;
          if(lambda1<12'sb0) begin
            check=-lambda1;
            if(check%p==0) begin
              lambda_pd=8'sb0;
              end
            else begin
              tt=check/p;
              lambda_pd=((tt+8'sb1)*p)+lambda1;
              end
            end
          else begin
            lambda_pd=lambda1%p;
            end
          x13=pointdoubling_x(lambda_pd,g_x1);
          if(x13<8'sb0) begin
            check=-x13;
            if(check%p==0) begin
              x3=8'sb0;
              end
            else begin
              tt=check/p;
              x3=((tt+8'sb1)*p)+x13;
              end
            end
          else begin
            x3=x13%p;
            end
          y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
          if(y13<8'sb0) begin
            check=-y13;
            if(check%p==0) begin
              y3=8'sb0;
              end
            else begin
              tt=check/p;
              y3=((tt+8'sb1)*p)+y13;
              end
            end
          else begin
            y3=y13%p;
            end
          g_x1=x3;
          g_y1=y3;             
          end 
          out_x=g_x1;
          out_y=g_y1;
    end//pt doubling
    else
    begin
      if(g_x1==g_x2 && g_y1==-g_y2)
      begin
        out_x=8'sb0;
        out_y=8'sb0;
      end//additive inverse
      else
      begin
        if((g_x1==8'sb0 && g_y1==8'sb0)||(g_x2==8'sb0 && g_y2==8'sb0))
        begin
          if(g_x1==8'sb0 && g_y1==8'sb0)
          begin
            out_x=g_x2;
            out_y=g_y2;
          end
          else
          begin
            out_x=g_x1;
            out_y=g_y1;
          end
        end// either or 0
      end//No additive inverse
    end//No pt doubling
  end// No pt addition
    end//reset end
  end//always end
  lut11invwith0 luu(out_x,out_y,out_msg);
  
  
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
  

  

  ///////     Point doubling      /////////
  function signed[7:0]pointdoubling_x;
     input signed[7:0]lambda_pd,x1;
     reg signed[7:0]temp1,temp2,x13;
      begin
       temp1=lambda_pd*lambda_pd;
       temp2=const_2*x1;
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
  

////////           lfsr3          ////////////
module lfsr3(clk,rst,x);
  input clk,rst;
  output [2:0]x;
  wire xx0,xx1,xx2;
  dff m0 (clk,rst,xx2,x[0]);
  dff m1 (clk,rst,x[0],x[1]);
  dff m2 (clk,rst,x[1],x[2]);
  assign xx0=x[2]^x[1];
  assign xx1=x[1]^xx0;
  assign xx2=x[0]^xx1;
endmodule


////////////////    LFSR    //////////////////
module lfsr(clk,rst,x);
  input clk,rst;
  output [3:0]x;
  wire xx0,xx1,xx2;
  dff m0 (clk,rst,xx2,x[0]);
  dff m1 (clk,rst,x[0],x[1]);
  dff m2 (clk,rst,x[1],x[2]);
  dff m3 (clk,rst,x[2],x[3]);
  assign xx0=x[2]^x[1];
  assign xx1=x[1]^xx0;
  assign xx2=x[0]^xx1;
endmodule



/////////         D flip flop        ////////////
module dff(clk,reset,d,q);
  input clk,reset,d;
  output reg q;
  initial 
  begin
    q=0;
  end
  always @ (posedge clk)
  begin
    if (reset==1)
      begin
        q=1;
      end
    else
      begin
        q=d;
      end
  end
endmodule