LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fa9bit IS
    PORT (         i_resetBar, i_clock    : IN STD_LOGIC;
                  i_x            : IN STD_LOGIC_VECTOR(8 downto 0);
                  i_y            : IN STD_LOGIC_VECTOR(8 downto 0);
                  i_cin            : IN STD_LOGIC;
                  o_cout            : OUT STD_LOGIC;
                  o_q            : OUT STD_LOGIC_VECTOR(8 downto 0));
END fa9bit;

ARCHITECTURE struct OF fa9bit IS
--All that is needed is to connect the carry outs to the carry ins of the next adder.
--The rest of the process is the same as a one bit full adder.
COMPONENT fa1bit
    PORT (         i_x        : IN STD_LOGIC;
                  i_y        : IN STD_LOGIC;
                  i_cin        : IN STD_LOGIC;
                  o_cout        : OUT STD_LOGIC;
                  o_s        : OUT STD_LOGIC);
END COMPONENT;

COMPONENT enARdFF_2
    PORT(
        i_resetBar    : IN    STD_LOGIC;
        i_d        : IN    STD_LOGIC;
        i_enable    : IN    STD_LOGIC;
        i_clock        : IN    STD_LOGIC;
        o_q, o_qBar    : OUT    STD_LOGIC);
END COMPONENT;

SIGNAL int_c : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_s : STD_LOGIC_VECTOR(8 downto 0);

BEGIN

adder8: fa1bit
    PORT MAP (  i_x => i_x(8),
                i_y => i_y(8),
                i_cin => int_c(7),
                o_cout => o_cout,
                o_s => int_s(8));
adder7: fa1bit
    PORT MAP (  i_x => i_x(7),
                i_y => i_y(7),
                i_cin => int_c(6),
                o_cout => int_c(7),
                o_s => int_s(7));

adder6: fa1bit
    PORT MAP (  i_x => i_x(6),
                i_y => i_y(6),
                i_cin => int_c(5),
                o_cout => int_c(6),
                o_s => int_s(6));
adder5: fa1bit
    PORT MAP (  i_x => i_x(5),
                i_y => i_y(5),
                i_cin => int_c(4),
                o_cout => int_c(5),
                o_s => int_s(5));

adder4: fa1bit
    PORT MAP (  i_x => i_x(4),
                i_y => i_y(4),
                i_cin => int_c(3),
                o_cout => int_c(4),
                o_s => int_s(4));

adder3: fa1bit
    PORT MAP (  i_x => i_x(3),
                i_y => i_y(3),
                i_cin => int_c(2),
                o_cout => int_c(3),
                o_s => int_s(3));

adder2: fa1bit
    PORT MAP (  i_x => i_x(2),
                i_y => i_y(2),
                i_cin => int_c(1),
                o_cout => int_c(2),
                o_s => int_s(2));

adder1: fa1bit
    PORT MAP (  i_x => i_x(1),
                i_y => i_y(1),
                i_cin => int_c(0),
                o_cout => int_c(1),
                o_s => int_s(1));

adder0: fa1bit
    PORT MAP (  i_x => i_x(0),
                i_y => i_y(0),
                i_cin => i_cin,
                o_cout => int_c(0),
                o_s => int_s(0));

q8: enARdFF_2
    PORT MAP (    i_resetBar => i_resetBar,
                i_clock => i_clock,
                i_d => int_s(8),
                i_enable => '1',
                o_q => o_q(8));

q7: enARdFF_2
    PORT MAP (    i_resetBar => i_resetBar,
                i_clock => i_clock,
                i_d => int_s(7),
                i_enable => '1',
                o_q => o_q(7));

q6: enARdFF_2
    PORT MAP (    i_resetBar => i_resetBar,
                i_clock => i_clock,
                i_d => int_s(6),
                i_enable => '1',
                o_q => o_q(6));

q5: enARdFF_2
    PORT MAP (    i_resetBar => i_resetBar,
                i_clock => i_clock,
                i_d => int_s(5),
                i_enable => '1',
                o_q => o_q(5));

q4: enARdFF_2
    PORT MAP (    i_resetBar => i_resetBar,
                i_clock => i_clock,
                i_d => int_s(4),
                i_enable => '1',
                o_q => o_q(4));

q3: enARdFF_2
    PORT MAP (    i_resetBar => i_resetBar,
                i_clock => i_clock,
                i_d => int_s(3),
                i_enable => '1',
                o_q => o_q(3));

q2: enARdFF_2
    PORT MAP (    i_resetBar => i_resetBar,
                i_clock => i_clock,
                i_d => int_s(2),
                i_enable => '1',
                o_q => o_q(2));

q1: enARdFF_2
    PORT MAP (    i_resetBar => i_resetBar,
                i_clock => i_clock,
                i_d => int_s(1),
                i_enable => '1',
                o_q => o_q(1));

q0: enARdFF_2
    PORT MAP (    i_resetBar => i_resetBar,
                i_clock => i_clock,
                i_d => int_s(0),
                i_enable => '1',
                o_q => o_q(0));

END struct;
