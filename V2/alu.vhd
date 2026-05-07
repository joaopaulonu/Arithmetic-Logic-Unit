library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ula_pkg.all; -- Usa as declaracoes do pacote em portugues

entity ula is
    Port ( A, B       : in STD_LOGIC_VECTOR (3 downto 0); -- Entrada A de 4 bits
           ALU_Op     : in STD_LOGIC_VECTOR (2 downto 0); -- Seletor de operacao de 3 bits
           Result     : out STD_LOGIC_VECTOR (3 downto 0); -- Resultado final da operacao
           Zero       : out STD_LOGIC; -- Indicador se o resultado e zero
           Overflow   : out STD_LOGIC; -- Indicador de erro de sinal em soma/sub
           CarryOut   : out STD_LOGIC; -- Transporte final da soma ou subtracao
           Equ, Grt, Lst : out STD_LOGIC); -- Sinais de comparacao (Igual, Maior, Menor)
end ula;

architecture estrutural of ula is
    -- Declaracao de sinais internos para conexao dos componentes
    signal b_inv   : STD_LOGIC_VECTOR(3 downto 0); -- Armazena B ou B invertido
    signal cin_int : STD_LOGIC; -- Define se o carry inicial e 0 ou 1
    signal s_soma  : STD_LOGIC_VECTOR(3 downto 0); -- Fio que traz o resultado do somador
    signal c_soma  : STD_LOGIC; -- Fio que traz o carry out do somador
    signal s_mult  : STD_LOGIC_VECTOR(3 downto 0); -- Fio que traz o resultado do multiplicador
    signal s_equ, s_grt, s_lst : STD_LOGIC; -- Fios que trazem os resultados do comparador
    signal s_ovf   : STD_LOGIC; -- Fio interno para o calculo de overflow
begin
    -- Logica para subtracao: se Op=101, inverte B e coloca 1 no CarryIn (Complemento de 2)
    b_inv   <= not B when ALU_Op = "101" else B; -- Inversao condicional de B
    cin_int <= '1' when ALU_Op = "101" else '0'; -- Cin em 1 apenas na subtracao

    -- Instancia o somador de 4 bits
    SOM: somador_4bits port map (A, b_inv, cin_int, s_soma, c_soma); -- Conecta entradas e fios de soma

    -- Instancia o multiplicador de 2 bits (usa apenas os 2 bits menos significativos)
    MUL: multiplicador_2bits port map (A(1 downto 0), B(1 downto 0), s_mult); -- Conecta para multiplicacao

    -- Instancia o comparador de 4 bits
    CMP: comparador_4bits port map (A, B, s_equ, s_grt, s_lst); -- Conecta para comparacao de magnitude

    -- Logica de Overflow: sinais iguais nos operandos gerando sinal diferente no resultado
    s_ovf <= (A(3) xnor b_inv(3)) and (A(3) xor s_soma(3)); -- Calculo booleano de overflow

    -- Multiplexador de saida: escolhe o que vai para o Result baseado no Opcode
    Result <= "0000"    when ALU_Op = "000" else -- NOP: Resultado zerado
              (A and B) when ALU_Op = "001" else -- Operacao logica AND bit a bit
              (A or B)  when ALU_Op = "010" else -- Operacao logica OR bit a bit
              (not B)   when ALU_Op = "011" else -- Operacao logica NOT no operando B
              s_soma    when ALU_Op = "100" else -- Resultado da soma
              s_soma    when ALU_Op = "101" else -- Resultado da subtracao
              s_mult    when ALU_Op = "110" else -- Resultado da multiplicacao
              "0000";                            -- Operacao de comparacao (saida vai para os LEDs)

    -- Controle das flags de saida: devem ser 0 se a operacao for NOP (000)
    CarryOut <= c_soma when (ALU_Op = "100" or ALU_Op = "101") else '0'; -- Carry so em soma/sub
    Overflow <= s_ovf  when (ALU_Op = "100" or ALU_Op = "101") else '0'; -- Overflow so em soma/sub
    Zero     <= '1'    when (s_soma = "0000" and ALU_Op /= "000") else '0'; -- Zero se resultado nulo e nao for NOP
    
    -- Saidas de comparacao: ativas apenas quando a operacao for 111
    Equ <= s_equ when ALU_Op = "111" else '0'; -- LED de igualdade
    Grt <= s_grt when ALU_Op = "111" else '0'; -- LED de maior que
    Lst <= s_lst when ALU_Op = "111" else '0'; -- LED de menor que
end estrutural;