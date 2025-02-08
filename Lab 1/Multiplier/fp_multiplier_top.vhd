library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fp_multiplier_top is
    port(
        data_in  : in  std_logic_vector(15 downto 0); -- Single 16-bit input
        LoadA    : in  std_logic;  -- Signal to load input to A
        LoadB    : in  std_logic;  -- Signal to load input to B
        clk      : in  std_logic;  -- Clock
        reset    : in  std_logic;  -- Reset signal
        start    : in  std_logic;  -- Start signal for multiplication
        done     : out std_logic;  -- Done signal
        product  : out std_logic_vector(15 downto 0) -- Product output
    );
end fp_multiplier_top;

architecture behavior of fp_multiplier_top is
    -- Signals for storing values
    signal A_reg, B_reg : std_logic_vector(15 downto 0);
    
    -- Component Declaration for fpMultiplier
    component fpMultiplier
        port(
            x : in  std_logic_vector(15 downto 0);
            y : in  std_logic_vector(15 downto 0);
            z : out std_logic_vector(15 downto 0)
        );
    end component;
    
begin

    -- Instantiate the fpMultiplier
    uut: fpMultiplier port map (
        x => A_reg,
        y => B_reg,
        z => product
    );

    -- Process to load value into A_reg or B_reg
    load_process: process(clk, reset)
    begin
        if reset = '1' then
            A_reg <= (others => '0');
            B_reg <= (others => '0');
            done  <= '0';
        elsif rising_edge(clk) then
            -- Load data_in into A_reg if LoadA is enabled
            if LoadA = '1' then
                A_reg <= data_in;
            end if;
            -- Load data_in into B_reg if LoadB is enabled
            if LoadB = '1' then
                B_reg <= data_in;
            end if;
            
            -- Set done flag when start is triggered (assuming combinational multiplication)
            if start = '1' then
                done <= '1';
            else
                done <= '0';
            end if;
        end if;
    end process;

end behavior;
