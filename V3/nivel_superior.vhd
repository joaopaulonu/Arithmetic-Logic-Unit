library IEEE; -- Biblioteca padrão
use IEEE.STD_LOGIC_1164.ALL; -- Pacote lógico padrão
use IEEE.NUMERIC_STD.ALL;    -- Pacote para operações aritméticas

entity nivel_superior is
    Port ( 
        CLOCK_50 : in STD_LOGIC; -- Clock da placa DE10-Lite
        SW       : in STD_LOGIC_VECTOR(10 downto 0); -- Switches de entrada
        LEDR     : out STD_LOGIC_VECTOR(5 downto 0); -- LEDs indicadores de flags
        HEX0     : out STD_LOGIC_VECTOR(6 downto 0); -- Display da operação
        HEX2     : out STD_LOGIC_VECTOR(6 downto 0); -- Display da entrada B
        HEX4     : out STD_LOGIC_VECTOR(6 downto 0); -- Display da entrada A
        HEX6     : out STD_LOGIC_VECTOR(6 downto 0); -- Display do resultado
        HEX6_DP  : out STD_LOGIC           -- Ponto decimal para sinal negativo
    );
end nivel_superior;

architecture comportamento of nivel_superior is
    signal r_A, r_B   : STD_LOGIC_VECTOR(3 downto 0); -- Registradores para entradas
    signal r_Op       : STD_LOGIC_VECTOR(2 downto 0); -- Registrador para código da operação
    signal fio_Res    : STD_LOGIC_VECTOR(3 downto 0); -- Conexão do resultado da ULA
    signal w_Z, w_O, w_C, w_E, w_G, w_L : STD_LOGIC; -- Fios para flags (Z, O, C...)
    signal val_disp   : STD_LOGIC_VECTOR(3 downto 0); -- Valor tratado para o display
    signal flag_neg   : STD_LOGIC;                    -- Sinalizador de número negativo

    -- Declaração da ULA
    component ula is
        Port ( A, B : in STD_LOGIC_VECTOR(3 downto 0);
               ALU_Op : in STD_LOGIC_VECTOR(2 downto 0);
               Result : out STD_LOGIC_VECTOR(3 downto 0);
               Zero, Overflow, CarryOut, Equ, Grt, Lst : out STD_LOGIC);
    end component;

    -- Declaração do decodificador
    component decodificador_hex is
        Port ( bin_in : in STD_LOGIC_VECTOR(3 downto 0);
               hex_out : out STD_LOGIC_VECTOR(6 downto 0));
    end component;

begin
    -- Processo síncrono para leitura estável dos switches
    process(CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
            r_A  <= SW(10 downto 7); -- Mapeia switches 10 a 7 para A
            r_B  <= SW(6 downto 3);  -- Mapeia switches 6 a 3 para B
            r_Op <= SW(2 downto 0);  -- Mapeia switches 2 a 0 para Operação
            
            -- Lógica para apagar LEDs se a operação for NOP (000)
            if r_Op = "000" then
                LEDR <= (others => '0'); -- Todos os LEDs apagam no NOP
            else
                LEDR <= w_L & w_G & w_E & w_O & w_Z & w_C; -- Conecta flags aos LEDs
            end if;
        end if;
    end process;

    -- Instância da Unidade Lógica e Aritmética
    INST_ULA: ula port map (r_A, r_B, r_Op, fio_Res, w_Z, w_O, w_C, w_E, w_G, w_L);

    -- Lógica de valor absoluto para exibir números negativos (Complemento de 2)
    val_disp <= std_logic_vector(unsigned(not fio_Res) + 1) 
                when (r_Op = "100" or r_Op = "101") and fio_Res(3) = '1' 
                else fio_Res; -- Se negativo, inverte e soma 1
    
    -- Ativa sinal de negativo apenas para somas e subtrações
    flag_neg <= '1' when (r_Op = "100" or r_Op = "101") and fio_Res(3) = '1' else '0';

    -- Instâncias dos decodificadores para cada display
    D0: decodificador_hex port map (bin_in => '0' & r_Op, hex_out => HEX0); -- Mostra Op
    D2: decodificador_hex port map (bin_in => r_B,      hex_out => HEX2); -- Mostra B
    D4: decodificador_hex port map (bin_in => r_A,      hex_out => HEX4); -- Mostra A
    D6: decodificador_hex port map (bin_in => val_disp,  hex_out => HEX6); -- Mostra Resultado

    HEX6_DP <= not flag_neg; -- Ponto acende no negativo (lógica de ânodo comum)

end comportamento;