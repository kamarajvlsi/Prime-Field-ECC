module modulus(a,b,out);
  input signed[14:0]a,b;
  output signed[14:0]out;
  assign out=a%b;
endmodule