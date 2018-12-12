LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- n-bit And Entity

ENTITY and2 IS
		GENERIC (wordSize : integer := 16);
	PORT(
			a,b : IN std_logic_vector(wordSize-1 downto 0);
			z : OUT std_logic_vector(wordSize-1 downto 0)
		);

END and2;

------------------------------------------------------------

-- n-bit And Architecture

ARCHITECTURE aAnd2 OF and2 IS

	SIGNAL outBit: std_logic;

	BEGIN
		
		z <= a and b;

		    
		-- loop1: FOR i IN 0 TO (wordSize-1)
		-- 	GENERATE
				
		-- 		outbit <= a(i) and b(i);
		-- 		z(i) <= oubit when outbit='1'
		-- 		else (others=>'Z');
				
		-- 	END GENERATE;    

END aAnd2;