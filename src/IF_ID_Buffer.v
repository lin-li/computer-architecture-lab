module IF_ID_Buffer(clock, stall, reset, IF_Inst, IF_Addr, ID_Inst, ID_Addr);
  input clock, stall, reset;
  input[31:0] IF_Inst, IF_Addr;
  output reg[31:0] ID_Inst, ID_Addr;
  
  always @(clock)
    if (reset)
      begin
        ID_Inst <= 0;
        ID_Addr <= 0;
      end
    else if (~stall)
      begin
        ID_Inst <= IF_Inst;       
        ID_Addr <= IF_Addr;
      end

endmodule