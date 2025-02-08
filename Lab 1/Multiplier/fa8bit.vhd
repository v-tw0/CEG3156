LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fa8bit IS
    PORT (      i_x     : IN STD_LOGIC_VECTOR(7 downto 0);
                i_y     : IN STD_LOGIC_VECTOR(7 downto 0);
                i_cin   : IN STD_LOGIC;
                o_sign  : OUT STD_LOGIC;
                o_s     : OUT STD_LOGIC_VECTOR(6 downto 0));
END fa8bit;

ARCHITECTURE struct OF fa8bit IS

COMPONENT fa1bit
    PORT (      i_x     : IN STD_LOGIC;
                i_y     : IN STD_LOGIC;
                i_cin   : IN STD_LOGIC;
                o_cout  : OUT STD_LOGIC;
                o_s     : OUT STD_LOGIC);
END COMPONENT;

SIGNAL int_c : STD_LOGIC_VECTOR(7 downto 0);

BEGIN
adder7: fa1bit
    PORT MAP (  i_x => i_x(7),
                i_y => i_y(7),
                i_cin => int_c(6),
                o_cout => int_c(7),
                o_s => o_sign);

adder6: fa1bit
    PORT MAP (  i_x => i_x(6),
                i_y => i_y(6),
                i_cin => int_c(5),
                o_cout => int_c(6),
                o_s => o_s(6));

adder5: fa1bit
    PORT MAP (  i_x => i_x(5),
                i_y => i_y(5),
                i_cin => int_c(4),
                o_cout => int_c(5),
                o_s => o_s(5));

adder4: fa1bit
    PORT MAP (  i_x => i_x(4),
                i_y => i_y(4),
                i_cin => int_c(3),
                o_cout => int_c(4),
                o_s => o_s(4));

adder3: fa1bit
    PORT MAP (  i_x => i_x(3),
                i_y => i_y(3),
                i_cin => int_c(2),
                o_cout => int_c(3),
                o_s => o_s(3));

adder2: fa1bit
    PORT MAP (  i_x => i_x(2),
                i_y => i_y(2),
                i_cin => int_c(1),
                o_cout => int_c(2),
                o_s => o_s(2));

adder1: fa1bit
    PORT MAP (  i_x => i_x(1),
                i_y => i_y(1),
                i_cin => int_c(0),
                o_cout => int_c(1),
                o_s => o_s(1));

adder0: fa1bit
    PORT MAP (  i_x => i_x(0),
                i_y => i_y(0),
                i_cin => i_cin,
                o_cout => int_c(0),
                o_s => o_s(0));

END struct;
