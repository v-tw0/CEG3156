library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
	port(
		OPCode : in std_logic_vector(5 downto 0);
		RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0 : out std_logic

	);
end ControlUnit;

architecture rtl of ControlUnit is

SIGNAL rFormat, lw, sw, beq : std_logic; 

begin

	rFormat <= NOT OPCode(5) and NOT OPCode(4) and NOT OPCode(3) and NOT OPCode(2) and NOT OPCode(1) and NOT OPCode(0);
	lw <= OPCode(5) and NOT OPCode(4) and NOT OPCode(3) and NOT OPCode(2) and OPCode(1) and OPCode(0);
	sw <= OPCode(5)  and NOT OPCode(4) and OPCode(3) and NOT OPCode(2) and OPCode(1) and OPCode(0);
	beq <= NOT OPCode(5) and NOT OPCode(4) and NOT OPCode(3) and OPCode(2) and NOT OPCode(1) and NOT OPCode(0);

	RegDst <= rFormat;
	ALUSrc <= lw OR sw;
	MemtoReg <= lw;
	RegWrite <= rFormat or lw;
	MemRead <= lw;
	MemWrite <= sw;
	Branch <= beq;
	ALUOp1  <= rFormat;
	ALUOp0 <= beq;
	
end rtl;