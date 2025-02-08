LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux7bit_2x1 IS
    PORT (
        i_sel   : IN  STD_LOGIC;
        i_A     : IN  STD_LOGIC_VECTOR(6 downto 0);
        i_B     : IN  STD_LOGIC_VECTOR(6 downto 0);
        o_q     : OUT STD_LOGIC_VECTOR(6 downto 0));
END mux7bit_2x1;

ARCHITECTURE struct OF mux7bit_2x1 IS
    
BEGIN

WITH i_sel SELECT
    o_q <= i_A when '0',
           i_B when '1',
           "0000000" when others;
END struct;
