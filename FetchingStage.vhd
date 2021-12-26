LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY fetch_stage IS
    PORT (
        rst, clk, pc_write, instType : IN STD_LOGIC;
        in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IF_ID_BUFFER : OUT STD_LOGIC_VECTOR(80 DOWNTO 0)
    );

END fetch_stage;

ARCHITECTURE fetch_stage_arch OF fetch_stage IS

    COMPONENT PC IS
        PORT (
            rst, clk, en : IN STD_LOGIC;
            current_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT INSTRUCTION_MEMORY IS
        GENERIC (n : INTEGER := 16);
        PORT (
            clk : IN STD_LOGIC;
            pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            read_instruction : IN STD_LOGIC;
            instruction : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL instr_en : STD_LOGIC;
    SIGNAL instr : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL pc_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    instr_en <= NOT rst;

    x : PC PORT MAP(rst, clk, instr_en, pc_out);
    y : INSTRUCTION_MEMORY PORT MAP(clk, pc_out, instr_en, instr);

    IF_ID_BUFFER <= in_port & '0' & instr & (X"0000") & pc_out;

END fetch_stage_arch;