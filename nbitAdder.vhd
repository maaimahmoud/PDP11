LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- N-bit Adder Entity
ENTITY nAdder IS
       GENERIC (n : integer := 16);
  PORT(
      a,b : IN std_logic_vector(n-1  DOWNTO 0);
      carryIn : IN std_logic;
      s : OUT std_logic_vector(n-1 DOWNTO 0);
      carryOut : OUT std_logic
    );

END nAdder;

------------------------------------------------------------

-- N-bit Adder Architecture

ARCHITECTURE aNAdder OF nAdder IS

  COMPONENT my_adder IS
        PORT( a,b,carryIn : IN std_logic; s,carryOut : OUT std_logic);
    END COMPONENT;

SIGNAL temp : std_logic_vector(n-1 DOWNTO 0);

BEGIN

      f0: my_adder PORT MAP(a(0),b(0),carryIn,s(0),temp(0));


      loop1: FOR i IN 1 TO n-1
      GENERATE
            
          fx: my_adder PORT MAP  (a(i),b(i),temp(i-1),s(i),temp(i));

      END GENERATE;
        
      
      carryOut <= temp(n-1);


END aNAdder;
