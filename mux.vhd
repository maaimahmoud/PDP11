LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
LIBRARY work;
USE work.mine;

-- MUX Entity

ENTITY MUX IS
    
            GENERIC (inputNum : natural := 2 ; wordSize : natural := 16); -- Number of inputs to MUX and word Size of each
            
        PORT(
                inputs : IN  mine.genericArrayofVector16bit(0 to inputNum-1);
                selectionLines : IN std_logic_vector (inputNum-1 downto 0);
                output : OUT std_logic_vector(wordSize-1 DOWNTO 0)
            );

END ENTITY MUX;

------------------------------------------------------------

-- MUX Architecture

ARCHITECTURE aMUX OF MUX IS


    BEGIN
    
        output <=  inputs(to_integer(unsigned(selectionLines)));

END aMUX;
