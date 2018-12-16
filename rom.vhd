LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

-- ROM Entity

ENTITY rom IS

            GENERIC (m : integer := 24);
        PORT(
                address : IN  std_logic_vector(integer(ceil(log2(real(127))))-1 DOWNTO 0);
                dataout : OUT std_logic_vector(m-1 DOWNTO 0)
            );

END ENTITY rom;

------------------------------------------------------------

-- ROM Architecture

ARCHITECTURE arom OF rom IS

    TYPE romType IS ARRAY(0 TO 127) OF std_logic_vector(m-1 DOWNTO 0);

SIGNAL rom : romType ;

    BEGIN
            dataout <= rom(to_integer(unsigned(address)));
END arom;
