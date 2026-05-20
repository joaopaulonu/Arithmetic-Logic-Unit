library ieee;
use ieee.std_logic_1164.all;           -- Tipos logicos padrao

entity comparator4 is
    port (
        a   : in  std_logic_vector(3 downto 0);  -- Primeiro numero (4 bits)
        b   : in  std_logic_vector(3 downto 0);  -- Segundo numero (4 bits)
        equ : out std_logic;                     -- 1 se a = b
        grt : out std_logic;                     -- 1 se a > b
        lst : out std_logic                      -- 1 se a < b
    );
end entity comparator4;

architecture porta_logica of comparator4 is

    -- Sinais auxiliares para indicar se cada bit de a eh igual ao de b
    -- igual(i) = 1 quando a(i) = b(i)
    signal igual : std_logic_vector(3 downto 0);

    -- Sinal auxiliar para o resultado de igualdade completa
    signal todos_iguais : std_logic;

begin

    -- Verifica igualdade bit a bit usando XNOR
    -- XNOR retorna 1 quando os dois bits sao iguais
    igual(0) <= not (a(0) xor b(0));   -- bit 0: 1 se a(0) = b(0)
    igual(1) <= not (a(1) xor b(1));   -- bit 1: 1 se a(1) = b(1)
    igual(2) <= not (a(2) xor b(2));   -- bit 2: 1 se a(2) = b(2)
    igual(3) <= not (a(3) xor b(3));   -- bit 3: 1 se a(3) = b(3)

    -- Igualdade total: todos os bits devem ser iguais
    todos_iguais <= igual(3) and igual(2) and igual(1) and igual(0);

    -- Saida EQU: 1 somente se todos os bits forem iguais
    equ <= todos_iguais;

    -- Saida GRT (a > b): comparacao bit a bit do mais para o menos significativo
    -- a > b se o primeiro bit diferente (do mais significativo) for a=1 e b=0
    --
    -- Bit 3 diferente e a(3)=1: a > b independente dos outros bits
    -- Bit 3 igual, bit 2 diferente e a(2)=1: a > b
    -- Bit 3,2 iguais, bit 1 diferente e a(1)=1: a > b
    -- Bit 3,2,1 iguais, bit 0 diferente e a(0)=1: a > b
    grt <= (a(3) and not b(3))
        or (igual(3) and  a(2) and not b(2))
        or (igual(3) and igual(2) and  a(1) and not b(1))
        or (igual(3) and igual(2) and igual(1) and  a(0) and not b(0));

    -- Saida LST (a < b): logica simetrica ao GRT, mas com b > a
    lst <= (not a(3) and b(3))
        or (igual(3) and not a(2) and  b(2))
        or (igual(3) and igual(2) and not a(1) and  b(1))
        or (igual(3) and igual(2) and igual(1) and not a(0) and  b(0));

end architecture porta_logica;
