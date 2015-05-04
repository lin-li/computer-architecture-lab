module RegFile(reset, N1, N2, ND, DI, WriteReg, JALC, Data, Q1, Q2);
  input reset;
  input[4:0] N1, N2, ND;
  input[31:0] DI; 
  input WriteReg, JALC;
  input[31:0] Data;
  output[31:0] Q1, Q2;
  
  reg [31:0] Reg [31:0];
  
  assign Q1 = (WriteReg == 1 && (N1 == ND))? DI : Reg[N1];
  assign Q2 = (WriteReg == 1 && (N2 == ND))? DI : Reg[N2];
  
  always @(WriteReg or ND or DI)
    if (WriteReg == 1)
      Reg[ND] <= DI;
  
  always @(posedge JALC)
      Reg[31] <= Data;
      
  integer i;
  always @(reset)
    for (i = 0; i < 32; i = i + 1)
      Reg[i] <= 0;
    
  endmodule