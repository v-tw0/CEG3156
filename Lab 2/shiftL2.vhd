library ieee;
use ieee.std_logic_1164.all;

entity shiftL2 is
    port (
        i_in  : in  std_logic_vector(15 downto 0);  -- Change to 16 bits
        o_out : out std_logic_vector(15 downto 0)   -- Change to 16 bits
    );
end entity shiftL2;

architecture rtl of shiftL2 is
    signal int_out : std_logic_vector(15 downto 0);  -- Change to 16 bits
begin
    int_out(1 downto 0) <= (others => '0');  -- Setting the first 2 bits to 0
    int_out(15 downto 2) <= i_in(13 downto 0);  -- Shift input from 14 downto 0 to output 15 downto 2

    -- Output Drivers
    o_out <= int_out;  -- Assign to output
end architecture rtl;
