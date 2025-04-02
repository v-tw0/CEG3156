library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port(
		A, B : in std_logic_vector(7 downto 0);
		Operation : in std_logic_vector(1 downto 0);
		z_out : out std_logic_vector(7 downto 0);
		zero : out std_logic
	);
end ALU;

architecture rtl of ALU is 

SIGNAL int_sum, mux_out : std_logic_vector(7 downto 0);

component mux4to1 is
	port(
		sel0, sel1 : in std_logic;
		d0, d1, d2, d3 : in std_logic_vector(7 downto 0);
		y : out std_logic_vector(7 downto 0)
	);
end component;

component addSub8bit is
	port(
		A, B  : in std_logic_vector(7 downto 0);
		sub : in std_logic;
		result : out std_logic_vector(7 downto 0)
	);
end component;
	
begin

	addSub : addSub8bit
		port map(
			A => A,
			B => B,
			sub => Operation(1) AND Operation(0),
			result => int_sum
		);

	mux : mux4to1
		port map(
			sel0 => Operation(0),
			sel1 => Operation(1),
			d0 => A AND B,
			d1 => A OR B,
			d2 => int_sum,
			d3 => int_sum,
			y => mux_out
		);


	zero <= (mux_out(0) XNOR '0') AND (mux_out(1) XNOR '0') AND (mux_out(2) XNOR '0') AND (mux_out(3) XNOR '0') AND (mux_out(4) XNOR '0') AND (mux_out(5) XNOR '0') AND (mux_out(6) XNOR '0') AND (mux_out(7) XNOR '0');
	z_out <= mux_out;
end rtl;