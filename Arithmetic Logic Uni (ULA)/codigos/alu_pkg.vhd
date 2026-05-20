library ieee;
use ieee.std_logic_1164.all;

package alu_pkg is

    -- --------------------------------------------------------
    -- Declaracao do Somador Completo de 1 bit
    -- --------------------------------------------------------
    component full_adder is
        port (
            a    : in  std_logic;
            b    : in  std_logic;
            cin  : in  std_logic;
            soma : out std_logic;
            cout : out std_logic
        );
    end component full_adder;

    -- --------------------------------------------------------
    -- Declaracao do Somador/Subtrator Ripple Carry de 4 bits
    -- --------------------------------------------------------
    component adder4 is
        port (
            a        : in  std_logic_vector(3 downto 0);
            b        : in  std_logic_vector(3 downto 0);
            sub      : in  std_logic;
            resultado: out std_logic_vector(3 downto 0);
            cout     : out std_logic;
            overflow : out std_logic
        );
    end component adder4;

    -- --------------------------------------------------------
    -- Declaracao do Multiplicador 2x2 bits
    -- --------------------------------------------------------
    component multiplier2x2 is
        port (
            a        : in  std_logic_vector(1 downto 0);
            b        : in  std_logic_vector(1 downto 0);
            resultado: out std_logic_vector(3 downto 0)
        );
    end component multiplier2x2;

    -- --------------------------------------------------------
    -- Declaracao do Comparador de 4 bits
    -- --------------------------------------------------------
    component comparator4 is
        port (
            a   : in  std_logic_vector(3 downto 0);
            b   : in  std_logic_vector(3 downto 0);
            equ : out std_logic;
            grt : out std_logic;
            lst : out std_logic
        );
    end component comparator4;

end package alu_pkg;