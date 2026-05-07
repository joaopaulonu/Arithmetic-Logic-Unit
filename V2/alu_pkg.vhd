library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package ula_pkg is

    -- Componente do somador de 1 bit 
	 
    component somador_completo is
        Port ( A, B, Cin : in STD_LOGIC; -- Entradas de 1 bit
               S, Cout   : out STD_LOGIC); -- Saídas de soma e carry
    end component;

    -- Componente do somador de 4 bits 
	 
    component somador_4bits is
        Port ( A, B : in STD_LOGIC_VECTOR (3 downto 0); -- Vetores de entrada
               Cin  : in STD_LOGIC; -- Carry de entrada
               S    : out STD_LOGIC_VECTOR (3 downto 0); -- Vetor de soma
               Cout : out STD_LOGIC); -- Carry de saída
    end component;

    -- Componente do multiplicador de 2 bits 
	 
    component multiplicador_2bits is
        Port ( A, B : in STD_LOGIC_VECTOR (1 downto 0); -- Entradas de 2 bits
               P    : out STD_LOGIC_VECTOR (3 downto 0)); -- Produto de 4 bits
    end component;

    -- Componente do comparador de 4 bits 
	 
    component comparador_4bits is
        Port ( A, B : in STD_LOGIC_VECTOR (3 downto 0); -- Entradas para comparar
               Equ, Grt, Lst : out STD_LOGIC); -- Saídas de igual, maior, menor
    end component;
end ula_pkg;