Library ieee;
use ieee.std_logic_1164.all;

Entity ForwardingUnit is
	port (
		ExMemRegWrite, MemWbRegWrite : in std_logic;
		ExMemRd, MemWbRd, IdExRs, IdExRt : in std_logic_vector(4 downto 0);
		muxA, muxB : out std_logic_vector(1 downto 0)
	);
end ForwardingUnit;

Architecture rtl of ForwardingUnit is
	signal ExMemNotZero, MemWbNotZero, ExMemRd_EQ_IdExRs, MemWbRd_EQ_IdExRs, ExMemRd_EQ_IdExRt, MemWbRd_EQ_IdExRt : std_logic;

begin

	ExMemRd_EQ_IdExRs <= (ExMemRd(4) XNOR IdExRs(4)) AND (ExMemRd(3) XNOR IdExRs(3)) AND (ExMemRd(2) XNOR IdExRs(2)) AND (ExMemRd(1) XNOR IdExRs(1)) AND (ExMemRd(0) XNOR IdExRs(0));
	MemWbRd_EQ_IdExRs <= (MemWbRd(4) XNOR IdExRs(4)) AND (MemWbRd(3) XNOR IdExRs(3)) AND (MemWbRd(2) XNOR IdExRs(2)) AND (MemWbRd(1) XNOR IdExRs(1)) AND (MemWbRd(0) XNOR IdExRs(0));
	MemWbRd_EQ_IdExRt <= (MemWbRd(4) XNOR IdExRt(4)) AND (MemWbRd(3) XNOR IdExRt(3)) AND (MemWbRd(2) XNOR IdExRt(2)) AND (MemWbRd(1) XNOR IdExRt(1)) AND (MemWbRd(0) XNOR IdExRt(0));
	ExMemRd_EQ_IdExRt <= (ExMemRd(4) XNOR IdExRt(4)) AND (ExMemRd(3) XNOR IdExRt(3)) AND (ExMemRd(2) XNOR IdExRt(2)) AND (ExMemRd(1) XNOR IdExRt(1)) AND (ExMemRd(0) XNOR IdExRt(0));
	ExMemNotZero <= ExMemRegWrite AND (ExMemRd(4) OR ExMemRd(3) OR ExMemRd(2) OR ExMemRd(1) OR ExMemRd(0));
	MemWbNotZero <= MemWbRegWrite AND (ExMemRd(4) OR ExMemRd(3) OR ExMemRd(2) OR ExMemRd(1) OR ExMemRd(0));
	
	MuxA(1) <= ExMemNotZero AND ExMemRd_EQ_IdExRs;
	MuxA(0) <= MemWbNotZero AND MemWbRd_EQ_IdExRs;
	MuxB(1) <= ExMemNotZero AND ExMemRd_EQ_IdExRt;
	MuxB(0) <= MemWbNotZero AND MemWbRd_EQ_IdExRt;
end rtl; 