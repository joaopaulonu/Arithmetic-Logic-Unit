library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplier_2bit is
    Port ( A, B : in STD_LOGIC_VECTOR (1 downto 0);
           P    : out STD_LOGIC_VECTOR (3 downto 0));
end multiplier_2bit;

architecture structural of multiplier_2bit is
    signal p0, p1_a, p1_b, c1 : STD_LOGIC;
begin
    P(0) <= A(0) and B(0);

    p1_a <= A(1) and B(0);
    p1_b <= A(0) and B(1);
    P(1) <= p1_a xor p1_b;

    c1   <= p1_a and p1_b;
    P(2) <= (A(1) and B(1)) xor c1;
    P(3) <= (A(1) and B(1)) and c1;
end structural;