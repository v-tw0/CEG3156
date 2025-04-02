library ieee;
use ieee.std_logic_1164.all;

entity HazardDetectionUnit is
port (
	IdExMemRead : in std_logic;
	IdExRt, IfIdRs, IfIdRt : in std_logic_vector(4 downto 0);
	PCWrite, stall : out std_logic
);
end HazardDetectionUnit;

Architecture rtl of HazardDetectionUnit is
SIGNAL eq_Rs, eq_Rt : std_logic;

begin

	eq_Rs <= (IdExRt(4) XNOR IfIdRs(4)) AND (IdExRt(3) XNOR IfIdRs(3)) AND (IdExRt(2) XNOR IfIdRs(2)) AND (IdExRt(1) XNOR IfIdRs(1)) AND (IdExRt(0) XNOR IfIdRs(0));
	eq_Rt <= (IdExRt(4) XNOR IfIdRt(4)) AND (IdExRt(3) XNOR IfIdRt(3)) AND (IdExRt(2) XNOR IfIdRt(2)) AND (IdExRt(1) XNOR IfIdRt(1)) AND (IdExRt(0) XNOR IfIdRt(0));

	stall <= IdExMemRead AND (eq_Rs or eq_Rt); 
	PCWrite <= not(IdExMemRead AND (eq_Rs or eq_Rt));
end rtl;