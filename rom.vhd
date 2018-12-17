LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY rom IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic; --set when read op
		address : IN  std_logic_vector(5 DOWNTO 0);
		dataout : OUT std_logic_vector(23 DOWNTO 0));
END ENTITY rom;

ARCHITECTURE syncromo OF rom IS

	TYPE rom_type IS ARRAY(0 TO 63) OF std_logic_vector(23 DOWNTO 0);
	SIGNAL rom : rom_type;

	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF falling_edge(clk) THEN  
					IF we = '1' THEN
                    dataout <= rom(to_integer(unsigned(address)));
					END IF;
				END IF;
		END PROCESS;
	
END syncromo;

