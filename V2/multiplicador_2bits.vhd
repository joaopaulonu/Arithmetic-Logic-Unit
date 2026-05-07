library IEEE; -- Biblioteca padrão
use IEEE.STD_LOGIC_1164.ALL; -- Pacote lógico padrão

entity multiplicador_2bits is
    Port ( A, B : in STD_LOGIC_VECTOR (1 downto 0); -- Entradas de 2 bits cada
           P    : out STD_LOGIC_VECTOR (3 downto 0)); -- Produto de 4 bits
end multiplicador_2bits;

architecture estrutural of multiplicador_2bits is
    signal p1a, p1b, c1 : STD_LOGIC; -- Sinais para somas parciais
begin
    P(0) <= A(0) and B(0); -- Bit 0 é o AND direto dos LSBs
    p1a  <= A(1) and B(0); -- Parcial do bit 1 (termo A)
    p1b  <= A(0) and B(1); -- Parcial do bit 1 (termo B)
    P(1) <= p1a xor p1b;   -- Bit 1 é o XOR das parciais
    c1   <= p1a and p1b;   -- Carry gerado na soma do bit 1
    P(2) <= (A(1) and B(1)) xor c1; -- Bit 2 considera o carry anterior
    P(3) <= (A(1) and B(1)) and c1; -- Bit 3 é o carry final do produto
end estrutural;