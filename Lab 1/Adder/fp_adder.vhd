library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fp_adder is
  port(A      : in  std_logic_vector(15 downto 0);  -- 1-bit sign, 7-bit exponent, 8-bit mantissa
       B      : in  std_logic_vector(15 downto 0);
       clk    : in  std_logic;
       reset  : in  std_logic;
       start  : in  std_logic;
       done   : out std_logic;
       sum    : out std_logic_vector(15 downto 0)
       );
end fp_adder;

architecture mixed of fp_adder is
  type ST is (WAIT_STATE, ALIGN_STATE, ADDITION_STATE, NORMALIZE_STATE, OUTPUT_STATE);
  signal state : ST := WAIT_STATE;

  --- Internal Signals latched from the inputs
  signal A_mantissa, B_mantissa : std_logic_vector (9 downto 0); -- Includes hidden bit and carry
  signal A_exp, B_exp           : std_logic_vector (7 downto 0); -- One bit added for subtraction
  signal A_sgn, B_sgn           : std_logic;

  -- Internal signals for Output
  signal sum_exp      : std_logic_vector (7 downto 0);
  signal sum_mantissa : std_logic_vector (9 downto 0);
  signal sum_sgn      : std_logic;

begin

  Control_Unit : process (clk, reset) is
    variable diff : signed(7 downto 0);
  begin
    if(reset = '1') then
      state <= WAIT_STATE;                 
      done    <= '0';
    elsif rising_edge(clk) then
      case state is
        when WAIT_STATE =>
          if (start = '1') then            
            A_sgn      <= A(15);
            A_exp      <= '0' & A(14 downto 8);  -- One extra bit for signed subtraction
            A_mantissa <= "01" & A(7 downto 0);  -- Two extra bits (hidden 1 and carry)
            B_sgn      <= B(15);
            B_exp      <= '0' & B(14 downto 8);  
            B_mantissa <= "01" & B(7 downto 0);
            state      <= ALIGN_STATE;
          else
            state <= WAIT_STATE;    
          end if;
        
        when ALIGN_STATE =>  
          if unsigned(A_exp) > unsigned(B_exp) then
            diff := signed(A_exp) - signed(B_exp);
            if diff > 8 then
              sum_mantissa <= A_mantissa;  
              sum_exp      <= A_exp;
              sum_sgn      <= A_sgn;
              state        <= OUTPUT_STATE;  
            else       
              sum_exp <= A_exp;
              B_mantissa(9-to_integer(diff) downto 0)  <= B_mantissa(9 downto to_integer(diff));
              B_mantissa(9 downto 10-to_integer(diff)) <= (others => '0');
              state                                    <= ADDITION_STATE;
            end if;
          elsif unsigned(A_exp) < unsigned(B_exp) then
            diff := signed(B_exp) - signed(A_exp);
            if diff > 8 then
              sum_mantissa <= B_mantissa;  
              sum_sgn      <= B_sgn;
              sum_exp      <= B_exp; 
              state        <= OUTPUT_STATE;  
            else       
              sum_exp <= B_exp;
              A_mantissa(9-to_integer(diff) downto 0)  <= A_mantissa(9 downto to_integer(diff));
              A_mantissa(9 downto 10-to_integer(diff)) <= (others => '0');
              state                                    <= ADDITION_STATE;
            end if;
          else
            sum_exp <= A_exp;
            state   <= ADDITION_STATE;          
          end if;

        when ADDITION_STATE =>                    
          state <= NORMALIZE_STATE;
          if (A_sgn xor B_sgn) = '0' then  
            sum_mantissa <= std_logic_vector((unsigned(A_mantissa) + unsigned(B_mantissa)));
            sum_sgn      <= A_sgn;      
          elsif unsigned(A_mantissa) >= unsigned(B_mantissa) then
            sum_mantissa <= std_logic_vector((unsigned(A_mantissa) - unsigned(B_mantissa)));
            sum_sgn      <= A_sgn;
          else
            sum_mantissa <= std_logic_vector((unsigned(B_mantissa) - unsigned(A_mantissa)));
            sum_sgn      <= B_sgn;
          end if;

        when NORMALIZE_STATE =>  
          if unsigned(sum_mantissa) = TO_UNSIGNED(0, 10) then
            sum_mantissa <= (others => '0');  
            sum_exp      <= (others => '0');
            state        <= OUTPUT_STATE;  
          elsif(sum_mantissa(9) = '1') then  
            sum_mantissa <= '0' & sum_mantissa(9 downto 1);  
            sum_exp      <= std_logic_vector((unsigned(sum_exp)+ 1));
            state        <= OUTPUT_STATE;
          elsif(sum_mantissa(8) = '0') then  
            sum_mantissa <= sum_mantissa(8 downto 0) & '0';  
            sum_exp      <= std_logic_vector((unsigned(sum_exp)-1));
            state        <= NORMALIZE_STATE; 
          else
            state <= OUTPUT_STATE;  
          end if;

        when OUTPUT_STATE =>
          sum(7 downto 0)   <= sum_mantissa(7 downto 0);
          sum(14 downto 8)  <= sum_exp(6 downto 0);
          sum(15)           <= sum_sgn;
          done              <= '1';     
          if (start = '0') then         
            done  <= '0';
            state <= WAIT_STATE;
          end if;

        when others => 
          state <= WAIT_STATE;      
      end case;
    end if;
  end process;

end mixed;
