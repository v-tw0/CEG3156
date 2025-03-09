library ieee;
use ieee.std_logic_1164.all;

entity shift26bitL2 is
    port (
        i_in  : in  std_logic_vector(25 downto 0);
        o_out : out std_logic_vector(25 downto 0)
    );
end entity shift26bitL2;

architecture rtl of shift26bitL2 is
    signal int_out : std_logic_vector(25 downto 0);
begin
    int_out(1 downto 0) <= (others => '0');
    int_out(25 downto 2) <= i_in(23 downto 0);

    -- Output Drivers
    o_out <= int_out;
end architecture rtl;