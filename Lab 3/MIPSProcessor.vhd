LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MIPSProcessor IS
    PORT(
        GClock, GReset : IN std_logic;
        ValueSelect : IN std_logic_vector(2 DOWNTO 0);
        InstrSelect : IN std_logic_vector(2 DOWNTO 0);
        MuxOut : OUT std_logic_vector(7 DOWNTO 0);
        InstructionOut : OUT std_logic_vector(31 DOWNTO 0);
        BranchOut, ZeroOut, MemWriteOut, RegWriteOut : OUT std_logic
    );
END MIPSProcessor;

ARCHITECTURE RTL OF MIPSProcessor IS

    -- Instruction Fetch (IF) Stage Signals
    SIGNAL PC, PCNext, PCAdd4, Instr : std_logic_vector(7 DOWNTO 0);
    SIGNAL InstrFull : std_logic_vector(31 DOWNTO 0);

    -- IF/ID Pipeline Register Outputs
    SIGNAL IF_ID_PCAdd4, IF_ID_Instruction : std_logic_vector(7 DOWNTO 0);
    SIGNAL IF_ID_InstructionFull : std_logic_vector(31 DOWNTO 0);

    -- Instruction Decode (ID) Stage Signals
    SIGNAL ReadData1, ReadData2 : std_logic_vector(7 DOWNTO 0);
    SIGNAL RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch : std_logic;
    SIGNAL ALUOp : std_logic_vector(1 DOWNTO 0);
    SIGNAL Rs, Rt, Rd : std_logic_vector(2 DOWNTO 0);

    -- ID/EX Pipeline Register Outputs
    SIGNAL ID_EX_RegWrite, ID_EX_MemToReg, ID_EX_MemRead, ID_EX_MemWrite : std_logic;
    SIGNAL ID_EX_RegDst, ID_EX_ALUSrc : std_logic;
    SIGNAL ID_EX_ALUOp : std_logic_vector(1 DOWNTO 0);
    SIGNAL ID_EX_ReadData1, ID_EX_ReadData2, ID_EX_Offset : std_logic_vector(7 DOWNTO 0);
    SIGNAL ID_EX_Rs, ID_EX_Rt, ID_EX_Rd : std_logic_vector(2 DOWNTO 0);

    -- Execution (EX) Stage Signals
    SIGNAL ALUResult : std_logic_vector(7 DOWNTO 0);
    SIGNAL Zero : std_logic;
    SIGNAL ForwardA, ForwardB : std_logic_vector(1 DOWNTO 0);
    SIGNAL EX_MEM_RegWrite, EX_MEM_MemToReg, EX_MEM_MemRead, EX_MEM_MemWrite : std_logic;
    SIGNAL EX_MEM_ALUResult, EX_MEM_RegisterRt : std_logic_vector(7 DOWNTO 0);
    SIGNAL EX_MEM_RegisterRd : std_logic_vector(2 DOWNTO 0);

    -- Memory (MEM) Stage Signals
    SIGNAL MemReadData : std_logic_vector(7 DOWNTO 0);
    SIGNAL MEM_WB_RegWrite, MEM_WB_MemToReg : std_logic;
    SIGNAL MEM_WB_ReadData, MEM_WB_ALUResult : std_logic_vector(7 DOWNTO 0);
    SIGNAL MEM_WB_RegisterRd : std_logic_vector(2 DOWNTO 0);

BEGIN

    -- Instruction Fetch Stage
    InstructionMemory: entity work.instructionMem
        PORT MAP(address => PC, clock => GClock, data => (others => '0'), wren => '0', q => InstrFull);

    PC_Register: entity work.register8Bit
        PORT MAP(inp => PCNext, i_load => '1', i_clock => GClock, i_resetBar => GReset, outp => PC);

    -- IF/ID Pipeline Register
    IF_ID_Reg: entity work.IF_ID
        PORT MAP(Enable => '1', GClock => GClock, GReset => GReset, 
                 PCAdd4 => PCAdd4, PCAdd4Out => IF_ID_PCAdd4, 
                 Instruction => InstrFull, InstructionOut => IF_ID_InstructionFull);

    -- Instruction Decode Stage
    Control_Unit: entity work.ControlUnit
        PORT MAP(OPCode => IF_ID_InstructionFull(31 DOWNTO 26), RegDst => RegDst, ALUSrc => ALUSrc,
                 MemtoReg => MemtoReg, RegWrite => RegWrite, MemRead => MemRead, 
                 MemWrite => MemWrite, Branch => Branch, ALUOp1 => ALUOp(1), ALUOp0 => ALUOp(0));

    Register_File: entity work.registerFile
        PORT MAP(i_resetBar => GReset, i_clock => GClock, RegWrite => MEM_WB_RegWrite,
                 ReadReg1 => IF_ID_InstructionFull(25 DOWNTO 21), ReadReg2 => IF_ID_InstructionFull(20 DOWNTO 16), 
                 WriteReg => MEM_WB_RegisterRd, writeValue => MEM_WB_ReadData, 
                 ReadData1 => ReadData1, ReadData2 => ReadData2);

    -- ID/EX Pipeline Register
    ID_EX_Reg: entity work.ID_EX
        PORT MAP(Enable => '1', GClock => GClock, GReset => GReset, 
                 RegWrite => RegWrite, MemToReg => MemtoReg, 
                 MemRead => MemRead, MemWrite => MemWrite, 
                 RegDst => RegDst, ALUSrc => ALUSrc, ALUOp => ALUOp, 
                 Rd => IF_ID_InstructionFull(15 DOWNTO 11), 
                 Rt => IF_ID_InstructionFull(20 DOWNTO 16), 
                 Rs => IF_ID_InstructionFull(25 DOWNTO 21),
                 ReadData1 => ReadData1, ReadData2 => ReadData2, OFFset => IF_ID_InstructionFull(7 DOWNTO 0), 
                 RegWriteOut => ID_EX_RegWrite, MemToRegOut => ID_EX_MemToReg, 
                 MemReadOut => ID_EX_MemRead, MemWriteOut => ID_EX_MemWrite, 
                 RegDstOut => ID_EX_RegDst, ALUSrcOut => ID_EX_ALUSrc, 
                 ALUOpOut => ID_EX_ALUOp, RdOut => ID_EX_Rd, RtOut => ID_EX_Rt, RsOut => ID_EX_Rs, 
                 ReadData1Out => ID_EX_ReadData1, ReadData2Out => ID_EX_ReadData2, OFFsetOut => ID_EX_Offset);

    -- Forwarding Unit
    Forwarding_Unit: entity work.ForwardingUnit
        PORT MAP(ExMemRegWrite => EX_MEM_RegWrite, MemWbRegWrite => MEM_WB_RegWrite,
                 ExMemRd => EX_MEM_RegisterRd, MemWbRd => MEM_WB_RegisterRd,
                 IdExRs => ID_EX_Rs, IdExRt => ID_EX_Rt, muxA => ForwardA, muxB => ForwardB);

    -- ALU Execution
    ALU_Unit: entity work.ALU
        PORT MAP(A => ID_EX_ReadData1, B => ID_EX_ReadData2, Operation => ID_EX_ALUOp, 
                 z_out => ALUResult, zero => Zero);

    -- Output Control
    InstructionOut <= IF_ID_InstructionFull;
    BranchOut <= Branch;
    ZeroOut <= Zero;
    MemWriteOut <= MemWrite;
    RegWriteOut <= RegWrite;

END RTL;
