library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nivel_superior_tb is
end nivel_superior_tb;

architecture sim of nivel_superior_tb is
    -- Sinais para simular a placa
    signal clk_50 : STD_LOGIC := '0';
    signal sw     : STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
    signal ledr   : STD_LOGIC_VECTOR(5 downto 0);
    signal h0, h2, h4, h6 : STD_LOGIC_VECTOR(6 downto 0);
    signal dp     : STD_LOGIC;

begin
    -- Gera clock de 50MHz (período de 20ns)
    clk_50 <= not clk_50 after 10 ns;

    -- Instancia o Nível Superior
    UUT: entity work.nivel_superior port map (
        CLOCK_50 => clk_50, SW => sw, LEDR => ledr,
        HEX0 => h0, HEX2 => h2, HEX4 => h4, HEX6 => h6, HEX6_DP => dp
    );

    process
    begin
        -- Simula Switches: A=2 (SW10-7="0010"), B=1 (SW6-3="0001"), Op=ADD (SW2-0="100")
        sw <= "0010" & "0001" & "100"; 
        wait for 100 ns;
        
        -- Simula Switches: Comparação (Op="111") entre A=4 e B=4
        sw <= "0100" & "0100" & "111";
        wait for 100 ns;

        wait;
    end process;
end sim;