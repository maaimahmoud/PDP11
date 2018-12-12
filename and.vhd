LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
LIBRARY work;
USE work.mine;

-- And Entity

ENTITY andGate IS
    
            GENERIC (inputNum : integer := 3 ; wordSize : integer := 16); -- Number of inputs to MUX and word Size of each
                    
        PORT(
                inputs : IN  mine.genericArrayofVector16bit(0 to inputNum-1);

                output : OUT std_logic_vector(wordSize-1 DOWNTO 0)
            );


END ENTITY andGate;

------------------------------------------------------------

-- And Architecture


ARCHITECTURE aAnd OF andGate IS


    COMPONENT and2 IS  
             GENERIC (wordSize : integer := 16);     
        PORT(
            a,b : IN std_logic_vector(wordSize-1 downto 0);
            z : OUT std_logic_vector(wordSize-1 downto 0)
        );
    END COMPONENT;

    -- SIGNAL Comulative: std_logic_vector(wordSize-1 downto 0);


    BEGIN

    -- Comulative <= inputs(0);
    output <= (others=>('1'));
    
    loop1: FOR i IN 0 TO (inputNum-2)
    GENERATE
        -- Comulative <= inputs(i) and inputs(i+1);
        andMap: and2 PORT MAP (inputs(i),inputs(i+1),output);     
    
    END GENERATE;     
    
    -- output <= Comulative;

END aAnd;

