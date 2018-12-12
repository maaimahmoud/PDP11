LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;

-- Register Entity

ENTITY reg IS

        GENERIC (m : integer := 32); -- Number of bits in register
    PORT(
        T : IN std_logic_vector(m-1  DOWNTO 0);
        en,rst,clk: IN std_logic ; 
        myBus : INOUT std_logic_vector(m-1 DOWNTO 0)
      );

end reg;

----------------------------------------------------------------------
-- Register Architecture

ARCHITECTURE aReg OF reg IS

  BEGIN

      PROCESS (rst,clk,en,T)
          BEGIN
          IF rst =('1') then
            myBus <= (OTHERS=>'0');
            else if ( clk'event and clk = '1') then
            if en = ('1') then
              myBus <= T;
            end if;
            end if;
          end if;

      END PROCESS;

  END aReg;