module ALU(A, B, ALUC, R);
  input[31:0] A, B;
  input[3:0] ALUC;
  output reg[31:0] R;
  
  //ALU_OP
  localparam ADD  = 4'b0000; 
  localparam AND  = 4'b0001;
  localparam NOR  = 4'b0010;
  localparam OR   = 4'b0011;
  localparam SLT  = 4'b0100;
  localparam SLL  = 4'b0101;
  localparam SRL  = 4'b0110;
  localparam SUB  = 4'b0111;
  localparam LUI  = 4'b1000;
  
  always @(A or B or ALUC)
    case (ALUC)
      ADD: R = A + B;
      AND: R = A & B;
      NOR: R = A ^ B;
      OR : R = A | B;
      SLT: R = (A < B)? 1 : 0;
      SUB: R = A - B;
      SLL: R = A << B;
      SRL: R = A >> B;
      LUI: R = B << 5'b10000;
    endcase
  
endmodule
    
          
