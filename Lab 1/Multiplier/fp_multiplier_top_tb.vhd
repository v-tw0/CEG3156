library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fp_multiplier_top_tb is
end fp_multiplier_top_tb;

architecture behavior of fp_multiplier_top_tb is
    -- Signals to connect to the DUT (Device Under Test)
    signal data_in  : std_logic_vector(15 downto 0);
    signal LoadA    : std_logic;
    signal LoadB    : std_logic;
    signal clk      : std_logic;
    signal reset    : std_logic;
    signal start    : std_logic;
    signal done     : std_logic;
    signal product      : std_logic_vector(15 downto 0);

    -- Clock Generation
    constant clk_period : time := 10 ns;
begin
    -- Instantiate the Device Under Test (DUT)
    uut: entity work.fp_multiplier_top
        port map(
            data_in  => data_in,
            LoadA    => LoadA,
            LoadB    => LoadB,
            clk      => clk,
            reset    => reset,
            start    => start,
            done     => done,
            product      => product
        );

    -- Clock generation process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Initialize signals
        reset <= '1';
        LoadA <= '0';
        LoadB <= '0';
        start <= '0';
        data_in <= (others => '0');
        wait for 20 ns;

        -- Release reset
        reset <= '0';
        wait for 20 ns;

        -- Load value into A (let's say -5.75, 16-bit representation: 1100000101110000)
        data_in <= "1100000101110000"; -- -5.75
        LoadA <= '1';  -- Enable LoadA
        LoadB <= '0';  -- Disable LoadB
        wait for 10 ns;
        LoadA <= '0';  -- Disable LoadA
        wait for 10 ns;

        -- Load value into B (let's say 2.5, 16-bit representation: 0100000001000000)
        data_in <= "0100000001000000"; -- 2.5
        LoadA <= '0';  -- Disable LoadA
        LoadB <= '1';  -- Enable LoadB
        wait for 10 ns;
        LoadB <= '0';  -- Disable LoadB
        wait for 10 ns;
        data_in <= "0000000000000000";
        -- Start the addition process
        start <= '1';
        wait for 10 ns;
        start <= '0'; -- Stop starting signal

        -- Wait for the addition to complete
        wait until done = '1';
        
        -- Check the result (expecting 2.5 + (-5.75) = -3.25)
        assert product = "1100000101101000"  -- Expected result: -3.25
        report "Test failed! Incorrect product." severity error;

        -- Finish the simulation
        wait for 10 ns;
        report "Test passed!" severity note;
        wait;
    end process;
end behavior;
