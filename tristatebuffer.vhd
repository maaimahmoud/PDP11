LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;

-- Tristate buffer Entity

ENTITY tristate IS
        GENERIC (n : integer := 32);
    PORT(
            T : IN std_logic_vector(n-1  DOWNTO 0);
            en:IN std_logic;
            output : OUT std_logic_vector(n-1 DOWNTO 0)
        );

END tristate;

----------------------------------------------------------------------
-- Tristate buffer Architecture

ARCHITECTURE a_tristate OF tristate IS

BEGIN

    output <= T when en='1'
    else (others=>'Z');


END a_tristate;