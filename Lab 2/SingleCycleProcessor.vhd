library ieee;
use ieee.std_logic_1164.all;

entity SingleCycleProcessor is
	port(
		GClock, GReset : in std_logic;
		ValueSelect : in std_logic_vector(2 downto 0);
		MuxOut : out std_logic_vector(7 downto 0);
		InstructionOut : out std_logic_vector(31 downto 0);
		BranchOut, ZeroOut, MemWriteOut, RegWriteOut : out std_logic
	);
end SingleCycleProcessor;

architecture rtl of SingleCycleProcessor is

SIGNAL instruction: std_logic_vector(31 downto 0);
SIGNAL jumpCode, jumpShiftOut : std_logic_vector(25 downto 0);
SIGNAL opCode, funct : std_logic_vector(5 downto 0);
SIGNAL rs, rt, rd, writeRegMuxOut : std_logic_vector(4 downto 0);
SIGNAL readD1, readD2, ALUResult, PCOut, PCALUOut, signExtendOut, readDataOut, jumpAddress : std_logic_vector(7 downto 0);
SIGNAL aluBMuxOut, writeDataMuxOut, jumpMuxOut, branchMuxOut, branchALUOut : std_logic_vector(7 downto 0);
SIGNAL immediate, immedShiftOut : std_LOGIC_VECTOR(15 downto 0);
SIGNAL RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, BEQSel : std_LOGIC;
SIGNAL branchSel, Zero : std_logic;
SIGNAL ALUOp : std_logic_vector(1 downto 0);
SIGNAL selectedOutput : std_logic_vector(7 downto 0);

component nBitmux8to1 is
	port(
		sel0 : in    std_logic;
		 sel1 : in    std_logic;
		 sel2 : in    std_logic;
		 d0  : in    std_logic_vector(7 downto 0);
		 d1  : in    std_logic_vector(7 downto 0);
		 d2  : in    std_logic_vector(7 downto 0);
		 d3  : in    std_logic_vector(7 downto 0);
		 d4  : in    std_logic_vector(7 downto 0);
		 d5  : in    std_logic_vector(7 downto 0);
		 d6  : in    std_logic_vector(7 downto 0);
		 d7  : in    std_logic_vector(7 downto 0);
		 y    : out   std_logic_vector(7 downto 0)
	);
end component;
component instructionMem is
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;
component mux2to1 is
	port (
		x, y, sel : in std_logic;
		z : out std_logic
	);
end component;
component mux5bit2to1 is
	port(
		x, y : in std_logic_vector(4 downto 0);
		sel : in std_logic;
		z : out std_logic_vector(4 downto 0)
	);
end component;
component mux8bit2to1 is
	port(
		x, y : in std_logic_vector(7 downto 0);
		sel : in std_logic;
		z : out std_logic_vector(7 downto 0)
	);

end component;

component register8bit is
	port(
		inp : in std_logic_vector(7 downto 0);
		i_load, i_clock, i_resetBar : in std_logic;
		outp : out std_logic_vector(7 downto 0)
	);
end component;
component addSub8bit is
	port(
		A, B : in std_logic_vector(7 downto 0);
		sub : in std_logic;
		result : out std_logic_vector(7 downto 0)
	);
end component;
component shiftL2 is
	port(
		i_in  : in  std_logic_vector(15 downto 0);
		o_out : out std_logic_vector(15 downto 0)
	);
end component;

component shift26bitL2 is
	port(
		i_in  : in  std_logic_vector(25 downto 0);
		o_out : out std_logic_vector(25 downto 0)
	);
end component;

component ALU is
	port(
		A, B : in std_logic_vector(7 downto 0);
		Operation : in std_logic_vector(1 downto 0);
		z_out : out std_logic_vector(7 downto 0);
		zero : out std_logic
	);
end component;

component ControlUnit is
	port(
		OPCode : in std_logic_vector(5 downto 0);
		RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0 : out std_logic
	);
end component;

component registerFile is
	port(
		i_resetBar, i_clock, RegWrite : in std_logic;
		writeValue : in std_logic_vector (7 downto 0);
		ReadReg1, ReadReg2, WriteReg : in std_logic_vector(2 downto 0);
		ReadData1, ReadData2 : out std_logic_vector(7 downto 0)
	);
end component;

