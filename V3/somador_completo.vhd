-- ============================================================
-- Arquivo: full_adder.vhd
-- Descricao: Somador completo de 1 bit (Full Adder)
-- Usado como bloco basico do somador de 4 bits
-- ============================================================

library ieee;                          -- Importa a biblioteca padrao IEEE
use ieee.std_logic_1164.all;           -- Permite usar std_logic e std_logic_vector

-- Entidade: define os pinos de entrada e saida do componente
entity full_adder is
    port (
        a    : in  std_logic;          -- Primeiro bit de entrada
        b    : in  std_logic;          -- Segundo bit de entrada
        cin  : in  std_logic;          -- Carry de entrada (vem do bit anterior)
        soma : out std_logic;          -- Resultado da soma (bit de saida)
        cout : out std_logic           -- Carry de saida (vai para o proximo bit)
    );
end entity full_adder;

-- Arquitetura: descreve o comportamento em nivel de portas logicas
architecture porta_logica of full_adder is
begin

    -- Soma = XOR dos tres bits (a XOR b XOR cin)
    -- Lembre: 1+1 = 10, entao o bit de soma eh o XOR
    soma <= a xor b xor cin;

    -- Carry de saida = 1 quando pelo menos dois bits de entrada sao 1
    -- Formula: cout = (a AND b) OR (a AND cin) OR (b AND cin)
    cout <= (a and b) or (a and cin) or (b and cin);

end architecture porta_logica;