library IEEE; -- Biblioteca padrão
use IEEE.STD_LOGIC_1164.ALL; -- Pacote lógico padrão

entity decodificador_hex is
    Port ( bin_in  : in  STD_LOGIC_VECTOR (3 downto 0); -- Entrada binária
           hex_out : out STD_LOGIC_VECTOR (6 downto 0) ); -- Saída para display
end decodificador_hex;

architecture estrutural of decodificador_hex is
begin
    -- Atribuição direta por seleção (substitui o process/case)
    with bin_in select
        hex_out <= "1000000" when "0000", -- Representa o número 0
                   "1111001" when "0001", -- Representa o número 1
                   "0100100" when "0010", -- Representa o número 2
                   "0110000" when "0011", -- Representa o número 3
                   "0011001" when "0100", -- Representa o número 4
                   "0010010" when "0101", -- Representa o número 5
                   "0000010" when "0110", -- Representa o número 6
                   "1111000" when "0111", -- Representa o número 7
                   "0000000" when "1000", -- Representa o número 8
                   "0010000" when "1001", -- Representa o número 9
                   "0001000" when "1010", -- Representa a letra A
                   "0000011" when "1011", -- Representa a letra b
                   "1000110" when "1100", -- Representa a letra C
                   "0100001" when "1101", -- Representa a letra d
                   "0000110" when "1110", -- Representa a letra E
                   "0001110" when "1111", -- Representa a letra F
                   "1111111" when others; -- Apaga tudo em caso de erro
end estrutural;