component DataMem is
	port(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rden		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;

begin

	opCode <= instruction(31) & instruction(30) & instruction(29) & instruction(28) & instruction(27) & instruction(26);
	rs <= instruction(25) & instruction(24) & instruction(23) & instruction(22) & instruction(21);
	rt <= instruction(20) & instruction(19) & instruction(18) & instruction(17) & instruction(16);
	rd <= instruction(15) & instruction(14) & instruction(13) & instruction(12) & instruction(11);
	jumpCode <= instruction(25 downto 0);
	immediate <= instruction(15 downto 0);
	funct <= instruction(5 downto 0); 
	
	pc : register8bit
		port map(
			inp => jumpMuxOut,
			i_load => '1',
			i_clock => Gclock,
			i_resetBar => GReset,
			outp => PCOut
		);
		
	instrMem : instructionMem
		port map(
			address	=> PCOut,
			clock	=> '1',
			data => instruction,
			wren	=> '1',
			q	=> instruction
		);
	pcALU : addSub8bit
		port map(
			A => PCOut,
			B => "00000100",
			sub => '0',
			result => PCALUOut
		);
	jumpShift : shift26bitL2
		port map(
			i_in => jumpCode,
			o_out => jumpShiftOut
		);
	
	jumpAddress <= jumpShiftOut(7 downto 0);

	control : controlUnit
		port map(
			OPCode => opCode,
			RegDst => RegDst,
			ALUSrc => ALUSrc,
			MemtoReg => MemtoReg,
			RegWrite => RegWrite,
			MemRead => MemRead,
			MemWrite => MemWrite,
			Branch => Branch,
			ALUOp1 => ALUOp(1),
			ALUOp0 => ALUOp(0)
		);

	writeRegMux : mux5bit2to1
		port map(
			x => rt,
			y => rd,
			sel => RegDst,
			z => writeRegMuxOut
		);
	regFile : registerFile
		port map(
			i_resetBar => GREset,
			i_clock => GClock,
			RegWrite => RegWrite,
			writeValue => writeDataMuxOut,
			ReadReg1 => rs(2 downto 0),
			ReadReg2 => rt(2 downto 0),
			WriteReg => writeRegMuxOut(2 downto 0),
			ReadData1 => readD1,
			ReadData2 => readD2
		);
		
	immedShift : shiftL2
		port map(
			i_in => immediate,
			o_out => immedShiftOut
		);
	
	branchALU : addSub8bit
		port map(
			A => PCALUOut,
			B => immedShiftOut(7 downto 0),
			sub => '0',
			result => branchALUOut
		);
	
	aluBMux : mux8bit2to1
		port map(
			x => signExtendOut,
			y => readD2,
			sel => ALUSrc,
			z => aluBMuxOut
		);
	aluMain : ALU
		port map(
			A => readD1,
			B => aluBMuxOut,
			Operation => ALUOp,
			z_out => ALUResult,
			zero => Zero
			);
	branchSel <= Branch AND Zero;
			
	dataMemory : dataMem
		port map(
			address => ALUResult,
			clock	=> '1',
			data => readD2,
			rden => MemRead,
			wren	=> MemWrite,
			q	=> readDataOut
		);
	
	writeDataMux : mux8bit2to1
		port map(
			x => readDataOut,
			y => ALUResult,
			sel => MemtoReg,
			z => writeDataMuxOut
		);	
		
	branchMux : mux8bit2to1
		port map(
			x => branchALUOut,
			y => PCALUOut,
			sel => branchSel,
			z => branchMuxOut
		);	
	jumpMux : mux8bit2to1
		port map(
			x => jumpAddress,
			y => branchMuxOut,
			sel => Jump,
			z => jumpMuxOut
		);	

	outputMux : nBitmux8to1
		port map(
			sel0 => ValueSelect(0),
			 sel1 => ValueSelect(1),
			 sel2 => ValueSelect(2),
			 d0 => PCOut,
			 d1 => ALUResult,
			 d2 => readD1,
			 d3 => readD2,
			 d4 => writeDataMuxOut,
			 d5 => ('0' & RegDst & Jump & MemRead & MemtoReg & ALUOp(1) & ALUOp(0) & ALUSrc),
			 d6 => ('0' & RegDst & Jump & MemRead & MemtoReg & ALUOp(1) & ALUOp(0) & ALUSrc),
			 d7 => ('0' & RegDst & Jump & MemRead & MemtoReg & ALUOp(1) & ALUOp(0) & ALUSrc),
			 y  => selectedOutput
		);
		InstructionOut <= Instruction;
		MuxOut <= selectedOutput;
		BranchOut <= Branch;
		ZeroOut <= Zero;
		MemWriteOut <= MemWrite;
		RegWriteOut <= RegWrite;
end rtl;