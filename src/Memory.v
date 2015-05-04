module Memory(InstAddr, DataAddr, WriteData, ReadMem, WriteMem, ReadInst, ReadData);
  input[31:0] InstAddr, DataAddr, WriteData;
  input ReadMem, WriteMem;
  output[31:0] ReadInst;
  output[31:0] ReadData;
    
  reg[7:0] Mem[1024*1024-1:0];
  
  assign ReadInst = (WriteMem && (DataAddr == InstAddr)) ? WriteData : MemRead(InstAddr);
  assign ReadData = MemRead(DataAddr);
  
  function	[31:0] MemRead(
	input	[31:0] Addr
  );
	MemRead = {
		(Mem[Addr] === 8'bx ? 8'b0 : Mem[Addr]),
		(Mem[Addr+1] === 8'bx ? 8'b0 : Mem[Addr+1]),
		(Mem[Addr+2] === 8'bx ? 8'b0 : Mem[Addr+2]),
		(Mem[Addr+3] === 8'bx ? 8'b0 : Mem[Addr+3])};	
  endfunction
  
  always @(WriteMem, DataAddr, WriteData)
	if (WriteMem) begin
		Mem[DataAddr] = WriteData[31:24];
		Mem[DataAddr+1] = WriteData[23:16];
		Mem[DataAddr+2] = WriteData[15:8];
		Mem[DataAddr+3] = WriteData[7:0];
	end
	
endmodule

