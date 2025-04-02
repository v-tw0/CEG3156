library ieee;
use ieee.std_logic_1164.all;

entity registerFile is
	port (
		i_resetBar, i_clock, RegWrite : in std_logic;
		writeValue : in std_logic_vector (7 downto 0);
		ReadReg1, ReadReg2, WriteReg : in std_logic_vector(2 downto 0);
		ReadData1, ReadData2 : out std_logic_vector(7 downto 0)
	);
end registerFile;

architecture rtl of registerFile is

SIGNAL regDecode, muxOut1, muxOut2: std_logic_vector(7 downto 0);
SIGNAL reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : std_logic_vector(7 downto 0);

component register8bit is
	port(
		inp : in std_logic_vector(7 downto 0);
		i_load, i_clock, i_resetBar : in std_logic;
		outp : out std_logic_vector(7 downto 0)
	);
	
end component;

component decoder3to8 is
	port(
		x, y, z, en : in std_logic;
		r0, r1, r2, r3, r4, r5, r6, r7 : out std_logic
	);
end component;

component mux8to1 is
	port(
		sel : in std_logic_vector(2 downto 0);
		r0, r1, r2, r3, r4, r5, r6, r7 : in std_logic_vector(7 downto 0);
		y_out : out std_logic_vector(7 downto 0)
	);
end component;
	
begin
	decoder : decoder3to8
		port map(
			x => writeReg(2),
			y => writeReg(1),
			z => writeReg(0),
			en => RegWrite,
			r0 => regDecode(0),
			r1 => regDecode(1),
			r2 => regDecode(2),
			r3 => regDecode(3),
			r4 => regDecode(4),
			r5 => regDecode(5),
			r6 => regDecode(6),
			r7 => regDecode(7)
		);
	
	r0: register8bit
			port map(
				inp => writeValue,
				i_load => RegWrite and regDecode(0),
				i_clock => i_clock,
				i_resetBar => i_resetBar,
				outp => reg0
			);
	r1: register8bit
			port map(
				inp => writeValue,
				i_load => RegWrite and regDecode(1),
				i_clock => i_clock,
				i_resetBar => i_resetBar,
				outp => reg1
			);
	r2: register8bit
			port map(
				inp => writeValue,
				i_load => RegWrite and regDecode(2),
				i_clock => i_clock,
				i_resetBar => i_resetBar,
				outp => reg2
			);	
	r3: register8bit
			port map(
				inp => writeValue,
				i_load => RegWrite and regDecode(3),
				i_clock => i_clock,
				i_resetBar => i_resetBar,
				outp => reg3
			);
	r4: register8bit
			port map(
				inp => writeValue,
				i_load => RegWrite and regDecode(4),
				i_clock => i_clock,
				i_resetBar => i_resetBar,
				outp => reg4
			);
	r5: register8bit
			port map(
				inp => writeValue,
				i_load => RegWrite and regDecode(5),
				i_clock => i_clock,
				i_resetBar => i_resetBar,
				outp => reg5
			);
	r6: register8bit
			port map(
				inp => writeValue,
				i_load => RegWrite and regDecode(6),
				i_clock => i_clock,
				i_resetBar => i_resetBar,
				outp => reg6
			);		
	r7: register8bit
			port map(
				inp => writeValue,
				i_load => RegWrite and regDecode(7),
				i_clock => i_clock,
				i_resetBar => i_resetBar,
				outp => reg7
			);
	mux1 : mux8to1
		port map(
			sel => ReadReg1,
			r0 => reg0,
			r1 =>	reg1,
			r2 => reg2,
			r3 => reg3,
			r4 => reg4,
			r5 => reg5,
			r6 => reg6,
			r7 => reg7,
			y_out => muxOut1
		);
		
	mux2 : mux8to1
		port map(
			sel => ReadReg2,
			r0 => reg0,
			r1 =>	reg1,
			r2 => reg2,
			r3 => reg3,
			r4 => reg4,
			r5 => reg5,
			r6 => reg6,
			r7 => reg7,
			y_out => muxOut2
		);
 
	ReadData1 <= muxOut1;
	ReadData2 <= muxOut2;

end rtl;
