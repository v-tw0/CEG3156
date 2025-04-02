library ieee;
use ieee.std_logic_1164.all;

entity fullAdder is
	port(
		A, B, cin : in std_logic;
		cout, sum : out std_logic	
	);
end fullAdder;

architecture rtl of fullAdder is
	
begin
	cout <= (A and B) or (A and cin) or (B and cin);
	sum <= A xor B xor cin;
end rtl;