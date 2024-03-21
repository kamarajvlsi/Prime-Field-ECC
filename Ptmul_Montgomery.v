module montgo_ptmulcheckll(clk,rst);
  input clk,rst;
  wire [2:0]nb;
  wire [3:0]g;
  wire signed[4:0]g_x,g_y;
  reg signed[7:0]q_x=8'sb0;
  reg signed[7:0]q_y=8'sb0;
  reg signed[7:0]pb_x,pb_y;
  reg signed[7:0]temp11;
  reg signed[9:0]temp12,temp1,temp3;
  reg signed[5:0]temp2,temp4,r12,mu;
  reg signed[9:0]x,t_x,tt; //tt[5:0]
  reg signed[5:0]y,t_y;
  reg signed[7:0]g_x1,g_y1;
  reg signed[7:0]const_3=8'sb11;
  reg signed[7:0]const_2=8'sb10;
  reg signed[7:0]a=8'sb1;
  reg signed[7:0]x13,x3,y13,y3;
  reg signed[9:0]lambda_pd,lambda_pa; //7:0
  reg signed[11:0]lambda1,check;
  reg signed[4:0]p=5'sb1011;
  reg signed[5:0]mod_x,mod_y;
  reg [11:0]a1,b1,p1;
  integer comp_flag,z;
  lfsr3 l31(clk,rst,nb);
  lfsr l1(clk,rst,g);
  lut11with0 lu1(g,g_x,g_y);
  integer i,j;
  
  always@(g_x or g_y) 
  begin
    if(rst==0)
    begin
                  ///////// Pb = nb*G  ////////////
      g_x1=g_x;
      g_y1=g_y;
      for(j=2;j>-1;j=j-1)
      begin
        if(nb[j]==1'sb0)
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
                for(z=11;z>1;z=z-1) begin
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
                  if(mod_x == 0 && mod_y == 0) begin
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
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  //check%p
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
                    lambda_pd=8'sb0;
                    end
                  else begin
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
                    lambda_pd=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  //lambda_pd=lambda1%p;
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
                  end
                x13=pointdoubling_x(lambda_pd,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  //check%p
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
                    x3=8'sb0;
                    end
                  else begin
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
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                 // x3=x13%p;
                  a1=x13;
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
                  x3=p1;
                  end
                y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
                if(y13<8'sb0) begin
                  check=-y13;
                  //check%p
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
                    y3=8'sb0;
                    end
                  else begin
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
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                 // y3=y13%p;
                  a1=y13;
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
                  y3=p1;
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
                for(z=11;z>1;z=z-1) begin
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
                  if(mod_x == 0 && mod_y == 0) begin
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
                lambda1=temp1*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  //check%p
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
                    lambda_pa=8'sb0;
                    end
                  else begin
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
                    lambda_pa=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
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
                  end
                //end
                x13=pointaddition_x(lambda_pa,q_x,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  //check%p
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
                    x3=8'sb0;
                    end
                  else begin
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
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  //x3=x13%p;
                   a1=x13;
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
                  x3=p1;
                  end
                y13=pointaddition_y(lambda_pa,q_x,x3,q_y);
                if(y13<8'sb0) begin
                  check=-y13;
                  //check%p
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
                    y3=8'sb0;
                    end
                  else begin
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
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  //y3=y13%p;
                   a1=y13;
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
                  y3=p1;
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
          for(z=11;z>1;z=z-1) begin
            t_x=x;
            t_y=y;
            if(t_x%z == 0 && t_y%z == 0) begin
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
          if(lambda1<12'sb0) begin
            check=-lambda1;
            //check%p
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
              lambda_pd=8'sb0;
              end
            else begin
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
              lambda_pd=((tt+8'sb1)*p)+lambda1;
              end
            end
          else begin
            //lambda_pd=lambda1%p;
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
            end
          x13=pointdoubling_x(lambda_pd,q_x);
          if(x13<8'sb0) begin
            check=-x13;
            //check%p
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
              x3=8'sb0;
              end
            else begin
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
              x3=((tt+8'sb1)*p)+x13;
              end
            end
          else begin
           // x3=x13%p;
            a1=x13;
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
                  x3=p1;
            end
          y13=pointdoubling_y(lambda_pd,q_x,x3,q_y);
          if(y13<8'sb0) begin
            check=-y13;
            //check%p
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
              y3=8'sb0;
              end
            else begin
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
              y3=((tt+8'sb1)*p)+y13;
              end
            end
          else begin
            //y3=y13%p;
             a1=y13;
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
                  y3=p1;
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
                for(z=11;z>1;z=z-1) begin
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
                  if(mod_x == 0 && mod_y == 0) begin
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
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  //check%p
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
                    lambda_pd=8'sb0;
                    end
                  else begin
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
                    lambda_pd=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
                  //lambda_pd=lambda1%p;
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
                  end
                x13=pointdoubling_x(lambda_pd,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  //check%p
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
                    x3=8'sb0;
                    end
                  else begin
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
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                 // x3=x13%p;
                  a1=x13;
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
                  x3=p1;
                  end
                y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
                if(y13<8'sb0) begin
                  check=-y13;
                  //check%p
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
                    y3=8'sb0;
                    end
                  else begin
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
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  //y3=y13%p;
                   a1=y13;
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
                  y3=p1;
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
                for(z=11;z>1;z=z-1) begin
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
                  if(mod_x == 0 && mod_y == 0) begin
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
                lambda1=temp1*mu;
                if(lambda1<12'sb0) begin
                  check=-lambda1;
                  //check%p
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
                    lambda_pa=8'sb0;
                    end
                  else begin
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
                    lambda_pa=((tt+8'sb1)*p)+lambda1;
                    end
                  end
                else begin
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
                  end
                //end
                x13=pointaddition_x(lambda_pa,q_x,g_x1);
                if(x13<8'sb0) begin
                  check=-x13;
                  //check%p
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
                    x3=8'sb0;
                    end
                  else begin
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
                    x3=((tt+8'sb1)*p)+x13;
                    end
                  end
                else begin
                  //x3=x13%p;
                   a1=x13;
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
                  x3=p1;
                  end
                y13=pointaddition_y(lambda_pa,q_x,x3,q_y);
                if(y13<8'sb0) begin
                  check=-y13;
                  //check%p
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
                    y3=8'sb0;
                    end
                  else begin
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
                    y3=((tt+8'sb1)*p)+y13;
                    end
                  end
                else begin
                  //y3=y13%p;
                   a1=y13;
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
                  y3=p1;
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
          for(z=11;z>1;z=z-1) begin
            t_x=x;
            t_y=y;
            //t_X%z
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
            if(mod_x == 0 && mod_y == 0) begin
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
          if(lambda1<12'sb0) begin
            check=-lambda1;
            //check%p
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
              lambda_pd=8'sb0;
              end
            else begin
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
              lambda_pd=((tt+8'sb1)*p)+lambda1;
              end
            end
          else begin
           // lambda_pd=lambda1%p;
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
            end
          x13=pointdoubling_x(lambda_pd,g_x1);
          if(x13<8'sb0) begin
            check=-x13;
            //check%p
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
              x3=8'sb0;
              end
            else begin
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
              x3=((tt+8'sb1)*p)+x13;
              end
            end
          else begin
            //x3=x13%p;
             a1=x13;
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
                  x3=p1;
            end
          y13=pointdoubling_y(lambda_pd,g_x1,x3,g_y1);
          if(y13<8'sb0) begin
            check=-y13;
            //check%p
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
              y3=8'sb0;
              end
            else begin
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
              y3=((tt+8'sb1)*p)+y13;
              end
            end
          else begin
            //y3=y13%p;
             a1=y13;
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
                  y3=p1;
            end
          g_x1=x3;
          g_y1=y3;             
          end
          // P=2P ends
        end//nb[i] is 1
      end// for loop end
      pb_x=q_x;
      pb_y=q_y;
    end //reset
  end //always
  
   //////////       Point addition       ////////////////
  function signed[11:0] pointaddition_x;
    input signed[11:0] lambda_pa,x1,x2;
    reg signed[11:0]temp3,temp4,x13;
    begin
    temp3=lambda_pa*lambda_pa;
    temp4=temp3-x1;
    pointaddition_x=temp4-x2;
    end
  endfunction
  
  function signed[11:0] pointaddition_y;
    input signed[11:0] lambda_pa,x1,x3,y1;
    reg signed[11:0]y13;
    reg signed[11:0]temp5,temp6;
    begin
    temp5=x1-x3;
    temp6=temp5*lambda_pa;
    pointaddition_y=temp6-y1;
    end
  endfunction
  

  

  ///////     Point doubling      /////////
  function signed[11:0]pointdoubling_x;
     input signed[11:0]lambda_pd,x1;
     reg signed[11:0]temp1,temp2,x13;
      begin
       temp1=lambda_pd*lambda_pd;
       temp2=const_2*x1;
        x13=temp1-temp2;
        pointdoubling_x=x13;
     end
  endfunction

  function signed[11:0]pointdoubling_y;
     input signed[11:0]lambda_pd,x1,x3,y1;
      reg signed[11:0]temp1,temp2,y13;
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


module lut11with0(a,x,y);
  input [3:0]a;
  output reg signed[4:0]x,y;
  
  // ECC curve with equation having    a=1   b=2  and p=11  ///
  always@(a)
  begin
    case(a)
      4'b0000:
      begin
        x<=5'sb0000;   //0
        y<=5'sb0000;   //0
      end
      4'b0001:
      begin 
        x<=5'sb0101;   //5
        y<=5'sb0000;   //0
      end
      4'b0010:
      begin 
        x<=5'sb0111;   //7
        y<=5'sb0000;   //0
      end
      4'b0011:
      begin 
        x<=5'sb1010;   //10
        y<=5'sb0000;   //0
      end
      4'b0100:
      begin 
        x<=5'sb0010;   //2
        y<=5'sb0001;   //1
      end
      4'b0101:
      begin 
        x<=5'sb0001;   //1
        y<=5'sb0010;   //2
      end
      4'b0110:
      begin 
        x<=5'sb0100;   //4
        y<=5'sb0010;   //2
      end
      4'b0111:
      begin 
        x<=5'sb0110;   //6
        y<=5'sb0010;   //2
      end
      4'b1000:
      begin 
        x<=5'sb1000;   //8
        y<=5'sb0100;   //4
      end
      4'b1001:
      begin 
        x<=5'sb1001;   //9
        y<=5'sb0101;   //5
      end
      4'b1010:
      begin 
        x<=5'sb1001;   //9
        y<=5'sb0110;   //6
      end
      4'b1011:
      begin 
        x<=5'sb1000;   //8
        y<=5'sb0111;   //7
      end
      4'b1100:
      begin 
        x<=5'sb0001;   //1
        y<=5'sb1001;   //9
      end
      4'b1101:
      begin 
        x<=5'sb0100;   //4
        y<=5'sb1001;   //9
      end
      4'b1110:
      begin 
        x<=5'sb0110;   //6
        y<=5'sb1001;   //9
      end
      4'b1111:
      begin 
        x<=5'sb0010;   //2
        y<=5'sb1010;   //10
      end
    endcase
  end
endmodule