library ieee;
use ieee.std_logic_1164.all;
entity mux4to1 is
	port(
		sel0, sel1 : in std_logic;
		d0, d1, d2, d3: in std_logic_vector(7 downto 0);
		y : out std_logic_vector(7 downto 0)
	);
end mux4to1;

architecture rtl of mux4to1 is

begin

	y <= ((sel1 AND sel0 AND d3(7)) & (sel1 AND sel0 AND d3(6)) & (sel1 AND sel0 AND d3(5)) & (sel1 AND sel0 AND d3(4)) & (sel1 AND sel0 AND d3(3)) & (sel1 AND sel0 AND d3(2)) & (sel1 AND sel0 AND d3(1)) & (sel1 AND sel0 AND d3(0))) 
    OR ((sel1 AND NOT sel0 AND d2(7)) & (sel1 AND NOT sel0 AND d2(6)) & (sel1 AND NOT sel0 AND d2(5)) & (sel1 AND NOT sel0 AND d2(4)) & (sel1 AND NOT sel0 AND d2(3)) & (sel1 AND NOT sel0 AND d2(2)) & (sel1 AND NOT sel0 AND d2(1)) & (sel1 AND NOT sel0 AND d2(0))) 
    OR ((NOT sel1 AND sel0 AND d1(7)) & (NOT sel1 AND sel0 AND d1(6)) & (NOT sel1 AND sel0 AND d1(5)) & (NOT sel1 AND sel0 AND d1(4)) & (NOT sel1 AND sel0 AND d1(3)) & (NOT sel1 AND sel0 AND d1(2)) & (NOT sel1 AND sel0 AND d1(1)) & (NOT sel1 AND sel0 AND d1(0))) 
    OR ((NOT sel1 AND NOT sel0 AND d0(7)) & (NOT sel1 AND NOT sel0 AND d0(6)) & (NOT sel1 AND NOT sel0 AND d0(5)) & (NOT sel1 AND NOT sel0 AND d0(4)) & (NOT sel1 AND NOT sel0 AND d0(3)) & (NOT sel1 AND NOT sel0 AND d0(2)) & (NOT sel1 AND NOT sel0 AND d0(1)) & (NOT sel1 AND NOT sel0 AND d0(0)));

end rtl;