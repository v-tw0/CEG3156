library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fp_adder_tb is
end fp_adder_tb;

architecture behavior of fp_adder_tb is
    -- Component Declaration
    component fp_adder
        port(
            A      : in  std_logic_vector(15 downto 0);
            B      : in  std_logic_vector(15 downto 0);
            clk    : in  std_logic;
            reset  : in  std_logic;
            start  : in  std_logic;
            done   : out std_logic;
            sum    : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Signals
    signal A, B, sum : std_logic_vector(15 downto 0);
    signal clk, reset, start, done : std_logic;

    -- Separate signals for each part
    signal SignA, SignB, SignSum : std_logic;
    signal ExponentA, ExponentB, ExponentSum : std_logic_vector(6 downto 0);
    signal MantissaA, MantissaB, MantissaSum : std_logic_vector(7 downto 0);

    -- Clock process
    constant clk_period : time := 10 ns;
begin

    -- Instantiate the fp_adder
    uut: fp_adder port map (
        A      => A,
        B      => B,
        clk    => clk,
        reset  => reset,
        start  => start,
        done   => done,
        sum    => sum
    );

    -- Assignments to extract sign, exponent, and mantissa
    SignA     <= A(15);
    ExponentA <= A(14 downto 8);
    MantissaA <= A(7 downto 0);

    SignB     <= B(15);
    ExponentB <= B(14 downto 8);
    MantissaB <= B(7 downto 0);

    SignSum     <= sum(15);
    ExponentSum <= sum(14 downto 8);
    MantissaSum <= sum(7 downto 0);

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Test process
    stim_proc: process
    begin
        -- Initialize Inputs
        reset <= '1';
        start <= '0';
        A <= (others => '0');
        B <= (others => '0');
        wait for 20 ns;

        -- Release Reset
        reset <= '0';
        wait for 20 ns;

        -- Apply Inputs (-5.75 + 2.5)
        A <= "1100000011000000";  -- -5.75 in floating point
        B <= "1100000101100000";  -- 2.5 in floating point
        start <= '1';
        wait for 20 ns;
        
        -- Wait for operation to complete
        wait until done = '1';
        start <= '0';
        wait for 20 ns;

        -- Check the result
        report "Input A: Sign=" & std_logic'image(SignA) & 
               ", Exponent=" & integer'image(to_integer(unsigned(ExponentA))) & 
               ", Mantissa=" & integer'image(to_integer(unsigned(MantissaA)));

        report "Input B: Sign=" & std_logic'image(SignB) & 
               ", Exponent=" & integer'image(to_integer(unsigned(ExponentB))) & 
               ", Mantissa=" & integer'image(to_integer(unsigned(MantissaB)));

        report "Result: Sign=" & std_logic'image(SignSum) & 
               ", Exponent=" & integer'image(to_integer(unsigned(ExponentSum))) & 
               ", Mantissa=" & integer'image(to_integer(unsigned(MantissaSum)));

        -- Stop Simulation
        wait;
    end process;

end behavior;
