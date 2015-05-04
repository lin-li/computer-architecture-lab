module MEM_WB_Buffer(
  input clock, stall, reset, M_Halt,
  input M_WriteReg, M_WB,
  input[31:0] M_MemData, M_Num, 
  input[4:0] M_REG,
  input M_JALC,
  input[31:0] M_PCREG,
  output reg W_Halt,
  output reg W_WriteReg, W_WB,
  output reg[31:0] W_MemData, W_Num, 
  output reg[4:0] W_REG,
  output reg W_JALC,
  output reg[31:0] W_PCREG
);

  always @(clock)
    if (reset)
      begin
        W_Halt <= 0;
        W_WriteReg <= 0;
        W_WB <= 0;
        W_MemData <= 0;
        W_Num <= 0;
        W_REG <= 0;
        W_JALC <= 0;
        W_PCREG <= 0;
      end
    else if (~stall)
      begin
        W_Halt <= M_Halt;
        W_WriteReg <= M_WriteReg;
        W_WB <= M_WB;
        W_MemData <= M_MemData;
        W_Num <= M_Num;
        W_REG <= M_REG;
        W_JALC <= M_JALC;
        W_PCREG <= M_PCREG;
      end 
      
endmodule
