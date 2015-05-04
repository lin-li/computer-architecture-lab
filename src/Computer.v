include "CPU.v";

module Computer;

reg		clock;
reg		reset;
reg		stall;

initial begin
	clock = 1;
	reset = 1;
	stall = 0;
	$readmemb("test.mif", Memory.Mem);
	#0 reset = 0;
end

always
	#2 clock = ~clock;

wire	Halt;

always	@(posedge Halt) begin : EXPORT
	integer	file;
	integer i;
	file = $fopen("test.out");
	for (i = 0; i < 32; i = i + 1)
		$fwrite(file, "%b\n", CPU.RegFile.Reg[i]);
	for (i = 0; i < 10; i = i + 1) begin
		$fwrite(file, "%b", Memory.Mem[4*i] === 8'bx ? 8'b0 : Memory.Mem[4*i]);
		$fwrite(file, "%b", Memory.Mem[4*i+1] === 8'bx ? 8'b0 : Memory.Mem[4*i+1]);
		$fwrite(file, "%b", Memory.Mem[4*i+2] === 8'bx ? 8'b0 : Memory.Mem[4*i+2]);
		$fwrite(file, "%b\n", Memory.Mem[4*i+3] === 8'bx ? 8'b0 : Memory.Mem[4*i+3]);
	end
	for (i = 1<<17; i < (1<<17) + 10; i = i + 1) begin
		$fwrite(file, "%b", Memory.Mem[4*i] === 8'bx ? 8'b0 : Memory.Mem[4*i]);
		$fwrite(file, "%b", Memory.Mem[4*i+1] === 8'bx ? 8'b0 : Memory.Mem[4*i+1]);
		$fwrite(file, "%b", Memory.Mem[4*i+2] === 8'bx ? 8'b0 : Memory.Mem[4*i+2]);
		$fwrite(file, "%b\n", Memory.Mem[4*i+3] === 8'bx ? 8'b0 : Memory.Mem[4*i+3]);
	end
	$finish;
end

wire	CRead0;
wire	CWrite0;
wire	[31:0] CAddr0;
wire	[31:0] CReadData0;
wire	[31:0] CWriteData0;

wire	[31:0] CAddr1;
wire	[31:0] CReadData1;

CPU CPU(clock, stall, reset, Halt, CRead0, CWrite0, CAddr0, CReadData0, CWriteData0, CAddr1, CReadData1);
Memory Memory(CAddr1, CAddr0, CWriteData0, CRead0, CWrite0, CReadData1, CReadData0);

endmodule

