library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ula_tb is
end ula_tb;

architecture simulacao of ula_tb is
    -- Sinais para conectar na ULA
    signal s_A, s_B   : STD_LOGIC_VECTOR(3 downto 0);
    signal s_Op      : STD_LOGIC_VECTOR(2 downto 0);
    signal s_Res     : STD_LOGIC_VECTOR(3 downto 0);
    signal s_Z, s_O, s_C, s_E, s_G, s_L : STD_LOGIC;

begin
    -- Instancia a sua ULA (UUT)
    UUT: entity work.ula port map (
        A => s_A, 
        B => s_B, 
        ALU_Op => s_Op, 
        Result => s_Res, 
        Zero => s_Z, 
        Overflow => s_O, 
        CarryOut => s_C, 
        Equ => s_E, 
        Grt => s_G, 
        Lst => s_L
    );

    -- Processo de teste
    process
    begin
        -- Teste 0: NOP
        s_A <= "0000"; s_B <= "0000"; s_Op <= "000";
        wait for 20 ns;

        -- Teste 1: SOMA (5 + 3 = 8)
        s_A <= "0101"; s_B <= "0011"; s_Op <= "100";
        wait for 20 ns;

        -- Teste 2: SUBTRACAO (5 - 3 = 2)
        s_A <= "0101"; s_B <= "0011"; s_Op <= "101";
        wait for 20 ns;

        -- Teste 3: AND
        s_A <= "1010"; s_B <= "1100"; s_Op <= "001";
        wait for 20 ns;

        -- Teste 4: COMPARACAO (7 > 4)
        s_A <= "0111"; s_B <= "0100"; s_Op <= "111";
        wait for 20 ns;

        wait;
    end process;
end simulacao;
