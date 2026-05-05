library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex_decoder is
    Port ( bin_in  : in  STD_LOGIC_VECTOR (3 downto 0);
           hex_out : out STD_LOGIC_VECTOR (6 downto 0) );
end hex_decoder;

architecture behavioral of hex_decoder is
begin
    -- 7 segmentos: gfedcba (hex_out(6)=g, ..., hex_out(0)=a)
    -- Display ânodo comum: '0' acende, '1' apaga
    process(bin_in)
    begin
        case bin_in is
            when "0000" => hex_out <= "1000000"; -- 0
            when "0001" => hex_out <= "1111001"; -- 1
            when "0010" => hex_out <= "0100100"; -- 2
            when "0011" => hex_out <= "0110000"; -- 3
            when "0100" => hex_out <= "0011001"; -- 4
            when "0101" => hex_out <= "0010010"; -- 5
            when "0110" => hex_out <= "0000010"; -- 6
            when "0111" => hex_out <= "1111000"; -- 7
            when "1000" => hex_out <= "0000000"; -- 8
            when "1001" => hex_out <= "0010000"; -- 9
            when "1010" => hex_out <= "0001000"; -- A
            when "1011" => hex_out <= "0000011"; -- b
            when "1100" => hex_out <= "1000110"; -- C
            when "1101" => hex_out <= "0100001"; -- d
            when "1110" => hex_out <= "0000110"; -- E
            when "1111" => hex_out <= "0001110"; -- F
            when others => hex_out <= "1111111"; -- tudo apagado
        end case;
    end process;
end behavioral;