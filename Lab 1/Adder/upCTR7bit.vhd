LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY upCTR7bit IS
    PORT(
        i_resetBar, i_load, i_countU  : IN    STD_LOGIC;
        i_A                             : IN    STD_LOGIC_VECTOR(6 downto 0);
        i_clock                         : IN    STD_LOGIC;
        o_q                             : OUT   STD_LOGIC_VECTOR(6 downto 0));
END upCTR7bit;

ARCHITECTURE rtl OF upCTR7bit IS

    COMPONENT enARdFF_2
        PORT(
            i_resetBar    : IN    STD_LOGIC;
            i_d            : IN    STD_LOGIC;
            i_enable       : IN    STD_LOGIC;
            i_clock        : IN    STD_LOGIC;
            o_q, o_qBar    : OUT   STD_LOGIC);
    END COMPONENT;

    COMPONENT fa7bit
        PORT (
            i_x    : IN STD_LOGIC_VECTOR(6 downto 0);
            i_y    : IN STD_LOGIC_VECTOR(6 downto 0);
            i_cin  : IN STD_LOGIC;
            o_s    : OUT STD_LOGIC_VECTOR(6 downto 0));
    END COMPONENT;

    SIGNAL int_enable : STD_LOGIC;
    SIGNAL int_s, int_q, int_d : STD_LOGIC_VECTOR(6 downto 0);

BEGIN
    int_enable <= i_load XOR i_countU;

    int_d <= ((i_load & i_load & i_load & i_load & i_load & i_load & i_load) AND i_A) OR
             ((i_countU & i_countU & i_countU & i_countU & i_countU & i_countU & i_countU) AND int_s); 

    adder: fa7bit
        PORT MAP (i_x => int_q,
                  i_y => "0000001",
                  i_cin => '0',
                  o_s => int_s);

    bit6: enARdFF_2
        PORT MAP (i_resetBar => i_resetBar,
                  i_d => int_d(6),
                  i_enable => int_enable, 
                  i_clock => i_clock,
                  o_q => int_q(6));

    bit5: enARdFF_2
        PORT MAP (i_resetBar => i_resetBar,
                  i_d => int_d(5),
                  i_enable => int_enable, 
                  i_clock => i_clock,
                  o_q => int_q(5));

    bit4: enARdFF_2
        PORT MAP (i_resetBar => i_resetBar,
                  i_d => int_d(4),
                  i_enable => int_enable, 
                  i_clock => i_clock,
                  o_q => int_q(4));

    bit3: enARdFF_2
        PORT MAP (i_resetBar => i_resetBar,
                  i_d => int_d(3),
                  i_enable => int_enable, 
                  i_clock => i_clock,
                  o_q => int_q(3));

    bit2: enARdFF_2
        PORT MAP (i_resetBar => i_resetBar,
                  i_d => int_d(2),
                  i_enable => int_enable, 
                  i_clock => i_clock,
                  o_q => int_q(2));

    bit1: enARdFF_2
        PORT MAP (i_resetBar => i_resetBar,
                  i_d => int_d(1),
                  i_enable => int_enable, 
                  i_clock => i_clock,
                  o_q => int_q(1));

    bit0: enARdFF_2
        PORT MAP (i_resetBar => i_resetBar,
                  i_d => int_d(0),
                  i_enable => int_enable, 
                  i_clock => i_clock,
                  o_q => int_q(0));

    -- Output driver
    o_q <= int_q;

END rtl;
