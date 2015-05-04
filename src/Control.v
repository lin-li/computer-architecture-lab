module Control(
  input[5:0]  Op, 
  input[5:0]  Func,
  //input[4:0] RS, RT,
  input[31:0] EQU,
  output reg WriteReg,
  output reg WB,
  output reg ReadMem,
  output reg WriteMem,
  output reg[3:0] ALUC,
  output reg Shift,
  output reg EXE,
  output reg SEXT,
  output reg REGRT,
  output reg Jump,
  output reg JRC,
  output reg JALC, 
  output reg Branch = 0,
  output reg Halt = 0
);
  
  //opcode
  localparam  ROP   = 6'b000000;
  localparam  ADDI  = 6'b001000;
  localparam  ANDI  = 6'b001100;
  localparam  BEQ   = 6'b000100;
  localparam  BNE   = 6'b000101;
  localparam  J     = 6'b000010;
  localparam  JAL   = 6'b000011;
  localparam  LW    = 6'b100011;
  localparam  LUI   = 6'b001111;
  localparam  ORI   = 6'b001101;
  localparam  SLTI  = 6'b001010;
  localparam  SW    = 6'b101011;
  localparam  HALT  = 6'b111111;

  //func
  localparam  ADD   = 6'b100000;    
  localparam  AND   = 6'b100100;
  localparam  JR    = 6'b001000;
  localparam  NOR   = 6'b100111;
  localparam  OR    = 6'b100101;
  localparam  SLT   = 6'b101010;
  localparam  SLL   = 6'b000000;
  localparam  SRL   = 6'b000010;
  localparam  SUB   = 6'b100010;
  
  /*
  always @(E_WriteReg or M_WriteReg or E_REG or M_REG or M_WB or RS or RT)
  begin
    FWDA <= 0; 
    FWDB <= 0;
    if (E_WriteReg && (E_REG != 0) && (E_REG == RS)) FWDA <= 2'b01;
      else if (E_WriteReg && (E_REG != 0) && (E_REG == RT)) FWDB <= 2'b01;
        else if (M_WriteReg && (E_REG != 0) && (M_REG == RS) && !M_WB) FWDA <= 2'b10;
          else if (M_WriteReg && (E_REG != 0) && (M_REG == RT) && !M_WB) FWDB <= 2'b10;
            else if (M_WriteReg && (E_REG != 0) && (M_REG == RS) && M_WB) FWDA <= 2'b11;
              else if (M_WriteReg && (E_REG != 0) && (M_REG == RT) && M_WB) FWDB <= 2'b11;
  end
  */
  
  /*
  always @(E_ReadMem or RS or RT or E_REG)
  begin
    PC_Stall <= 0;
    IF_ID_Stall <= 0;
    ID_EXE_Stall <= 0;
    EXE_MEM_Stall <= 0;
    MEM_WB_Stall <= 0;
    if (ReadMem && ((E_REG == RS) || (E_REG == RT)))
      begin
        PC_Stall <= 1;
        IF_ID_Stall <= 1;
        ID_EXE_Stall <= 1;
        end                                                          
    end
    */
    
    always @(Op or Func or EQU)
    begin
      WriteReg <= 0;
      WriteMem <= 0;
      ReadMem <= 0;
      WB <= 0;
      SEXT <= 0;
      EXE <= 0;
      Shift <= 0;
      Jump <= 0;
      JRC <= 0;
      JALC <= 0;
      Branch <= 0;
      Halt <= 0;
      
      case (Op)
        ROP : 
          case (Func)
            ADD:  begin WriteReg <= 1; REGRT <= 0; ALUC <= ALU.ADD; end 
            AND:  begin WriteReg <= 1; REGRT <= 0; ALUC <= ALU.AND; end
            JR :  begin JRC <= 1; Branch <= 1; end 
            NOR:  begin WriteReg <= 1; REGRT <= 0; ALUC <= ALU.NOR; end
            OR :  begin WriteReg <= 1; REGRT <= 0; ALUC <= ALU.OR;  end
            SLT:  begin WriteReg <= 1; REGRT <= 0; ALUC <= ALU.SLT; end
            SLL:  begin WriteReg <= 1; REGRT <= 0; Shift <= 1; EXE <= 1; ALUC <= ALU.SLL; end
            SRL:  begin WriteReg <= 1; REGRT <= 0; Shift <= 1; EXE <= 1; ALUC <= ALU.SRL; end
            SUB:  begin WriteReg <= 1; REGRT <= 0; ALUC <= ALU.SUB; end
          endcase
        
        ADDI: begin WriteReg <= 1; REGRT <= 1; EXE <= 1; ALUC <= ALU.ADD; end
        ANDI: begin WriteReg <= 1; REGRT <= 1; SEXT <= 1; EXE <= 1; ALUC <= ALU.AND; end
        BEQ : begin 
                if (EQU == 0) 
                  begin
                    Branch <= 1;
                  end
                else Branch <= 0;
              end
        BNE : begin 
                if (EQU != 0)
                  Branch <= 1;
                else Branch <= 0;
              end
        J   : begin Jump <= 1; Branch <= 1; end
        JAL : begin JALC <= 1; Jump <= 1; Branch <= 1;  end
        LUI : begin WriteReg <= 1; REGRT <= 1; EXE <= 1; ALUC <= ALU.LUI; end
        LW  : begin WriteReg <= 1; REGRT <= 1; EXE <= 1; ALUC <= ALU.ADD; ReadMem <= 1; WB <= 1; end
        ORI : begin WriteReg <= 1; REGRT <= 1; SEXT <= 1; EXE <= 1; ALUC <= ALU.OR; end
        SLTI: begin WriteReg <= 1; REGRT <= 1; EXE <= 1; ALUC <= ALU.SLT; end
        SW  : begin EXE <= 1; REGRT <= 1; WriteMem <= 1; ALUC <= ALU.ADD; end
        HALT: begin Halt <= 1; end
        default: ;
    endcase
  end
  
endmodule 