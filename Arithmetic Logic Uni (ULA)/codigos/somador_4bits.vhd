library ieee;
use ieee.std_logic_1164.all;           -- Tipos logicos padrao

entity adder4 is
    port (
        a        : in  std_logic_vector(3 downto 0);  -- Operando A (4 bits)
        b        : in  std_logic_vector(3 downto 0);  -- Operando B (4 bits)
        sub      : in  std_logic;                     -- Controle: 0=soma, 1=subtrai
        resultado: out std_logic_vector(3 downto 0);  -- Resultado da operacao
        cout     : out std_logic;                     -- Carry out do bit mais significativo
        overflow : out std_logic                      -- Indica overflow em operacao sinalizada
    );
end entity adder4;

architecture ripple_carry of adder4 is

    -- Declaracao do componente full_adder 
    component full_adder is
        port (
            a    : in  std_logic;
            b    : in  std_logic;
            cin  : in  std_logic;
            soma : out std_logic;
            cout : out std_logic
        );
    end component;

    -- Sinal para guardar o b (possivelmente invertido para subtracao)
    signal b_operando : std_logic_vector(3 downto 0);

    -- Carries intermediarios entre os somadores (c0 a c4)
    -- c(0) = carry inicial, c(4) = carry final
    signal carry : std_logic_vector(4 downto 0);

begin

    -- Se sub=1, invertemos todos os bits de b (NOT b)
    -- Junto com carry(0)=sub=1, isso faz o complemento de 2 de b
    b_operando(0) <= b(0) xor sub;    -- Inverte bit 0 de b se sub=1
    b_operando(1) <= b(1) xor sub;    -- Inverte bit 1 de b se sub=1
    b_operando(2) <= b(2) xor sub;    -- Inverte bit 2 de b se sub=1
    b_operando(3) <= b(3) xor sub;    -- Inverte bit 3 de b se sub=1

    -- O carry inicial eh o proprio sinal sub
    -- Na soma: carry inicial = 0
    -- Na subtracao: carry inicial = 1 (completa o complemento de 2)
    carry(0) <= sub;

    -- Instancia o somador completo para o bit 0 (menos significativo)
    FA0: full_adder port map (
        a    => a(0),
        b    => b_operando(0),
        cin  => carry(0),
        soma => resultado(0),
        cout => carry(1)              -- Carry vai para o proximo somador
    );

    -- Instancia o somador completo para o bit 1
    FA1: full_adder port map (
        a    => a(1),
        b    => b_operando(1),
        cin  => carry(1),
        soma => resultado(1),
        cout => carry(2)
    );

    -- Instancia o somador completo para o bit 2
    FA2: full_adder port map (
        a    => a(2),
        b    => b_operando(2),
        cin  => carry(2),
        soma => resultado(2),
        cout => carry(3)
    );

    -- Instancia o somador completo para o bit 3 (mais significativo)
    FA3: full_adder port map (
        a    => a(3),
        b    => b_operando(3),
        cin  => carry(3),
        soma => resultado(3),
        cout => carry(4)              -- Carry final = carry out da operacao
    );

    -- Carry out da operacao inteira
    cout <= carry(4);

    -- Overflow ocorre quando o carry de entrada no bit mais significativo
    -- eh diferente do carry de saida do bit mais significativo
    -- Isso indica que o resultado nao cabe em 4 bits com sinal
    overflow <= carry(4) xor carry(3);

end architecture ripple_carry;
