library ieee;
use ieee.std_logic_1164.all;           -- Tipos logicos padrao

-- O testbench nao tem portas (entity vazia e padrao de TB)
entity tb_full_adder is
end entity tb_full_adder;

architecture teste of tb_full_adder is

    -- Declaracao do componente que sera testado
    component full_adder is
        port (
            a    : in  std_logic;
            b    : in  std_logic;
            cin  : in  std_logic;
            soma : out std_logic;
            cout : out std_logic
        );
    end component;

    -- Sinais que conectamos ao componente (entradas e saidas)
    signal tb_a    : std_logic := '0'; -- Sinal de teste para entrada a
    signal tb_b    : std_logic := '0'; -- Sinal de teste para entrada b
    signal tb_cin  : std_logic := '0'; -- Sinal de teste para carry in
    signal tb_soma : std_logic;        -- Recebe a saida soma do componente
    signal tb_cout : std_logic;        -- Recebe o carry out do componente

begin

    -- Instancia o componente conectando os sinais do TB aos pinos
    DUT: full_adder port map (
        a    => tb_a,
        b    => tb_b,
        cin  => tb_cin,
        soma => tb_soma,
        cout => tb_cout
    );

    -- Processo de estimulos: aplica todas as combinacoes possivel
    process
    begin

        -- Teste 1: 0+0+0 = soma=0, cout=0
        tb_a <= '0'; tb_b <= '0'; tb_cin <= '0';
        wait for 20 ns;                -- Aguarda o circuito estabilizar

        -- Teste 2: 1+0+0 = soma=1, cout=0
        tb_a <= '1'; tb_b <= '0'; tb_cin <= '0';
        wait for 20 ns;

        -- Teste 3: 0+1+0 = soma=1, cout=0
        tb_a <= '0'; tb_b <= '1'; tb_cin <= '0';
        wait for 20 ns;

        -- Teste 4: 1+1+0 = soma=0, cout=1
        tb_a <= '1'; tb_b <= '1'; tb_cin <= '0';
        wait for 20 ns;

        -- Teste 5: 0+0+1 = soma=1, cout=0
        tb_a <= '0'; tb_b <= '0'; tb_cin <= '1';
        wait for 20 ns;

        -- Teste 6: 1+0+1 = soma=0, cout=1
        tb_a <= '1'; tb_b <= '0'; tb_cin <= '1';
        wait for 20 ns;

        -- Teste 7: 0+1+1 = soma=0, cout=1
        tb_a <= '0'; tb_b <= '1'; tb_cin <= '1';
        wait for 20 ns;

        -- Teste 8: 1+1+1 = soma=1, cout=1
        tb_a <= '1'; tb_b <= '1'; tb_cin <= '1';
        wait for 20 ns;

        -- Encerra a simulacao
        wait;

    end process;

end architecture teste;