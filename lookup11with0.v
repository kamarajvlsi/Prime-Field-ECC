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