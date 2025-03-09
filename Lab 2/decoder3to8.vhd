library ieee;
use ieee.std_logic_1164.all;

entity decoder3to8 is
	port(
		x, y, z, en : in std_logic;
		r0, r1, r2, r3, r4, r5, r6, r7 : out std_logic
	);
end decoder3to8;

architecture rtl of decoder3to8 is

begin

	r0 <= not x and not y and not z;
	r1 <= not x and not y and z;
	r2 <= not x and y and not z;
	r3 <= not x and y and z;
	r4 <= x and not y and not z;
	r5 <= x and not y and z;
	r6 <= x and y and not z;
	r7 <= x and y and z;
	
end rtl;