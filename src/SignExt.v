module SignExt(IN, SEXT, OUT);
  input[15:0] IN;
  input SEXT;
  output[31:0] OUT;
  
  assign OUT[15:0] = IN[15:0];
  assign OUT[31:16] = (SEXT == 0) ? {16{IN[15]}} : {16'h0000, IN};
  
endmodule
  
   