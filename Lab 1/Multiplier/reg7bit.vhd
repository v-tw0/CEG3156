LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY reg7bit IS
    PORT (    
        i_GReset    : IN    STD_LOGIC;
        i_clock     : IN    STD_LOGIC;
        i_E         : IN    STD_LOGIC_VECTOR(6 downto 0);
        i_load      : IN    STD_LOGIC;
        o_E         : OUT   STD_LOGIC_VECTOR(6 downto 0));
END reg7bit;

ARCHITECTURE rtl OF reg7bit IS
    SIGNAL int_E    : STD_LOGIC_VECTOR(6 downto 0);

    COMPONENT enARdFF_2
        PORT (    i_resetBar    : IN    STD_LOGIC;
                  i_d            : IN    STD_LOGIC;
                  i_enable       : IN    STD_LOGIC;
                  i_clock        : IN    STD_LOGIC;
                  o_q, o_qBar    : OUT   STD_LOGIC);
    END COMPONENT;

BEGIN
bit6: enARdFF_2
    PORT MAP ( i_resetBar => i_GReset,
               i_d => i_E(6),
               i_enable => i_load,
               i_clock => i_clock,
               o_q => int_E(6));

bit5: enARdFF_2
    PORT MAP ( i_resetBar => i_GReset,
               i_d => i_E(5),
               i_enable => i_load,
               i_clock => i_clock,
               o_q => int_E(5));

bit4: enARdFF_2
    PORT MAP ( i_resetBar => i_GReset,
               i_d => i_E(4),
               i_enable => i_load,
               i_clock => i_clock,
               o_q => int_E(4));

bit3: enARdFF_2
    PORT MAP ( i_resetBar => i_GReset,
               i_d => i_E(3),
               i_enable => i_load,
               i_clock => i_clock,
               o_q => int_E(3));

bit2: enARdFF_2
    PORT MAP ( i_resetBar => i_GReset,
               i_d => i_E(2),
               i_enable => i_load,
               i_clock => i_clock,
               o_q => int_E(2));

bit1: enARdFF_2
    PORT MAP ( i_resetBar => i_GReset,
               i_d => i_E(1),
               i_enable => i_load,
               i_clock => i_clock,
               o_q => int_E(1));

bit0: enARdFF_2
    PORT MAP ( i_resetBar => i_GReset,
               i_d => i_E(0),
               i_enable => i_load,
               i_clock => i_clock,
               o_q => int_E(0));
    -- Output Drivers
    o_E <= int_E;
END rtl;
