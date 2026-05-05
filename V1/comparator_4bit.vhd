library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_4bit is
    Port ( A, B : in STD_LOGIC_VECTOR (3 downto 0);
           Equ, Grt, Lst : out STD_LOGIC);
end comparator_4bit;

architecture structural of comparator_4bit is
    signal x      : STD_LOGIC_VECTOR(3 downto 0);  -- bit de igualdade por posição
    signal equ_i  : STD_LOGIC;
    signal grt_i  : STD_LOGIC;                    -- sinal intermediário para Grt
begin
    -- Igualdade bit a bit
    x(0) <= A(0) xnor B(0);
    x(1) <= A(1) xnor B(1);
    x(2) <= A(2) xnor B(2);
    x(3) <= A(3) xnor B(3);
    equ_i <= x(0) and x(1) and x(2) and x(3);
    Equ   <= equ_i;

    -- A > B (prioridade do MSB para o LSB)
    grt_i <= (A(3) and not B(3))
          or (x(3) and A(2) and not B(2))
          or (x(3) and x(2) and A(1) and not B(1))
          or (x(3) and x(2) and x(1) and A(0) and not B(0));
    Grt <= grt_i;

    -- A < B : não igual e não maior
    Lst <= not equ_i and not grt_i;
end structural;