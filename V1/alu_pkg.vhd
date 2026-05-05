library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package alu_pkg is
    component full_adder is
        Port ( A, B, Cin : in STD_LOGIC;
               S, Cout   : out STD_LOGIC);
    end component;

    component adder_4bit is
        Port ( A, B : in STD_LOGIC_VECTOR (3 downto 0);
               Cin  : in STD_LOGIC;
               S    : out STD_LOGIC_VECTOR (3 downto 0);
               Cout : out STD_LOGIC);
    end component;

    component multiplier_2bit is
        Port ( A, B : in STD_LOGIC_VECTOR (1 downto 0);
               P    : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    component comparator_4bit is
        Port ( A, B : in STD_LOGIC_VECTOR (3 downto 0);
               Equ, Grt, Lst : out STD_LOGIC);
    end component;
end alu_pkg;