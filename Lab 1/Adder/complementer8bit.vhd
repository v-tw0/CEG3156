LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY complementer8bit IS
    PORT (  i_A      : IN  STD_LOGIC_VECTOR(7 downto 0);
            i_enable : IN  STD_LOGIC;
            o_q      : OUT STD_LOGIC_VECTOR(7 downto 0));
END complementer8bit;

ARCHITECTURE rtl OF complementer8bit IS

SIGNAL int_q : STD_LOGIC_VECTOR(7 downto 0);

BEGIN

int_q <=  (i_enable & i_enable & i_enable & i_enable & i_enable & i_enable & i_enable & i_enable) XOR i_A;

    o_q <= int_q;

END rtl;
