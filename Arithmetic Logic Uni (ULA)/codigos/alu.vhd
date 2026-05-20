library ieee;
use ieee.std_logic_1164.all; -- Tipos logicos padrao

library work;
use work.alu_pkg.all;

entity ula is
    port (
        -- Entradas de dados (switches da placa)
        SW   : in  std_logic_vector(10 downto 0);  -- SW10..SW7=A, SW6..SW3=B, SW2..SW0=Opcode

        -- Displays de 7 segmentos (saidas hexadecimais ativos em nivel baixo)
        HEX0 : out std_logic_vector(6 downto 0);   -- Mostra o opcode (AluOp)
        HEX2 : out std_logic_vector(6 downto 0);   -- Mostra o operando B
        HEX4 : out std_logic_vector(6 downto 0);   -- Mostra o operando A
        HEX6 : out std_logic_vector(6 downto 0);   -- Mostra o digito do resultado
        HEX7 : out std_logic_vector(6 downto 0);   -- Mostra o sinal negativo (-) do resultado

        -- LEDs de ajuda/saida (resultados e flags ativos em nivel alto)
        LEDR : out std_logic_vector(5 downto 0)    -- LEDR0=cout, LEDR1=zero, LEDR2=ovf, LEDR3=equ, LEDR4=grt, LEDR5=lst
    );
end entity ula;

