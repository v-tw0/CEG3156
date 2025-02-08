library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all; 

entity fpMultiplier is
    Port ( x : in  STD_LOGIC_VECTOR (15 downto 0);
           y : in  STD_LOGIC_VECTOR (15 downto 0);
           z : out  STD_LOGIC_VECTOR (15 downto 0));
end fpMultiplier;

architecture Behavioral of fpMultiplier is

begin
	process(x, y)
		variable x_mantissa  : STD_LOGIC_VECTOR (7 downto 0);
		variable x_exponent  : STD_LOGIC_VECTOR (6 downto 0);
		variable x_sign      : STD_LOGIC;
		variable y_mantissa  : STD_LOGIC_VECTOR (7 downto 0);
		variable y_exponent  : STD_LOGIC_VECTOR (6 downto 0);
		variable y_sign      : STD_LOGIC;
		variable z_mantissa  : STD_LOGIC_VECTOR (7 downto 0);
		variable z_exponent  : STD_LOGIC_VECTOR (6 downto 0);
		variable z_sign      : STD_LOGIC;
		variable aux         : STD_LOGIC;
		variable aux2        : STD_LOGIC_VECTOR (17 downto 0);
		variable exponent_sum: STD_LOGIC_VECTOR (7 downto 0);
   begin
		-- Extract sign, exponent, and mantissa
		x_mantissa := x(7 downto 0);
		x_exponent := x(14 downto 8);
		x_sign     := x(15);
		
		y_mantissa := y(7 downto 0);
		y_exponent := y(14 downto 8);
		y_sign     := y(15);
	
		-- Handle special cases (Inf and Zero)
		if (x_exponent = "1111111" or y_exponent = "1111111") then 
			-- Inf * x or x * Inf
			z_exponent := "1111111";
			z_mantissa := (others => '0');
			z_sign     := x_sign xor y_sign;
			
		elsif (x_exponent = "0000000" or y_exponent = "0000000") then 
			-- Zero multiplication case
			z_exponent := (others => '0');
			z_mantissa := (others => '0');
			z_sign     := '0';
		
		else
			-- Perform multiplication (normalized mantissas)
			aux2 := ('1' & x_mantissa) * ('1' & y_mantissa);
			-- args in Q8 result in Q16
			
			if (aux2(17) = '1') then 
				-- Overflow, shift left and adjust exponent
				z_mantissa := aux2(16 downto 9) + aux2(8); -- rounding
				aux := '1';
			else
				z_mantissa := aux2(15 downto 8) + aux2(7); -- rounding
				aux := '0';
			end if;
			
			-- Compute new exponent
			exponent_sum := ('0' & x_exponent) + ('0' & y_exponent) + aux - 63;  -- Adjust bias (127 -> 63)
			
			-- Handle exponent underflow/overflow
			if (exponent_sum(7) = '1') then 
				if (exponent_sum(6) = '0') then -- Overflow
					z_exponent := "1111111";
					z_mantissa := (others => '0');
					z_sign     := x_sign xor y_sign;
				else  -- Underflow
					z_exponent := (others => '0');
					z_mantissa := (others => '0');
					z_sign     := '0';
				end if;
			else
				-- Normal case
				z_exponent := exponent_sum(6 downto 0);
				z_sign := x_sign xor y_sign;
			end if;
		end if;
		
		-- Assign output
		z(7 downto 0)   <= z_mantissa;
		z(14 downto 8)  <= z_exponent;
		z(15)           <= z_sign;

   end process;
end Behavioral;