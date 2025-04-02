library ieee;
use ieee.std_logic_1164.all;
entity mux8bit2to1 is
	port(
		sel : in std_logic;
		x, y : in std_logic_vector(7 downto 0);
		z : out std_logic_vector(7 downto 0)
	);
end mux8bit2to1;

architecture rtl of mux8bit2to1 is

begin
	z <= ((x(0) and NOT sel) & (x(1) and NOT sel) & (x(2) and NOT sel) & (x(3) and NOT sel) & (x(4) and NOT sel) & (x(5) and NOT sel) & (x(6) and NOT sel) & (x(7) and NOT sel))
	OR ((y(0) and sel) & (y(1) and sel )& (y(2) and sel) & (y(3) and sel) & (y(4) and sel) & (y(5) and sel) & (y(6) and sel) & (y(7) and sel));
	
end rtl;
	