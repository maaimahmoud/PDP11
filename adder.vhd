LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- Single bit Adder Entity
ENTITY adder IS  
     PORT( 
               a,b,cin : IN std_logic;
               s,cout : OUT std_logic
          );
END adder;

------------------------------------------------------------

-- Single bit Adder Architecture

ARCHITECTURE aAdder OF adder IS

BEGIN

     PROCESS (a,b,cin)
          BEGIN 

          s <= a XOR b XOR cin;
          cout <= (a AND b) or (cin AND (a XOR b));

     END PROCESS;

END aAdder;