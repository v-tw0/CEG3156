LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fa7bit IS
    PORT (       i_x      : IN STD_LOGIC_VECTOR(6 downto 0);
                i_y      : IN STD_LOGIC_VECTOR(6 downto 0);
                i_cin    : IN STD_LOGIC;
                o_s      : OUT STD_LOGIC_VECTOR(6 downto 0));
END fa7bit;

ARCHITECTURE struct OF fa7bit IS
-- All that is needed is to connect the carry outs to the carry ins of the next adder.
-- The rest of the process is the same as a one bit full adder.
COMPONENT fa1bit
    PORT (       i_x      : IN STD_LOGIC;
                i_y      : IN STD_LOGIC;
                i_cin    : IN STD_LOGIC;
                o_cout   : OUT STD_LOGIC;
                o_s      : OUT STD_LOGIC);
END COMPONENT;

SIGNAL int_c : STD_LOGIC_VECTOR(6 downto 0);

BEGIN
adder6: fa1bit
    PORT MAP (    i_x => i_x(6),
                i_y => i_y(6),
                i_cin => int_c(5),
                o_cout => int_c(6),
                o_s => o_s(6));

adder5: fa1bit
    PORT MAP (    i_x => i_x(5),
                i_y => i_y(5),
                i_cin => int_c(4),
                o_cout => int_c(5),
                o_s => o_s(5));

adder4: fa1bit
    PORT MAP (    i_x => i_x(4),
                i_y => i_y(4),
                i_cin => int_c(3),
                o_cout => int_c(4),
                o_s => o_s(4));

adder3: fa1bit
    PORT MAP (    i_x => i_x(3),
                i_y => i_y(3),
                i_cin => int_c(2),
                o_cout => int_c(3),
                o_s => o_s(3));

adder2: fa1bit
    PORT MAP (    i_x => i_x(2),
                i_y => i_y(2),
                i_cin => int_c(1),
                o_cout => int_c(2),
                o_s => o_s(2));

adder1: fa1bit
    PORT MAP (    i_x => i_x(1),
                i_y => i_y(1),
                i_cin => int_c(0),
                o_cout => int_c(1),
                o_s => o_s(1));

adder0: fa1bit
    PORT MAP (    i_x => i_x(0),
                i_y => i_y(0),
                i_cin => i_cin,
                o_cout => int_c(0),
                o_s => o_s(0));

END struct;
