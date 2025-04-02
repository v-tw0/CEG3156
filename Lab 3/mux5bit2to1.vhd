library ieee;
use ieee.std_logic_1164.all;

entity mux5bit2to1 is
	port(
		x, y : in std_logic_vector(4 downto 0);
		sel : in std_logic;
		z : out std_logic_vector(4 downto 0)
	);
end mux5bit2to1;

architecture rtl of mux5bit2to1 is

begin
	z <= ((x(0) and sel) & (x(1) and sel) & (x(2) and sel) & (x(3) and sel) & (x(4) and sel)) 
         or ((y(0) and not sel) & (y(1) and not sel) & (y(2) and not sel) & (y(3) and not sel) & (y(4) and not sel));
end rtl;