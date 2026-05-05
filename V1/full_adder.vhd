library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port ( A, B, Cin : in STD_LOGIC;
           S, Cout   : out STD_LOGIC);
end full_adder;

architecture structural of full_adder is
begin
    S    <= A xor B xor Cin;
    Cout <= (A and B) or (Cin and (A xor B));
end structural;