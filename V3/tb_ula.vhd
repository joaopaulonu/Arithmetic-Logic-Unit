-- ============================================================
-- Arquivo: tb_ula.vhd
-- Descricao: Testbench da ULA completa
-- Testa todos os 8 opcodes em sequencia com valores variados
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

entity tb_ula is
end entity tb_ula;

architecture teste of tb_ula is

    -- Declaracao do componente ULA completo
    component ula is
        port (
            SW   : in  std_logic_vector(10 downto 0);
            HEX0 : out std_logic_vector(6 downto 0);
            HEX2 : out std_logic_vector(6 downto 0);
            HEX4 : out std_logic_vector(6 downto 0);
            HEX6 : out std_logic_vector(6 downto 0);
            LEDR : out std_logic_vector(5 downto 0)
        );
    end component;

    -- Sinal de entrada principal: todos os switches em um so vetor
    -- SW(10..7)=A, SW(6..3)=B, SW(2..0)=opcode
    signal tb_SW   : std_logic_vector(10 downto 0) := (others => '0');

    -- Sinais de saida para observacao na simulacao
    signal tb_HEX0 : std_logic_vector(6 downto 0);  -- Display AluOp
    signal tb_HEX2 : std_logic_vector(6 downto 0);  -- Display B
    signal tb_HEX4 : std_logic_vector(6 downto 0);  -- Display A
    signal tb_HEX6 : std_logic_vector(6 downto 0);  -- Display Result
    signal tb_LEDR : std_logic_vector(5 downto 0);  -- LEDs de flags

    -- Procedure auxiliar para facilitar a leitura dos testes
    -- Define A, B e opcode de forma separada e clara
    procedure aplica_teste(
        signal sw  : out std_logic_vector(10 downto 0);
        a_val      : in  std_logic_vector(3 downto 0);  -- Valor de A
        b_val      : in  std_logic_vector(3 downto 0);  -- Valor de B
        op_val     : in  std_logic_vector(2 downto 0)   -- Opcode
    ) is
    begin
        -- Monta o vetor de switches conforme o mapeamento do projeto
        sw <= a_val & b_val & op_val;   -- SW = A(10..7) & B(6..3) & OP(2..0)
        wait for 40 ns;                 -- Aguarda estabilizacao
    end procedure aplica_teste;

begin

    -- Instancia a ULA completa
    DUT: ula port map (
        SW   => tb_SW,
        HEX0 => tb_HEX0,
        HEX2 => tb_HEX2,
        HEX4 => tb_HEX4,
        HEX6 => tb_HEX6,
        LEDR => tb_LEDR
    );

    process
    begin

        -- ==================================================
        -- OPCODE 000: NOP
        -- A=5 (0101), B=3 (0011) -> Result=0000, flags=0
        -- ==================================================
        aplica_teste(tb_SW, "0101", "0011", "000");

        -- ==================================================
        -- OPCODE 001: AND
        -- A=1100, B=1010 -> Result=1000 (AND bit a bit)
        -- ==================================================
        aplica_teste(tb_SW, "1100", "1010", "001");

        -- ==================================================
        -- OPCODE 010: OR
        -- A=1100, B=0011 -> Result=1111 (OR bit a bit)
        -- ==================================================
        aplica_teste(tb_SW, "1100", "0011", "010");

        -- ==================================================
        -- OPCODE 011: NOT
        -- B=0101 -> Result=1010 (NOT de B)
        -- ==================================================
        aplica_teste(tb_SW, "0000", "0101", "011");

        -- ==================================================
        -- OPCODE 100: ADD
        -- A=3 (0011), B=4 (0100) -> Result=7 (0111)
        -- cout=0, overflow=0
        -- ==================================================
        aplica_teste(tb_SW, "0011", "0100", "100");

        -- ==================================================
        -- OPCODE 100: ADD com overflow
        -- A=7 (0111), B=1 (0001) -> Result=8 (1000)
        -- overflow=1 (pos+pos=neg em complemento de 2)
        -- ==================================================
        aplica_teste(tb_SW, "0111", "0001", "100");

        -- ==================================================
        -- OPCODE 101: SUB
        -- A=7 (0111), B=3 (0011) -> Result=4 (0100)
        -- cout=1 (sem borrow), overflow=0
        -- ==================================================
        aplica_teste(tb_SW, "0111", "0011", "101");

        -- ==================================================
        -- OPCODE 101: SUB com resultado negativo
        -- A=2 (0010), B=5 (0101) -> Result=-3 (1101 em comp2)
        -- ==================================================
        aplica_teste(tb_SW, "0010", "0101", "101");

        -- ==================================================
        -- OPCODE 110: MUL
        -- A=xx11 (LSBs=3), B=xx10 (LSBs=2) -> Result=6 (0110)
        -- ==================================================
        aplica_teste(tb_SW, "1011", "0110", "110");

        -- ==================================================
        -- OPCODE 111: COMP - iguais
        -- A=5 (0101), B=5 (0101) -> equ=1, grt=0, lst=0
        -- ==================================================
        aplica_teste(tb_SW, "0101", "0101", "111");

        -- ==================================================
        -- OPCODE 111: COMP - A maior
        -- A=9 (1001), B=3 (0011) -> equ=0, grt=1, lst=0
        -- ==================================================
        aplica_teste(tb_SW, "1001", "0011", "111");

        -- ==================================================
        -- OPCODE 111: COMP - A menor
        -- A=2 (0010), B=8 (1000) -> equ=0, grt=0, lst=1
        -- ==================================================
        aplica_teste(tb_SW, "0010", "1000", "111");

        -- ==================================================
        -- OPCODE 000: NOP com Zero flag
        -- Resultado deve ser 0000 -> LEDR(1)=zero=1
        -- ==================================================
        aplica_teste(tb_SW, "0000", "0000", "000");

        -- Encerra a simulacao
        wait;

    end process;

end architecture teste;