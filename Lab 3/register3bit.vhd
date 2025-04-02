library ieee;
use ieee.std_logic_1164.all;

entity register3bit is
	port(
		inp : in std_logic_vector(2 downto 0);
		i_load, i_clock, i_resetBar : in std_logic;
		outp : out std_logic_vector(2 downto 0)
	);
end register3bit;

architecture rtl of register3bit is
SIGNAL int_Value, int_NotValue : std_logic_vector(2 downto 0);

component
	enARdFF_2 
		port(i_resetBar, i_d, i_enable, i_clock : in std_logic;
			o_q, o_qBar : out std_logic
		);
	end component;
	
Begin
	
	gen: for i in 0 to 2 generate
		dFFs: enARdFF_2
			port map(
				i_resetBar => i_resetBar,
				i_d => inp(i),
				i_enable => i_load,
				i_clock => i_clock,
				o_q => int_Value(i),
				o_qBar => int_NotValue(i)
			);
	end generate gen;

	outp <= int_Value;
end rtl;