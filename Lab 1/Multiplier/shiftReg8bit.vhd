LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY shiftReg8bit IS
    PORT ( 
        i_resetBar, i_clock             : IN    STD_LOGIC;     
        i_load, i_clear, i_shift        : IN    STD_LOGIC;
        i_A                            : IN    STD_LOGIC_VECTOR(8 downto 0);
        o_q                            : OUT   STD_LOGIC_VECTOR(8 downto 0));
END shiftReg8bit;

ARCHITECTURE rtl OF shiftReg8bit IS

COMPONENT enARdFF_2
    PORT(
        i_resetBar    : IN    STD_LOGIC;
        i_d        : IN    STD_LOGIC;
        i_enable    : IN    STD_LOGIC;
        i_clock        : IN    STD_LOGIC;
        o_q, o_qBar    : OUT    STD_LOGIC);
END COMPONENT;

SIGNAL int_enable : STD_LOGIC;
SIGNAL int_d, int_q : STD_LOGIC_VECTOR(8 downto 0);

BEGIN
int_enable <= i_shift XOR i_load XOR i_clear;

int_d <= ((i_load & i_load & i_load & i_load & i_load & i_load & i_load & i_load & i_load) AND i_A) OR
        ((i_shift & i_shift & i_shift & i_shift & i_shift & i_shift & i_shift & i_shift & i_shift) AND 
        ('0' & int_q(8) & int_q(7) & int_q(6) & int_q(5) & int_q(4) & int_q(3) & int_q(2) & int_q(1))) OR
        ((i_clear & i_clear & i_clear & i_clear & i_clear & i_clear & i_clear & i_clear & i_clear) AND "000000000");

bit8: enARdFF_2
    PORT MAP( i_resetBar => i_resetBar,
              i_d => int_d(8),
              i_enable => int_enable,
              i_clock => i_clock,
              o_q => int_q(8));

bit7: enARdFF_2
    PORT MAP( i_resetBar => i_resetBar,
              i_d => int_d(7),
              i_enable => int_enable,
              i_clock => i_clock,
              o_q => int_q(7));

bit6: enARdFF_2
    PORT MAP( i_resetBar => i_resetBar,
              i_d => int_d(6),
              i_enable => int_enable,
              i_clock => i_clock,
              o_q => int_q(6));

bit5: enARdFF_2
    PORT MAP( i_resetBar => i_resetBar,
              i_d => int_d(5),
              i_enable => int_enable,
              i_clock => i_clock,
              o_q => int_q(5));

bit4: enARdFF_2
    PORT MAP( i_resetBar => i_resetBar,
              i_d => int_d(4),
              i_enable => int_enable,
              i_clock => i_clock,
              o_q => int_q(4));

bit3: enARdFF_2
    PORT MAP( i_resetBar => i_resetBar,
              i_d => int_d(3),
              i_enable => int_enable,
              i_clock => i_clock,
              o_q => int_q(3));

bit2: enARdFF_2
    PORT MAP( i_resetBar => i_resetBar,
              i_d => int_d(2),
              i_enable => int_enable,
              i_clock => i_clock,
              o_q => int_q(2));

bit1: enARdFF_2
    PORT MAP( i_resetBar => i_resetBar,
              i_d => int_d(1),
              i_enable => int_enable,
              i_clock => i_clock,
              o_q => int_q(1));

bit0: enARdFF_2
    PORT MAP( i_resetBar => i_resetBar,
              i_d => int_d(0),
              i_enable => int_enable,
              i_clock => i_clock,
              o_q => int_q(0));

    --Output driver
    o_q <= int_q;
END rtl;
