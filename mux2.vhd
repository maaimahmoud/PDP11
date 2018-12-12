LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;


ENTITY mux2 IS
        GENERIC (n : integer := 32);
    PORT(
            T1 : IN std_logic_vector(n-1  DOWNTO 0);
            T2 : IN std_logic_vector(n-1  DOWNTO 0);
            s : IN std_logic;
            output : OUT std_logic_vector(n-1 DOWNTO 0)
        );

END mux2;

----------------------------------------------------------------------

ARCHITECTURE aMux2 OF mux2 IS

BEGIN

    output <= T1 when s='0'
    else T2;

END aMux2;