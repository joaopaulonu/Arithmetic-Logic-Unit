-- ============================================================
-- Arquivo: tb_comparator4.vhd
-- Descricao: Testbench do Comparador de 4 bits
-- Testa: a=b, a>b, a<b, casos extremos (0 e 15)
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

entity tb_comparator4 is
end entity tb_comparator4;

architecture teste of tb_comparator4 is

    -- Declaracao do componente testado
    component comparator4 is
        port (
            a   : in  std_logic_vector(3 downto 0);
            b   : in  std_logic_vector(3 downto 0);
            equ : out std_logic;
            grt : out std_logic;
            lst : out std_logic
        );
    end component;

    -- Sinais de estimulo e observacao
    signal tb_a   : std_logic_vector(3 downto 0) := "0000"; -- Operando A
    signal tb_b   : std_logic_vector(3 downto 0) := "0000"; -- Operando B
    signal tb_equ : std_logic;                              -- Saida: igual
    signal tb_grt : std_logic;                              -- Saida: maior
    signal tb_lst : std_logic;                              -- Saida: menor

begin

    -- Instancia o comparador
    DUT: comparator4 port map (
        a   => tb_a,
        b   => tb_b,
        equ => tb_equ,
        grt => tb_grt,
        lst => tb_lst
    );

    process
    begin

        -- Teste 1: 0 = 0 -> equ=1, grt=0, lst=0
        tb_a <= "0000"; tb_b <= "0000"; wait for 30 ns;

        -- Teste 2: 5 = 5 -> equ=1, grt=0, lst=0
        tb_a <= "0101"; tb_b <= "0101"; wait for 30 ns;

        -- Teste 3: 15 = 15 -> equ=1, grt=0, lst=0 (maximo igual)
        tb_a <= "1111"; tb_b <= "1111"; wait for 30 ns;

        -- Teste 4: 7 > 3 -> equ=0, grt=1, lst=0
        tb_a <= "0111"; tb_b <= "0011"; wait for 30 ns;

        -- Teste 5: 8 > 7 -> equ=0, grt=1, lst=0 (diferenca de 1)
        tb_a <= "1000"; tb_b <= "0111"; wait for 30 ns;

        -- Teste 6: 15 > 0 -> equ=0, grt=1, lst=0 (extremos)
        tb_a <= "1111"; tb_b <= "0000"; wait for 30 ns;

        -- Teste 7: 3 < 7 -> equ=0, grt=0, lst=1
        tb_a <= "0011"; tb_b <= "0111"; wait for 30 ns;

        -- Teste 8: 0 < 1 -> equ=0, grt=0, lst=1 (diferenca de 1)
        tb_a <= "0000"; tb_b <= "0001"; wait for 30 ns;

        -- Teste 9: 0 < 15 -> equ=0, grt=0, lst=1 (extremos)
        tb_a <= "0000"; tb_b <= "1111"; wait for 30 ns;

        -- Encerra a simulacao
        wait;

    end process;

end architecture teste;