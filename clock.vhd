LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;

-- Clock Entity

ENTITY clock IS
    PORT(
        en,rst: IN std_logic ; 
        clk : INOUT std_logic
      );

end clock;

----------------------------------------------------------------------
-- Clock Architecture

ARCHITECTURE aClock OF clock IS

  BEGIN

      PROCESS (rst,en,clk)
          BEGIN
        --   IF rst =('1') then
        --         clk <= '1';
        --   else if en = ('1') then

                clk <= '1'; 
                wait for 0.05 ns;
                clk <= '0';
                wait for 0.05 ns;

        --     end if;
        --   end if;

      END PROCESS;

  END aClock;