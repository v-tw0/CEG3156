library ieee;
use ieee.std_logic_1164.all;
entity mux8to1 is
	port(
		sel : in std_logic_vector(2 downto 0);
		r0, r1, r2, r3, r4, r5, r6, r7 : in std_logic_vector(7 downto 0);
		y_out : out std_logic_vector(7 downto 0)
	);
end mux8to1;

architecture rtl of mux8to1 is

SIGNAL mux1, mux2, muxout : std_logic_vector(7 downto 0);

component mux4to1 is
	port(
		sel0, sel1 : in std_logic;
		d0, d1, d2, d3: in std_logic_vector(7 downto 0);
		y : out std_logic_vector(7 downto 0)
	);
end component;

component mux8bit2to1 is
	port(
		sel : in std_logic;
		x, y : in std_logic_vector(7 downto 0);
		z : out std_logic_vector(7 downto 0)
	);
end component;

begin

	reg3to0 : mux4to1
		port map(
			sel0 => sel(0),
			sel1 => sel(1),
			d0 => r0,
			d1 => r1,
			d2 => r2,
			d3 => r3,
			y => mux1
		);
		
		
	reg7to4 : mux4to1
		port map(
			sel0 => sel(0),
			sel1 => sel(1),
			d0 => r4,
			d1 => r5,
			d2 => r6,
			d3 => r7,
			y => mux2
		);
		
	mux2to1 : mux8bit2to1
		port map(
			sel => sel(2),
			x => mux1,
			y => mux2,
			z => muxout
		);
	
	y_out <= muxout;
	
end rtl;