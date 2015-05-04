include "RegFile.v";
include "Control.v";
include "ALU.v";
include "SignExt.v";
include "SA.v";
include "Memory.v";
include "PC_Buffer.v";
include "IF_ID_Buffer.v";
include "ID_EXE_Buffer.v";
include "EXE_MEM_Buffer.v";
include "MEM_WB_Buffer.v";


module CPU(clock, stall, reset, Halt, CRead0, CWrite0, CAddr0, CReadData0, CWriteData0, CAddr1, CReadData1);
  input clock;
  input stall;
  input reset;
  output	Halt;
	
	output	CRead0;
	output	CWrite0;
	output	[31:0] CAddr0;
	input	 [31:0] CReadData0;
	output	[31:0] CWriteData0;
	
	output	[31:0] CAddr1;
	input	 [31:0] CReadData1;
  
  
  ////////////////////////////////////////////////
  
  
  //Halt
  wire I_Halt;
  wire E_Halt;
  wire M_Halt;
  wire W_Halt;
    
  ///////////////////////////////////////////////
  
  //IF
  wire[31:0] PC_IN;
  wire[31:0] PC;
  
  wire[31:0] IF_Inst;
  wire[31:0] IF_Addr;
  
  //ID
  wire[31:0] ID_Inst;
  wire[31:0] ID_Addr;
  
  wire[5:0] func;
  wire[5:0] op;
  wire[4:0] rs;
  wire[4:0] rt;
  wire[4:0] rd;
  wire[25:0] address;
  wire[15:0] imm;
  wire[31:0] Wire_0;
  wire[31:0] Wire_1;
  wire[31:0] Wire_2;
  wire[31:0] Wire_3;
  wire[31:0] PC_Wire;
  wire[31:0] OUT_1;
  wire[31:0] OUT_2;
  
  wire WriteReg;
  wire WB;
  wire ReadMem;
  wire WriteMem;
  wire[3:0] ALUC;
  wire Shift;
  wire EXE;
  wire[31:0] EQU;
  wire SEXT;
  wire REGRT;
  wire[1:0] FWDB;
  wire[1:0] FWDA;
  wire Jump;
  wire JRC;
  wire JALC;
  wire Branch;
  
  wire PC_Stall;
  wire IF_ID_Stall;
  wire ID_EXE_Stall;
  wire EXE_MEM_Stall;
  wire MEM_WB_Stall;
  
  wire PC_Reset;
  wire IF_ID_Reset;
  wire ID_EXE_Reset;
  wire EXE_Mem_Reset;
  wire MEM_WB_Reset;
  
  wire[31:0] RegData_1;
  wire[31:0] RegData_2;
  wire[31:0] Imm;
  wire[4:0] REG;
  
  //EXE
  wire E_WriteReg;
  wire E_WB;
  wire E_ReadMem;
  wire E_WriteMem;
  wire[3:0] E_ALUC;
  wire E_EXE;
  wire E_Shift;
  wire[31:0] E_RegData_1;
  wire[31:0] E_RegData_2;
  wire[31:0] E_Imm;
  wire[4:0] E_REG;
  wire[31:0] Wire_4;
  wire[31:0] Wire_5;
  wire[31:0] E_Num;
  
  //MEM
  wire M_WriteReg;
  wire M_WB;
  wire M_ReadMem;
  wire M_WriteMem;
  wire[31:0] M_Num;
  wire[31:0] M_RegData_2;
  wire[4:0] M_REG;
  wire[31:0] M_MemData;
  
  //WB
  wire W_WriteReg;
  wire W_WB;
  wire[31:0] W_MemData;
  wire[31:0] W_Num;
  wire[4:0] W_REG;
  wire[31:0] WB_Wire;
  
  ///////////////////////////////////////////////////////
  
  //IF
  assign IF_Inst = PC + 4;
  assign PC_IN = /*(SMC == 1)? (E_PC - 4) : */(Branch == 0)? IF_Inst : PC_Wire;
  
  //ID
  assign func[5:0] = ID_Addr[5:0];
  assign op[5:0] = ID_Addr[31:26];
  assign rs[4:0] = ID_Addr[25:21];
  assign rt[4:0] = ID_Addr[26:16];
  assign rd[4:0] = ID_Addr[15:11];
  assign imm[15:0] = ID_Addr[15:0];
  assign address[25:0] = ID_Addr[25:0];
  
  assign Wire_0 = ID_Inst - 4;
  assign Wire_1 = {Wire_0[31:28], address, 2'b00};
  assign Wire_2 = ID_Inst + {{14{imm[15]}}, imm, 2'b00};
  assign Wire_3 = (Jump == 0)? Wire_2 : Wire_1;
  assign PC_Wire = (JRC == 0)? Wire_3 : RegData_1; 

  assign RegData_1 = (FWDA == 0)? OUT_1 : ((FWDA == 1)? E_Num : ((FWDA == 2)? M_Num : M_MemData));
  assign RegData_2 = (FWDB == 0)? OUT_2 : ((FWDB == 1)? E_Num : ((FWDB == 2)? M_Num : M_MemData));
  
  assign EQU = RegData_1 - RegData_2;
  
  assign REG = (REGRT == 0)? rd : rt;
  
  //EXE
  assign Wire_5 = (E_EXE == 1)? Wire_4 : E_RegData_2;
  
  //WB
  assign WB_Wire = (W_WB == 0)? W_Num : W_MemData;
  
  //////////////////////////////////////////////////////////
  
  wire E_JALC;
  wire M_JALC;
  wire W_JALC;
  
  wire[31:0] E_PCREG;
  wire[31:0] M_PCREG;
  wire[31:0] W_PCREG;
  
  PC_Buffer PCBuffer(clock, PC_Stall || stall, PC_Reset || reset, PC_IN, PC);
  
  IF_ID_Buffer IFIDBuffer(
    clock, IF_ID_Stall || stall, IF_ID_Reset || reset,
    IF_Inst, IF_Addr, 
    ID_Inst, ID_Addr
    );
    
  
  ID_EXE_Buffer IDEXEBuffer(
    clock, ID_EXE_Stall || stall, ID_EXE_Reset || reset, 
    I_Halt,
    WriteReg, WB, ReadMem, WriteMem, Shift, EXE, ALUC, RegData_1, RegData_2, Imm, REG,
    JALC,
    ID_Inst,
    E_Halt,
    E_WriteReg, E_WB, E_ReadMem, E_WriteMem, E_Shift, E_EXE, E_ALUC, E_RegData_1, E_RegData_2, E_Imm, E_REG,
    E_JALC,
    E_PCREG
  );
  
  EXE_MEM_Buffer EXEMEMBuffer(
    clock, EXE_MEM_Stall || stall, EXE_MEM_Reset || reset,
    E_Halt,
    E_WriteReg, E_WB, E_ReadMem, E_WriteMem, E_Num, E_RegData_2, E_REG,
    E_JALC,
    E_PCREG,
    M_Halt,
    M_WriteReg, M_WB, M_ReadMem, M_WriteMem, M_Num, M_RegData_2, M_REG,
    M_JALC,
    M_PCREG
  );
  
  MEM_WB_Buffer MEMWBBuffer(
    clock, MEM_WB_Stall || stall, MEM_WB_Reset || reset,
    M_Halt,
    M_WriteReg, M_WB, M_MemData, M_Num, M_REG,
    M_JALC,
    M_PCREG,
    W_Halt,
    W_WriteReg, W_WB, W_MemData, W_Num, W_REG,
    W_JALC,
    W_PCREG
  );
  
  ////////////////////////////////////////////////////////////
  
  //Memory
  //Memory Memory(PC, M_Num, M_RegData_2, M_ReadMem, M_WriteMem, IF_Addr, M_MemData);
  
  //Regiter File
  RegFile RegFile(reset, rs, rt, W_REG, WB_Wire, W_WriteReg, W_JALC, W_PCREG, OUT_1, OUT_2);
  
  Control Control(
    op, func,
    //rs,rt,
    EQU,
    WriteReg,
    WB,
    ReadMem,
    WriteMem,
    ALUC, 
    Shift,
    EXE,
    SEXT,
    REGRT,
    Jump,
    JRC,
    JALC,
    Branch,
    I_Halt
   );

   //ALU
   ALU ALU(E_RegData_1, Wire_5, E_ALUC, E_Num);
   
   //SE
   SignExt SE(imm, SEXT, Imm);
   
   //SA
   SA SA(E_Imm, E_Shift, Wire_4);  
   
   ////////////////////////////////////////////////////////////////////
   
   //forwarding
   
   assign FWDA[1:0] = (E_WriteReg && (E_REG == rs) && (E_REG != 0))? 2'b01 : ((M_WriteReg && (M_REG == rs) && ~ReadMem && (M_REG != 0)) ? 2'b10 : ((M_WriteReg && (M_REG == rs) && ReadMem && (M_REG != 0))? 2'b11 : 2'b00));
   
   assign FWDB[1:0] = (E_WriteReg && (E_REG == rt) && (E_REG != 0))? 2'b01 : ((M_WriteReg && (M_REG == rt) && ~ReadMem && (M_REG != 0)) ? 2'b10 : ((M_WriteReg && (M_REG == rt) && ReadMem && (M_REG != 0))? 2'b11 : 2'b00));
   
   
   //stall
   wire bubble = WriteMem || ReadMem || E_WriteMem || E_ReadMem || M_WriteMem || M_ReadMem;
   
   assign PC_Stall = bubble;
   assign IF_ID_Stall = bubble;
   assign ID_EXE_Stall = 0;
   assign EXE_MEM_Stall = 0;
   assign MEM_WB_Stall = 0;
   
   //reset
   assign PC_Reset = 0;
   assign IF_ID_Reset = Branch || bubble;
   assign ID_EXE_Reset = 0;
   assign EXE_MEM_Reset = 0;
   assign MEM_WEB_Reset = 0;
  
   //////////////////////////////////////////////////////////////////
   
   //Port
   assign	CRead0 = M_ReadMem;
   assign	CWrite0 = M_WriteMem;
   assign	CAddr0 = M_Num;
   assign	M_MemData = CReadData0;
   assign	CWriteData0 = (M_WriteMem && W_REG == M_REG) ? WB_Wire : M_RegData_2;
   assign	CAddr1 = PC;
   assign	IF_Addr = CReadData1;
   
   ///////////////////////////////////////////////////////////////////
   
   assign Halt = W_Halt;
   
endmodule