library IEEE; -- Biblioteca padrão
use IEEE.STD_LOGIC_1164.ALL; -- Pacote lógico padrão
use work.ula_pkg.all; -- Usa componentes do pacote em português

entity somador_4bits is
    Port ( A, B : in STD_LOGIC_VECTOR (3 downto 0); -- Entradas de 4 bits
           Cin  : in STD_LOGIC; -- Carry de entrada da ULA
           S    : out STD_LOGIC_VECTOR (3 downto 0); -- Resultado da soma
           Cout : out STD_LOGIC); -- Carry de saída final
end somador_4bits;

architecture estrutural of somador_4bits is
    signal c1, c2, c3 : STD_LOGIC; -- Sinais internos para transporte de carry
begin
    -- Instância bit 0: soma os bits menos significativos
    FA0: somador_completo port map (A(0), B(0), Cin, S(0), c1);
	 
    -- Instância bit 1: recebe carry do bit 0
    FA1: somador_completo port map (A(1), B(1), c1,  S(1), c2);
	 
    -- Instância bit 2: recebe carry do bit 1
    FA2: somador_completo port map (A(2), B(2), c2,  S(2), c3);
	 
    -- Instância bit 3: gera o carry out final do somador
    FA3: somador_completo port map (A(3), B(3), c3,  S(3), Cout);
end estrutural;