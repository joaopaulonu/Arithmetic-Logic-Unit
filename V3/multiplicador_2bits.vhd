-- ============================================================
-- Arquivo: multiplier2x2.vhd
-- Descricao: Multiplicador de 2 bits x 2 bits
-- Usa apenas os 2 bits menos significativos de cada entrada
-- Resultado eh um numero de 4 bits
-- Metodo: multiplicacao binaria com portas AND e somadores parciais
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;           -- Tipos logicos padrao

entity multiplier2x2 is
    port (
        a        : in  std_logic_vector(1 downto 0);  -- Multiplicando (2 bits menos sig. de A)
        b        : in  std_logic_vector(1 downto 0);  -- Multiplicador (2 bits menos sig. de B)
        resultado: out std_logic_vector(3 downto 0)   -- Produto (4 bits)
    );
end entity multiplier2x2;

architecture porta_logica of multiplier2x2 is

    -- Produtos parciais (como na multiplicacao manual em binario)
    -- pp(i)(j) = a(i) AND b(j)
    signal pp00 : std_logic;           -- a(0) * b(0) -> coluna 0
    signal pp10 : std_logic;           -- a(1) * b(0) -> coluna 1
    signal pp01 : std_logic;           -- a(0) * b(1) -> coluna 1
    signal pp11 : std_logic;           -- a(1) * b(1) -> coluna 2

    -- Sinais intermediarios para somar os produtos parciais
    signal soma_col1 : std_logic;      -- Soma da coluna 1 (bit 1 do resultado)
    signal carry_col1: std_logic;      -- Carry da coluna 1 para a coluna 2

begin

    -- Calculo dos produtos parciais (cada um eh um AND de um bit de a com um bit de b)
    -- Isso equivale a multiplicar cada combinacao de bits
    pp00 <= a(0) and b(0);             -- Produto parcial: linha 0, coluna 0
    pp10 <= a(1) and b(0);             -- Produto parcial: linha 1, coluna 0
    pp01 <= a(0) and b(1);             -- Produto parcial: linha 0, coluna 1
    pp11 <= a(1) and b(1);             -- Produto parcial: linha 1, coluna 1

    -- Bit 0 do resultado: apenas pp00 (nenhum carry nessa coluna)
    resultado(0) <= pp00;

    -- Bit 1 do resultado: soma de pp10 e pp01 (dois produtos caem na coluna 1)
    soma_col1  <= pp10 xor pp01;       -- Soma dos produtos da coluna 1
    carry_col1 <= pp10 and pp01;       -- Carry da coluna 1 para coluna 2

    -- Bit 1 final
    resultado(1) <= soma_col1;

    -- Bit 2: pp11 somado com o carry da coluna 1
    resultado(2) <= pp11 xor carry_col1;

    -- Bit 3: carry gerado na coluna 2 (se pp11 e carry_col1 forem ambos 1)
    resultado(3) <= pp11 and carry_col1;

end architecture porta_logica;