library IEEE; -- Biblioteca padrao da IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Pacote para logica multinivel

entity comparador_4bits is
    Port ( A, B : in STD_LOGIC_VECTOR (3 downto 0); -- Entradas de 4 bits para comparar
           Equ, Grt, Lst : out STD_LOGIC); -- Saidas de Igual, Maior e Menor
end comparador_4bits;

architecture estrutural of comparador_4bits is
    signal x      : STD_LOGIC_VECTOR(3 downto 0); -- Fios internos para igualdade de cada bit
    signal equ_i  : STD_LOGIC; -- Fio interno para o resultado de igualdade
    signal grt_i  : STD_LOGIC; -- Fio interno para o resultado de maior que
begin
    -- Logica de igualdade bit a bit usando porta XNOR
    x(0) <= A(0) xnor B(0); -- Verifica se o bit 0 de A e B sao iguais
    x(1) <= A(1) xnor B(1); -- Verifica se o bit 1 de A e B sao iguais
    x(2) <= A(2) xnor B(2); -- Verifica se o bit 2 de A e B sao iguais
    x(3) <= A(3) xnor B(3); -- Verifica se o bit 3 de A e B sao iguais
    
    -- Resultado EQU: verdadeiro se todos os bits forem iguais
    equ_i <= x(0) and x(1) and x(2) and x(3); -- Porta AND de 4 entradas para igualdade final
    Equ   <= equ_i; -- Atribui o resultado interno a porta de saida

    -- Logica GRT (A > B): verifica do bit mais significativo para o menos significativo
    grt_i <= (A(3) and not B(3)) -- Verifica se bit 3 de A e maior que bit 3 de B
          or (x(3) and A(2) and not B(2)) -- Se bit 3 for igual, verifica se bit 2 de A e maior
          or (x(3) and x(2) and A(1) and not B(1)) -- Se bits 3 e 2 forem iguais, verifica bit 1
          or (x(3) and x(2) and x(1) and A(0) and not B(0)); -- Se bits 3, 2 e 1 forem iguais, verifica bit 0
    Grt <= grt_i; -- Atribui o resultado de maior para a saida

    -- Logica LST (A < B): se nao e igual e nao e maior, entao e menor
    Lst <= not equ_i and not grt_i; -- Porta logica para definir se A e menor que B
end estrutural;