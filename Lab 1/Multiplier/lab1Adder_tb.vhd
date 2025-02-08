LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY lab1Adder_tb IS
END lab1Adder_tb;

ARCHITECTURE behavior OF lab1Adder_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT lab1Adder
    PORT(
        GClock       : IN  STD_LOGIC;
        GReset       : IN  STD_LOGIC;
        SignA        : IN  STD_LOGIC;
        SignB        : IN  STD_LOGIC;
        MantissaA    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        MantissaB    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        ExponentA    : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
        ExponentB    : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
        SignOut      : OUT STD_LOGIC;
        MantissaOut  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        ExponentOut  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        Overflow     : OUT STD_LOGIC
    );
    END COMPONENT;

    -- Signals for the UUT
    SIGNAL GClock       : STD_LOGIC := '0';
    SIGNAL GReset       : STD_LOGIC := '0';
    SIGNAL SignA        : STD_LOGIC;
    SIGNAL SignB        : STD_LOGIC;
    SIGNAL MantissaA    : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL MantissaB    : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL ExponentA    : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL ExponentB    : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL SignOut      : STD_LOGIC;
    SIGNAL MantissaOut  : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL ExponentOut  : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL Overflow     : STD_LOGIC;

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: lab1Adder PORT MAP (
        GClock       => GClock,
        GReset       => GReset,
        SignA        => SignA,
        SignB        => SignB,
        MantissaA    => MantissaA,
        MantissaB    => MantissaB,
        ExponentA    => ExponentA,
        ExponentB    => ExponentB,
        SignOut      => SignOut,
        MantissaOut  => MantissaOut,
        ExponentOut  => ExponentOut,
        Overflow     => Overflow
    );

    -- Clock process
    clock_process : PROCESS
    BEGIN
        GClock <= '0';
        WAIT FOR clk_period / 2;
        GClock <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stimulus_process : PROCESS
    BEGIN
        -- Reset the UUT
        GReset <= '0';
       
        -- Test Case: -5.25 + 2.5
        SignA <= '1';                       -- Sign of A (-5.25)
        ExponentA <= "1000000";             -- Exponent of A (65)
        MantissaA <= "10100000";            -- Mantissa of A (0.3125)

        SignB <= '0';                       -- Sign of B (2.5)
        ExponentB <= "1000000";             -- Exponent of B (64)
        MantissaB <= "11100000";            -- Mantissa of B (0.25)

        -- Wait for some time for UUT to process
        WAIT FOR 100 ns;

        WAIT FOR 20 ns;
        GReset <= '1';

        -- Check result
        ASSERT (SignOut = '1' AND ExponentOut = "1000000" AND MantissaOut = "01100000")
        REPORT "Test failed for -5.25 + 2.5" SEVERITY ERROR;

        -- End simulation
        WAIT;
    END PROCESS;

END behavior;



