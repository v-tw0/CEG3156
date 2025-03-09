library ieee;
  use ieee.std_logic_1164.all;

entity nbitmux8to1 is
  generic (

    n : integer := 8
  );
  port (
    sel0 : in    std_logic;
    sel1 : in    std_logic;
    sel2 : in    std_logic;
    d0  : in    std_logic_vector(n - 1 downto 0);
    d1  : in    std_logic_vector(n - 1 downto 0);
    d2  : in    std_logic_vector(n - 1 downto 0);
    d3  : in    std_logic_vector(n - 1 downto 0);
    d4  : in    std_logic_vector(n - 1 downto 0);
    d5  : in    std_logic_vector(n - 1 downto 0);
    d6  : in    std_logic_vector(n - 1 downto 0);
    d7  : in    std_logic_vector(n - 1 downto 0);
    y    : out   std_logic_vector(n - 1 downto 0)
  );
end entity nbitmux8to1;

architecture struct of nbitmux8to1 is

  signal and0       : std_logic_vector(n - 1 downto 0);
  signal and1       : std_logic_vector(n - 1 downto 0);
  signal and2       : std_logic_vector(n - 1 downto 0);
  signal and3       : std_logic_vector(n - 1 downto 0);
  signal and4       : std_logic_vector(n - 1 downto 0);
  signal and5       : std_logic_vector(n - 1 downto 0);
  signal and6       : std_logic_vector(n - 1 downto 0);
  signal and7       : std_logic_vector(n - 1 downto 0);
  signal sel0vec    : std_logic_vector(n - 1 downto 0);
  signal sel1vec    : std_logic_vector(n - 1 downto 0);
  signal sel2vec    : std_logic_vector(n - 1 downto 0);
  signal sel0notvec : std_logic_vector(n - 1 downto 0);
  signal sel1notvec : std_logic_vector(n - 1 downto 0);
  signal sel2notvec : std_logic_vector(n - 1 downto 0);

begin

  sel0vec    <= (others => sel0);
  sel1vec    <= (others => sel1);
  sel2vec    <= (others => sel2);
  sel0notvec <= not sel0vec;
  sel1notvec <= not sel1vec;
  sel2notvec <= not sel2vec;
  and7 <= d7 and (sel0vec and sel1vec and sel2vec);
  and6 <= d6 and (sel0notvec and sel1vec and sel2vec);
  and5 <= d5 and (sel0vec and sel1notvec and sel2vec);
  and4 <= d4 and (sel1notvec and sel0notvec and sel2vec);
  and3 <= d3 and (sel0vec and sel1vec and sel2notvec);
  and2 <= d2 and (sel0notvec and sel1vec and sel2notvec);
  and1 <= d1 and (sel0vec and sel1notvec and sel2notvec);
  and0 <= d0 and (sel1notvec and sel0notvec and sel2notvec);

  y <= and0 or and1 or and2 or and3 or and4 or and5 or and6 or and7;

end architecture struct;