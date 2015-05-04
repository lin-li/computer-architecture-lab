module EXE_MEM_Buffer(
  input clock, stall, reset, E_Halt,
  input E_WriteReg, E_WB, E_ReadMem, E_WriteMem,
  input[31:0] E_Num, E_RegData_2, 
  input[4:0] E_REG,
  input E_JALC,
  input E_PCREG,
  output reg M_Halt,
  output reg M_WriteReg, M_WB, M_ReadMem, M_WriteMem, 
  output reg[31:0] M_Num, M_RegData_2, 
  output reg[4:0] M_REG,
  output reg M_JALC,
  output reg[31:0] M_PCREG 
);
  
  always @(clock)
    if (reset)
      begin
        M_Halt <= 0;
        M_WriteReg <= 0;
        M_WB <= 0;
        M_ReadMem <= 0;
        M_WriteMem <= 0;
        M_Num <= 0;
        M_RegData_2 <= 0;
        M_REG <= 0;
        M_JALC <= 0;
        M_PCREG <= 0;
      end
    else if (~stall)
      begin
        M_Halt <= E_Halt;
        M_WriteReg <= E_WriteReg;
        M_WB <= E_WB;
        M_ReadMem <= E_ReadMem;
        M_WriteMem <= E_WriteMem;
        M_Num <= E_Num;
        M_RegData_2 <= E_RegData_2;
        M_REG <= E_REG;
        M_JALC <= E_JALC;
        M_PCREG <= E_PCREG;
      end
     
endmodule