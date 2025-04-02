library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
	port(
		x, y, sel : in std_logic;
		z : out std_logic
	);
end mux2to1;

architecture rtl of mux2to1 is

begin
	z <= (x and sel) or (y and NOT sel);
end rtl;