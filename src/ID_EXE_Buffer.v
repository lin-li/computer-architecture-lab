module ID_EXE_Buffer(
  input clock, stall, reset, I_Halt,
  input WriteReg, WB, ReadMem, WriteMem, Shift, EXE,
  input[3:0] ALUC,
  input[31:0] RegData_1, RegData_2, Imm, 
  input[4:0] REG,
  input JALC,
  input[31:0] PCREG,
  output reg E_Halt,
  output reg E_WriteReg, E_WB, E_ReadMem, E_WriteMem, E_Shift, E_EXE,
  output reg[3:0] E_ALUC,
  output reg[31:0] E_RegData_1, E_RegData_2, E_Imm, 
  output reg[4:0] E_REG,
  output reg E_JALC,
  output reg[31:0] E_PCREG
);

  always @(clock)
    if (reset)
      begin
        E_Halt <= 0;
        E_WriteReg <= 0;
        E_WB <= 0;
        E_ReadMem <= 0;
        E_WriteMem <= 0;
        E_Shift <= 0;
        E_EXE <= 0;
        E_ALUC <= 0;
        E_RegData_1 <= 0;
        E_RegData_2 <= 0;
        E_Imm <= 0;
        E_REG <= 0;
        E_JALC <= 0;
        E_PCREG <= 0;
      end
    else if (~stall)
      begin
        E_Halt <= I_Halt;
        E_WriteReg <= WriteReg;
        E_WB <= WB;
        E_ReadMem <= ReadMem;
        E_WriteMem <= WriteMem;
        E_Shift <= Shift;
        E_EXE <= EXE;
        E_ALUC <= ALUC;
        E_RegData_1 <= RegData_1;
        E_RegData_2 <= RegData_2;
        E_Imm <= Imm;
        E_REG <= REG;
        E_JALC <= JALC;
        E_PCREG <= PCREG;
      end 
  
  
endmodule