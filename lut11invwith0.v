module lut11invwith0(x,y,a);
  input signed[7:0]x,y;
  output reg [3:0]a;
  always @(x or y)
  begin 
    case (y)
      
      //y-variable == 0
      8'sb0000:
      begin
        case(x)
          8'sb0000:   a<=4'b0000;    //0
          8'sb0101:   a<=4'b0001;    //5
          8'sb0111:   a<=4'b0010;    //7
          8'sb1010:   a<=4'b0011;    //10          
        endcase
      end
    
      //y-variable == 1
      8'sb0001:
      begin
        case(x)
          8'sb0010:   a<=4'b0100;    //2
        endcase
      end
      
      //y-variable == 2
      8'sb0010:
      begin
        case(x)
          8'sb0001:   a<=4'b0101;   //1
          8'sb0100:   a<=4'b0110;   //4
          8'sb0110:   a<=4'b0111;   //6
        endcase
      end
      
      //y-variable == 4
      8'sb0100:
      begin
        case(x)
          8'sb1000:   a<=4'b1000;   //8
        endcase
      end
      
      //y-variable == 5
      8'sb0101:
      begin
        case(x)
          8'sb1001:   a<=4'b1001;   //9
        endcase
      end
      
      //y-variable == 6
      8'sb0110:
      begin
        case(x)
          8'sb1001:   a<=4'b1010;   //9
        endcase
      end
      
     //y-variable == 7
     8'sb0111:
     begin
       case(x)
         8'sb1000:   a<=4'b1011;    //8
       endcase
     end
     
     //y-variable == 9
     8'sb1001:
     begin
       case(x)
         8'sb0001:   a<=4'b1100;    //1
         8'sb0100:   a<=4'b1101;    //4
         8'sb0110:   a<=4'b1110;    //6
        endcase
      end
      
      //y-variable == 10
      8'sb1010:
      begin
        case(x)
          8'sb0010:   a<=4'b1111;   //2
        endcase
      end
    endcase
  end
endmodule