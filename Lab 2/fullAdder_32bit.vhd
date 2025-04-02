library ieee;
use ieee.std_logic_1164.all;

entity fullAdder_32bit is
	port(
	A,B : in STD_LOGIC_vector(31 downto 0);
	Cin : in STD_LOGIC;
	Sum : out STD_LOGIC_vector(31 downto 0);
	Cout: out STD_LOGIC);
end fullAdder_32bit;

architecture rtl of fullAdder_32bit is
Signal cOuts : std_logic_vector(2 downto 0);

component fullAdder_8bit is
	port(
	A,B  : in STD_LOGIC_vector(7 downto 0);
	Cin  : in STD_LOGIC;
	Sum : out STD_LOGIC_vector(7 downto 0);
	Cout: out STD_LOGIC);
end component;

begin
	
fa07:fullAdder_8bit
port map(
	A => A(7 downto 0),
	B => B(7 downto 0),
	Cin  => Cin,
	Sum  => Sum(7 downto 0),
	Cout => cOuts(0));
	
fa815:fullAdder_8bit
port map(
	A => A(15 downto 8),
	B => B(15 downto 8),
	Cin  => cOuts(0),
	Sum  => Sum(15 downto 8),
	Cout => cOuts(1));
	
fa1623:fullAdder_8bit
port map(
	A => A(23 downto 16),
	B => B(23 downto 16),
	Cin  => cOuts(1),
	Sum  => Sum(23 downto 16),
	Cout => cOuts(2));
	
fa2431:fullAdder_8bit
port map(
	A => A(31 downto 24),
	B => B(31 downto 24),
	Cin  => cOuts(2),
	Sum  => Sum(31 downto 24),
	Cout => Cout);

end architecture rtl;