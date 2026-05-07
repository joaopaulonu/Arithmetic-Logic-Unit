library IEEE; -- Biblioteca padrão
use IEEE.STD_LOGIC_1164.ALL; -- Pacote lógico padrão

entity somador_completo is
    Port ( A, B, Cin : in STD_LOGIC; -- Entradas de um bit e carry inicial
           S, Cout   : out STD_LOGIC); -- Saídas de soma e carry final
end somador_completo;

architecture estrutural of somador_completo is
begin
    S    <= A xor B xor Cin; -- Calcula soma usando porta lógica XOR
    Cout <= (A and B) or (Cin and (A xor B)); -- Calcula o carry out usando AND e OR
end estrutural;