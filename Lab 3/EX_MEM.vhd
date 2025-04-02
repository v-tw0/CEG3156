library ieee;
use ieee.std_logic_1164.all;

entity EX_MEM is
	port(
		Enable, GClock, GReset : in std_logic;
		RegWrite, MemToReg : in std_logic;
		MemRead, MemWrite : in std_logic;
		ALUResult, RegisterRt : in std_logic_vector(7 downto 0);
		RegisterRd : in std_logic_vector(2 downto 0);
		RegWriteOut, MemToRegOut : out std_logic;
		MemReadOut, MemWriteOut : out std_logic;
		ALUResultOut, RegisterRtOut : out std_logic_vector(7 downto 0);
		RegisterRdOut : out std_logic_vector(2 downto 0)
	);
end EX_MEM;

architecture rtl of EX_MEM is

	component enARdFF_2
		port(
			i_resetBar	: in	std_logic;
			i_d			: in	std_logic;
			i_enable	: in	std_logic;
			i_clock		: in	std_logic;
			o_q, o_qBar	: out	std_logic);
	end component;
	
	component register8bit
		port(
			i_resetBar, i_load : in std_logic;
			i_clock				: in std_logic;
			inp				: in std_logic_vector(7 downto 0);
			outp				: out std_logic_vector(7 downto 0));
	end component;
	
	component register3bit
		port(
			i_resetBar, i_load : in std_logic;
			i_clock				: in std_logic;
			inp				: in std_logic_vector(2 downto 0);
			outp				: out std_logic_vector(2 downto 0));
	end component;

begin

RegWriteFF: enARdFF_2
	port map (
		i_resetBar => GReset,
		i_d => RegWrite,
		i_enable => Enable,
		i_clock => GClock,
		o_q => RegWriteOut);

MemToRegFF: enARdFF_2
	port map (
		i_resetBar => GReset,
		i_d => MemToReg,
		i_enable => Enable,
		i_clock => GClock,
		o_q => MemToRegOut);

MemReadFF: enARdFF_2
	port map (
		i_resetBar => GReset,
		i_d => MemRead,
		i_enable => Enable,
		i_clock => GClock,
		o_q => MemReadOut);

MemWriteFF: enARdFF_2
	port map (
		i_resetBar => GReset,
		i_d => MemWrite,
		i_enable => Enable,
		i_clock => GClock,
		o_q => MemWriteOut);

ALUReg: register8bit
	port map (
		i_resetBar => GReset,
		inp => ALUResult,
		i_load => Enable,
		i_clock => GClock,
		outp => ALUResultOut);

RdReg: register3bit
	port map (
		i_resetBar => GReset,
		i_load => Enable,
		i_clock => GClock,
		inp => RegisterRd,
		outp => RegisterRdOut);
		
RtReg: register8bit
	port map (
		i_resetBar => GReset,
		i_load => Enable,
		i_clock => GClock,
		inp => RegisterRt,
		outp => RegisterRtOut);
		
end rtl;
