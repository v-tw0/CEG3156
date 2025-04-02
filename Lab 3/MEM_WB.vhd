library ieee;
use ieee.std_logic_1164.all;

entity MEM_WB is
	port(
		Enable, GClock, GReset : in std_logic;
		RegWrite, MemToReg : in std_logic;
		ReadData, ALUResult : in std_logic_vector(7 downto 0);
		RegisterRd : in std_logic_vector(2 downto 0);
		RegWriteOut, MemToRegOut : out std_logic;
		ReadDataOut, ALUResultOut : out std_logic_vector(7 downto 0);
		RegisterRdOut : out std_logic_vector(2 downto 0)
		);
end MEM_WB;

architecture rtl of MEM_WB is

	component enARdFF_2
		port(
			i_resetBar	: in std_logic;
			i_d			: in std_logic;
			i_enable	: in std_logic;
			i_clock		: in std_logic;
			o_q, o_qBar	: out std_logic);
	end component;
	
	component register8bit
		port(
			i_resetBar, i_load	: in std_logic;
			i_clock				: in std_logic;
			inp				: in std_logic_vector(7 downto 0);
			outp				: out std_logic_vector(7 downto 0));
	end component;
	
	component register3bit
		port(
			i_resetBar, i_load	: in std_logic;
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

ALUResultReg: register8bit
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

ReadDataReg: register8bit
	port map (
		i_resetBar => GReset,
		i_load => Enable,
		i_clock => GClock,
		inp => ReadData,
		outp => ReadDataOut);

end rtl;
