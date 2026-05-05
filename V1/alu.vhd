library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.alu_pkg.all;

entity alu is
    Port ( A, B       : in STD_LOGIC_VECTOR (3 downto 0);
           ALU_Op     : in STD_LOGIC_VECTOR (2 downto 0);
           Result     : out STD_LOGIC_VECTOR (3 downto 0);
           Zero       : out STD_LOGIC;
           Overflow   : out STD_LOGIC;
           CarryOut   : out STD_LOGIC;
           Equ, Grt, Lst : out STD_LOGIC);
end alu;

architecture structural of alu is
    signal add_sub_b   : STD_LOGIC_VECTOR(3 downto 0);
    signal add_sub_cin : STD_LOGIC;
    signal sum_res     : STD_LOGIC_VECTOR(3 downto 0);
    signal sum_cout    : STD_LOGIC;
    signal mul_res     : STD_LOGIC_VECTOR(3 downto 0);
    signal comp_equ, comp_grt, comp_lst : STD_LOGIC;

    signal temp_result : STD_LOGIC_VECTOR(3 downto 0);
    signal temp_cout   : STD_LOGIC;
    signal temp_ovf    : STD_LOGIC;
begin
    ---------- COMPONENTES OBRIGATÓRIOS ----------
    -- Subtração: complemento de 2 (inverte B e soma 1)
    add_sub_b   <= not B when ALU_Op = "101" else B;
    add_sub_cin <= '1' when ALU_Op = "101" else '0';

    U_ADDER: adder_4bit port map (
        A => A, B => add_sub_b, Cin => add_sub_cin,
        S => sum_res, Cout => sum_cout
    );

    U_MUL: multiplier_2bit port map (
        A => A(1 downto 0), B => B(1 downto 0), P => mul_res
    );

    U_COMP: comparator_4bit port map (
        A => A, B => B,
        Equ => comp_equ, Grt => comp_grt, Lst => comp_lst
    );

    ---------- MULTIPLEXADOR DE SAÍDA ----------
    process(A, B, ALU_Op, sum_res, sum_cout, mul_res, comp_equ, comp_grt, comp_lst)
    begin
        temp_result <= (others => '0');
        temp_cout   <= '0';
        temp_ovf    <= '0';
        Equ <= '0'; Grt <= '0'; Lst <= '0';

        case ALU_Op is
            when "000" =>    -- NOP
                temp_result <= "0000";
            when "001" =>    -- AND
                temp_result <= A and B;
            when "010" =>    -- OR
                temp_result <= A or B;
            when "011" =>    -- NOT
                temp_result <= not B;
            when "100" | "101" =>  -- ADD / SUB (com sinal)
                temp_result <= sum_res;
                temp_cout   <= sum_cout;
                -- Overflow com sinal: sinais iguais nos operandos e resultado diferente
                temp_ovf <= (A(3) xnor add_sub_b(3)) and (A(3) xor sum_res(3));
            when "110" =>    -- MUL
                temp_result <= mul_res;
            when "111" =>    -- COMPARAÇÃO
                Equ <= comp_equ;
                Grt <= comp_grt;
                Lst <= comp_lst;
            when others =>
                temp_result <= "0000";
        end case;
    end process;

    ---------- SAÍDAS ----------
    Result   <= temp_result;
    CarryOut <= temp_cout;
    Overflow <= temp_ovf;
    Zero     <= '1' when temp_result = "0000" else '0';
end structural;