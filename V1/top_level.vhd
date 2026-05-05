library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;        -- necessário para unsigned +

entity top_level is
    Port ( 
        CLOCK_50 : in STD_LOGIC;
        SW       : in STD_LOGIC_VECTOR(10 downto 0);
        LEDR     : out STD_LOGIC_VECTOR(5 downto 0);
        HEX0     : out STD_LOGIC_VECTOR(6 downto 0);
        HEX2     : out STD_LOGIC_VECTOR(6 downto 0);
        HEX4     : out STD_LOGIC_VECTOR(6 downto 0);
        HEX6     : out STD_LOGIC_VECTOR(6 downto 0);
        HEX6_DP  : out STD_LOGIC          -- ponto decimal para sinal negativo
    );
end top_level;

architecture behavior of top_level is
    signal reg_A, reg_B   : STD_LOGIC_VECTOR(3 downto 0);
    signal reg_Op         : STD_LOGIC_VECTOR(2 downto 0);
    signal w_Result       : STD_LOGIC_VECTOR(3 downto 0);
    signal w_Zero, w_Ovf, w_Cout, w_Equ, w_Grt, w_Lst : STD_LOGIC;
    
    -- Sinais para exibição do resultado com sinal
    signal disp_val       : STD_LOGIC_VECTOR(3 downto 0);  -- valor a ser mostrado
    signal neg_flag       : STD_LOGIC;                     -- 1 = número negativo

    component alu is
        Port ( A, B : in STD_LOGIC_VECTOR(3 downto 0);
               ALU_Op : in STD_LOGIC_VECTOR(2 downto 0);
               Result : out STD_LOGIC_VECTOR(3 downto 0);
               Zero, Overflow, CarryOut, Equ, Grt, Lst : out STD_LOGIC);
    end component;

    component hex_decoder is
        Port ( bin_in : in STD_LOGIC_VECTOR(3 downto 0);
               hex_out : out STD_LOGIC_VECTOR(6 downto 0));
    end component;

begin
    -- Sincronização dos switches
    process(CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
            reg_A  <= SW(10 downto 7);
            reg_B  <= SW(6 downto 3);
            reg_Op <= SW(2 downto 0);

            LEDR(0) <= w_Cout;
            LEDR(1) <= w_Zero;
            LEDR(2) <= w_Ovf;
            LEDR(3) <= w_Equ;
            LEDR(4) <= w_Grt;
            LEDR(5) <= w_Lst;
        end if;
    end process;

    U_ALU: alu port map (
        A => reg_A, B => reg_B, ALU_Op => reg_Op,
        Result => w_Result,
        Zero => w_Zero, Overflow => w_Ovf, CarryOut => w_Cout,
        Equ => w_Equ, Grt => w_Grt, Lst => w_Lst
    );

   
    process(w_Result, reg_Op)
    begin
        if (reg_Op = "100" or reg_Op = "101") and w_Result(3) = '1' then
            disp_val  <= std_logic_vector(unsigned(not w_Result) + 1);
            neg_flag <= '1';
        else
            disp_val  <= w_Result;
            neg_flag <= '0';
        end if;
    end process;

    -- Displays de 7 segmentos
    D_HEX0: hex_decoder port map (bin_in => '0' & reg_Op, hex_out => HEX0);
    D_HEX2: hex_decoder port map (bin_in => reg_B,     hex_out => HEX2);
    D_HEX4: hex_decoder port map (bin_in => reg_A,     hex_out => HEX4);
    D_HEX6: hex_decoder port map (bin_in => disp_val,  hex_out => HEX6);

    HEX6_DP <= neg_flag;   -- acende ponto decimal se negativo

end behavior;