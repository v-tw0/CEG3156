library ieee;
use ieee.std_logic_1164.all;

entity IF_ID is
	port(
		Enable, GClock, GReset : in std_logic;
		PCAdd4 : in std_logic_vector(7 downto 0);
		PCAdd4Out: out std_logic_vector(7 downto 0);
		Instruction : in std_logic_vector(31 downto 0); 
		InstructionOut : out std_logic_vector(31 downto 0)); 
end IF_ID;

architecture rtl of IF_ID is
	
	component register8bit
		port(
			i_resetBar, i_load	: in	std_logic;
			i_clock				: in	std_logic;
			inp				: in	std_logic_vector(7 downto 0);
			outp				: out	std_logic_vector(7 downto 0));
	end component;
	
	component reg_32bit
		port(
			i_resetBar, i_load	: in	std_logic;
			i_clock				: in	std_logic;
			inp				: in	std_logic_vector(31 downto 0);
			outp				: out	std_logic_vector(31 downto 0));
	end component;
begin


PCadd4Reg: register8bit
	port map (
		i_resetBar => GReset,
		inp => PCAdd4,
		i_load => Enable,
		i_clock => GClock,
		outp => PCAdd4Out);


instReg: reg_32bit
	port map (
		i_resetBar => GReset,
		i_load => Enable,
		i_clock => GClock,
		inp => Instruction,
		outp => InstructionOut);

end rtl;
