library ieee;
use ieee.std_logic_1164.all;

entity addSub8bit is
	port( A, B : in std_logic_vector(7 downto 0);
		sub : in std_logic;
		result : out std_logic_vector(7 downto 0)
	);
end addSub8bit;

architecture rtl of addSub8bit is

signal c_int, y_int : std_logic_vector(7 downto 0);

component fullAdder is 
		port(
			A, B, cin : in std_logic;
			cout, sum : out std_logic
		);
end component;

begin
	fa0: fullAdder
		port map(
			A => A(0),
			B => B(0) xor sub,
			cin => sub,
			cout => c_int(0),
			sum => y_int(0)
		);
		
	gen_add: for i in 1 to 7 generate
		U0: fullAdder
			port map(
				A => A(i),
				B => B(i) xor sub,
				cin => c_int(i-1),
				cout => c_int(i),
				sum => y_int(i)
			);
	end generate;
	result <= y_int;
	
end rtl;