architecture comportamental of ula is

    -- Sinais internos extraidos dos switches
    signal a      : std_logic_vector(3 downto 0);
    signal b      : std_logic_vector(3 downto 0);
    signal opcode : std_logic_vector(2 downto 0);

    -- Saidas intermediarias dos modulos estruturais
    signal add_result : std_logic_vector(3 downto 0);
    signal add_cout   : std_logic;
    signal add_ovf    : std_logic;

    signal sub_result : std_logic_vector(3 downto 0);
    signal sub_cout   : std_logic;
    signal sub_ovf    : std_logic;

    signal mul_result : std_logic_vector(3 downto 0);

    signal comp_equ   : std_logic;
    signal comp_grt   : std_logic;
    signal comp_lst   : std_logic;

    -- Sinais de barramento internos para o processo multiplexador
    signal resultado  : std_logic_vector(3 downto 0);
    signal zero_flag  : std_logic;
    signal ovf_flag   : std_logic;
    signal cout_flag  : std_logic;
    signal equ_flag   : std_logic;
    signal grt_flag   : std_logic;
    signal lst_flag   : std_logic;

    -- Funcao para conversao de 4 bits para display de 7 segmentos (Anodo Comum - '0' acende)
    function para_7seg(valor : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable seg : std_logic_vector(6 downto 0);
    begin
        case valor is
            when "0000" => seg := "1000000"; -- 0
            when "0001" => seg := "1111001"; -- 1
            when "0010" => seg := "0100100"; -- 2
            when "0011" => seg := "0110000"; -- 3
            when "0100" => seg := "0011001"; -- 4
            when "0101" => seg := "0010010"; -- 5
            when "0110" => seg := "0000010"; -- 6
            when "0111" => seg := "1111000"; -- 7
            when "1000" => seg := "0000000"; -- 8
            when "1001" => seg := "0010000"; -- 9
            when "1010" => seg := "0001000"; -- A
            when "1011" => seg := "0000011"; -- B
            when "1100" => seg := "1000110"; -- C
            when "1101" => seg := "0100001"; -- D
            when "1110" => seg := "0000110"; -- E
            when "1111" => seg := "0001110"; -- F 
            when others => seg := "1111111"; -- Apagado
        end case;
        return seg;
    end function para_7seg;

begin

    -- Ajustado de colchetes [] para os parenteses corretos () do VHDL
    a      <= SW(10 downto 7);
    b      <= SW(6 downto 3);
    opcode <= SW(2 downto 0);

    -- Instancia do Somador de 4 bits (sub=0)
    INST_ADD: adder4 port map (
        a         => a,
        b         => b,
        sub       => '0',
        resultado => add_result,
        cout      => add_cout,
        overflow  => add_ovf
    );

    -- Instancia do Subtrator de 4 bits (sub=1)
    INST_SUB: adder4 port map (
        a         => a,
        b         => b,
        sub       => '1',
        resultado => sub_result,
        cout      => sub_cout,
        overflow  => sub_ovf
    );

    -- Instancia do Multiplicador de 2 bits
    INST_MUL: multiplier2x2 port map (
        a         => a(1 downto 0),
        b         => b(1 downto 0),
        resultado => mul_result
    );

    -- Instancia do Comparador de 4 bits
    INST_COMP: comparator4 port map (
        a   => a,
        b   => b,
        equ => comp_equ,
        grt => comp_grt,
        lst => comp_lst
    );

    -- Multiplexador de Operacoes e Geracao Dinamica de Flags
    process(opcode, a, b, add_result, sub_result, mul_result,
            add_cout, add_ovf, sub_cout, sub_ovf,
            comp_equ, comp_grt, comp_lst)
        variable temp_and : std_logic_vector(3 downto 0);
        variable temp_or  : std_logic_vector(3 downto 0);
        variable temp_not : std_logic_vector(3 downto 0);
    begin
        -- Estado padrao para evitar latches inferidos
        resultado <= "0000";
        cout_flag  <= '0';
        ovf_flag   <= '0';
        equ_flag   <= '0';
        grt_flag   <= '0';
        lst_flag   <= '0';
        zero_flag  <= '0';         
        HEX7       <= "1111111";   -- Apagado por padrao

        case opcode is

            -- 000: nop
            when "000" =>
                resultado <= "0000";
                zero_flag <= '0';    

            -- 001: and
            when "001" =>
                temp_and  := a and b;
                resultado <= temp_and;
                if temp_and = "0000" then
                    zero_flag <= '1';
                end if;

            -- 010: or
            when "010" =>
                temp_or   := a or b;
                resultado <= temp_or;
                if temp_or = "0000" then
                    zero_flag <= '1';
                end if;

            -- 011: not
            when "011" =>
                temp_not  := not b;
                resultado <= temp_not;
                if temp_not = "0000" then
                    zero_flag <= '1';
                end if;

            -- 100: add
            when "100" =>
                resultado <= add_result;
                cout_flag <= add_cout;
                ovf_flag  <= add_ovf;
                if add_result = "0000" then
                    zero_flag <= '1';
                end if;

            -- 101: sub
            when "101" =>
                resultado <= sub_result;
                cout_flag <= sub_cout;
                ovf_flag  <= sub_ovf;
                if sub_result = "0000" then
                    zero_flag <= '1';
                end if;
                
                -- Se o bit mais significativo (MSB) for 1, o numero e negativo
                if sub_result(3) = '1' then
                    HEX7 <= "0111111"; -- Acende o segmento G (sinal de menos)
                end if;

            -- 110: mul
            when "110" =>
                resultado <= mul_result;
                if mul_result = "0000" then
                    zero_flag <= '1';
                end if;

            -- 111: comp
            when "111" =>
                resultado <= "0000";
                equ_flag  <= comp_equ;
                grt_flag  <= comp_grt;
                lst_flag  <= comp_lst;
                zero_flag <= '0';    

            when others =>
                resultado <= "0000";

        end case;
    end process;

    -- Conexao das vias dos sinais nas saidas dos LEDs
    LEDR(0) <= cout_flag;
    LEDR(1) <= zero_flag;
    LEDR(2) <= ovf_flag;
    LEDR(3) <= equ_flag;
    LEDR(4) <= grt_flag;
    LEDR(5) <= lst_flag;

    -- Mapeamento dos blocos de displays
    HEX0 <= para_7seg("0" & opcode);
    HEX2 <= para_7seg(b);
    HEX4 <= para_7seg(a);
    HEX6 <= para_7seg(resultado);

end architecture comportamental;
