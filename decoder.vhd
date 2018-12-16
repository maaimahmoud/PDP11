LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;
USE IEEE.numeric_std.all;

-- Decoder Entity

ENTITY decoder IS
        GENERIC (n : integer := 3); --N : Number of selection Lines
    PORT(
            T : IN std_logic_vector(n-1  DOWNTO 0); 
            en:IN std_logic;
            decoded : OUT std_logic_vector((2**n)-1 DOWNTO 0)
        );

END decoder;

----------------------------------------------------------------------
-- Decoder Architecture

ARCHITECTURE aDecoder OF decoder IS

    BEGIN
     

        loop1: FOR i IN 0 TO (2**n -1)
            GENERATE
                
                decoded(i) <= '1' when i = to_integer(unsigned(T)) and en = '1'
                else '0';

            END GENERATE;


    END aDecoder;