library ieee;
use ieee.std_logic_1164.all;

entity ID_EX is
	port(
		Enable, GClock, GReset : in std_logic;
		RegWrite, MemToReg : in std_logic;
		MemRead, MemWrite : in std_logic;
		RegDst, ALUSrc : in std_logic;
		ALUOp : in std_logic_vector(1 downto 0);
		Rd, Rt, Rs : in std_LOGIC_VECTOR(2 downto 0);
		ReadData1, ReadData2, OFFset: in std_logic_vector(7 downto 0); 
		RegWriteOut, MemToRegOut : out std_logic;
		MemReadOut, MemWriteOut : out std_logic;
		RegDstOut, ALUSrcOut : out std_logic;
		ALUOpOut : out std_logic_vector(1 downto 0);
		RdOut, RtOut, RsOut : out std_LOGIC_VECTOR(2 downto 0);
		ReadData1Out, ReadData2Out, OFFsetOut: out std_logic_vector(7 downto 0)
		);
end ID_EX;

architecture rtl of ID_EX is

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d			: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END component;
	
	COMPONENT register8bit
		PORT(
		i_resetBar, i_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		inp			: IN	STD_LOGIC_VECTOR(7 downto 0);
		outp			: OUT	STD_LOGIC_VECTOR(7 downto 0));
	END component;
	
	COMPONENT register3bit
		PORT(
		i_resetBar, i_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		inp			: IN	STD_LOGIC_VECTOR(2 downto 0);
		outp			: OUT	STD_LOGIC_VECTOR(2 downto 0));
	END component;

begin

RegWriteFF: enARdFF_2
Port map (
	i_resetBar => GReset,
	i_d => RegWrite,
	i_enable => Enable,
	i_clock => GClock,
	o_q => RegWriteOut,
	o_qBar => open);

MemtoRegFF: enARdFF_2
Port map (
	i_resetBar => GReset,
	i_d => MemToReg,
	i_enable => Enable,
	i_clock => GClock,
	o_q => MemToRegOut,
	o_qBar => open);

MemReadFF: enARdFF_2
Port map (
	i_resetBar => GReset,
	i_d => MemRead,
	i_enable => Enable,
	i_clock => GClock,
	o_q => MemReadOut,
	o_qBar => open);

MemWriteFF: enARdFF_2
Port map (
	i_resetBar => GReset,
	i_d => MemWrite,
	i_enable => Enable,
	i_clock => GClock,
	o_q => MemWriteOut,
	o_qBar => open);

RegDstFF: enARdFF_2
Port map (
	i_resetBar => GReset,
	i_d => RegDst,
	i_enable => Enable,
	i_clock => GClock,
	o_q => RegDstOut,
	o_qBar => open);

ALUSrcFF: enARdFF_2
Port map (
	i_resetBar => GReset,
	i_d => ALUSrc,
	i_enable => Enable,
	i_clock => GClock,
	o_q => ALUSrcOut,
	o_qBar => open);

ALUOp0FF: enARdFF_2
Port map (
	i_resetBar => GReset,
	i_d => ALUOp(0),
	i_enable => Enable,
	i_clock => GClock,
	o_q => ALUOpOut(0),
	o_qBar => open);

ALUOp1FF: enARdFF_2
Port map (
	i_resetBar => GReset,
	i_d => ALUOp(1),
	i_enable => Enable,
	i_clock => GClock,
	o_q => ALUOpOut(1),
	o_qBar => open);

ReadData1Reg: register8bit
PORT MAP (
	i_resetBar => GReset,
	inp => ReadData1(7 downto 0),
	i_load => Enable,
	i_clock => GClock,
	outp => ReadData1Out(7 downto 0));

ReadData2Reg: register8bit
PORT MAP (
	i_resetBar => GReset,
	inp => ReadData2(7 downto 0),
	i_load => Enable,
	i_clock => GClock,
	outp => ReadData2Out(7 downto 0));

OffsetReg: register8bit
PORT MAP (
	i_resetBar => GReset,
	inp => Offset(7 downto 0),
	i_load => Enable,
	i_clock => GClock,
	outp => OffsetOut(7 downto 0));

RsReg: register3bit
PORT MAP (
	i_resetBar => GReset,
	inp => Rs(2 downto 0),
	i_load => Enable,
	i_clock => GClock,
	outp => RsOut(2 downto 0));

RdReg: register3bit
PORT MAP (
	i_resetBar => GReset,
	inp => Rd(2 downto 0),
	i_load => Enable,
	i_clock => GClock,
	outp => RdOut(2 downto 0));

RtReg: register3bit
PORT MAP (
	i_resetBar => GReset,
	inp => Rt(2 downto 0),
	i_load => Enable,
	i_clock => GClock,
	outp => RtOut(2 downto 0));

end rtl;
