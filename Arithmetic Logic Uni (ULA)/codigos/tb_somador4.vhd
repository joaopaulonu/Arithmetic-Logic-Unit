library ieee;
use ieee.std_logic_1164.all;

entity tb_adder4 is
end entity tb_adder4;

architecture teste of tb_adder4 is

    -- Declaracao do componente testado
    component adder4 is
        port (
            a        : in  std_logic_vector(3 downto 0);
            b        : in  std_logic_vector(3 downto 0);
            sub      : in  std_logic;
            resultado: out std_logic_vector(3 downto 0);
            cout     : out std_logic;
            overflow : out std_logic
        );
    end component;

    -- Sinais de estimulo e observacao
    signal tb_a        : std_logic_vector(3 downto 0) := "0000"; -- Operando A
    signal tb_b        : std_logic_vector(3 downto 0) := "0000"; -- Operando B
    signal tb_sub      : std_logic := '0';                       -- Controle ADD/SUB
    signal tb_resultado: std_logic_vector(3 downto 0);           -- Saida resultado
    signal tb_cout     : std_logic;                              -- Saida carry out
    signal tb_overflow : std_logic;                              -- Saida overflow

begin

    -- Instancia do componente sendo testado
    DUT: adder4 port map (
        a         => tb_a,
        b         => tb_b,
        sub       => tb_sub,
        resultado => tb_resultado,
        cout      => tb_cout,
        overflow  => tb_overflow
    );

    process
    begin

        -- ---- TESTES DE SOMA (sub=0) ----

        -- Teste 1: 3 + 4 = 7 -> resultado=0111, cout=0, overflow=0
        tb_sub <= '0'; tb_a <= "0011"; tb_b <= "0100";
        wait for 30 ns;

        -- Teste 2: 7 + 1 = 8 -> resultado=1000, cout=0, overflow=1 (pos+pos=neg: overflow!)
        tb_sub <= '0'; tb_a <= "0111"; tb_b <= "0001";
        wait for 30 ns;

        -- Teste 3: 8 + 8 = 16 -> resultado=0000, cout=1 (carry ocorre), overflow=0
        tb_sub <= '0'; tb_a <= "1000"; tb_b <= "1000";
        wait for 30 ns;

        -- Teste 4: 15 + 1 = 16 -> resultado=0000, cout=1
        tb_sub <= '0'; tb_a <= "1111"; tb_b <= "0001";
        wait for 30 ns;

        -- ---- TESTES DE SUBTRACAO (sub=1) ----

        -- Teste 5: 5 - 3 = 2 -> resultado=0010, cout=1 (borrow nao ocorre)
        tb_sub <= '1'; tb_a <= "0101"; tb_b <= "0011";
        wait for 30 ns;

        -- Teste 6: 3 - 5 = -2 (em complemento: 1110) -> cout=0
        tb_sub <= '1'; tb_a <= "0011"; tb_b <= "0101";
        wait for 30 ns;

        -- Teste 7: 0 - 1 = -1 (em complemento de 2: 1111)
        tb_sub <= '1'; tb_a <= "0000"; tb_b <= "0001";
        wait for 30 ns;

        -- Teste 8: 8 - 1 = 7 -> resultado=0111, cout=1
        tb_sub <= '1'; tb_a <= "1000"; tb_b <= "0001";
        wait for 30 ns;

        -- Encerra simulacao
        wait;

    end process;

end architecture teste;