module SA(IN, Control, OUT);
  input[31:0] IN;
  input Control;
  output[31:0] OUT;
  
  assign OUT[31:0] = (Control == 1)? {{27'b0}, {IN[10:6]}} : IN[31:0];
  
endmodule
  