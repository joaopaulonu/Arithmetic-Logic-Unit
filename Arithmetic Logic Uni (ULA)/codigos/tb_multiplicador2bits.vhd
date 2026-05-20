library ieee;
use ieee.std_logic_1164.all;

entity tb_multiplier2x2 is
end entity tb_multiplier2x2;

architecture teste of tb_multiplier2x2 is

    -- Declaracao do componente testado
    component multiplier2x2 is
        port (
            a        : in  std_logic_vector(1 downto 0);
            b        : in  std_logic_vector(1 downto 0);
            resultado: out std_logic_vector(3 downto 0)
        );
    end component;

    -- Sinais de estimulo
    signal tb_a        : std_logic_vector(1 downto 0) := "00"; -- Entrada A (2 bits)
    signal tb_b        : std_logic_vector(1 downto 0) := "00"; -- Entrada B (2 bits)
    signal tb_resultado: std_logic_vector(3 downto 0);         -- Resultado (4 bits)

begin

    -- Instancia o componente
    DUT: multiplier2x2 port map (
        a         => tb_a,
        b         => tb_b,
        resultado => tb_resultado
    );

    process
    begin

        -- Teste: 0 x 0 = 0 -> resultado = 0000
        tb_a <= "00"; tb_b <= "00"; wait for 20 ns;

        -- Teste: 0 x 1 = 0 -> resultado = 0000
        tb_a <= "00"; tb_b <= "01"; wait for 20 ns;

        -- Teste: 0 x 2 = 0 -> resultado = 0000
        tb_a <= "00"; tb_b <= "10"; wait for 20 ns;

        -- Teste: 0 x 3 = 0 -> resultado = 0000
        tb_a <= "00"; tb_b <= "11"; wait for 20 ns;

        -- Teste: 1 x 0 = 0 -> resultado = 0000
        tb_a <= "01"; tb_b <= "00"; wait for 20 ns;

        -- Teste: 1 x 1 = 1 -> resultado = 0001
        tb_a <= "01"; tb_b <= "01"; wait for 20 ns;

        -- Teste: 1 x 2 = 2 -> resultado = 0010
        tb_a <= "01"; tb_b <= "10"; wait for 20 ns;

        -- Teste: 1 x 3 = 3 -> resultado = 0011
        tb_a <= "01"; tb_b <= "11"; wait for 20 ns;

        -- Teste: 2 x 0 = 0 -> resultado = 0000
        tb_a <= "10"; tb_b <= "00"; wait for 20 ns;

        -- Teste: 2 x 1 = 2 -> resultado = 0010
        tb_a <= "10"; tb_b <= "01"; wait for 20 ns;

        -- Teste: 2 x 2 = 4 -> resultado = 0100
        tb_a <= "10"; tb_b <= "10"; wait for 20 ns;

        -- Teste: 2 x 3 = 6 -> resultado = 0110
        tb_a <= "10"; tb_b <= "11"; wait for 20 ns;

        -- Teste: 3 x 0 = 0 -> resultado = 0000
        tb_a <= "11"; tb_b <= "00"; wait for 20 ns;

        -- Teste: 3 x 1 = 3 -> resultado = 0011
        tb_a <= "11"; tb_b <= "01"; wait for 20 ns;

        -- Teste: 3 x 2 = 6 -> resultado = 0110
        tb_a <= "11"; tb_b <= "10"; wait for 20 ns;

        -- Teste: 3 x 3 = 9 -> resultado = 1001 (caso maximo)
        tb_a <= "11"; tb_b <= "11"; wait for 20 ns;

        -- Encerra simulacao
        wait;

    end process;

end architecture teste;