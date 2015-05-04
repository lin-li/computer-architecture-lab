module PC_Buffer(clock, stall, reset, PC_IN, PC);
  input clock, stall, reset;
  input[31:0] PC_IN;
  output reg[31:0] PC;
  
  always @(clock)
    if (reset)
      begin
        PC <= 0;
      end
    else if (!stall)
      begin
        PC <= PC_IN;
      end
      
endmodule