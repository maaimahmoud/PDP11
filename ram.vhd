LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ram IS
		GENERIC (m : integer := 16);
	PORT(
		clk : IN std_logic;
		en  : IN std_logic;
		address : IN  std_logic_vector(m-1 DOWNTO 0);
		datain  : IN  std_logic_vector(m-1 DOWNTO 0);
		dataout : OUT std_logic_vector(m-1 DOWNTO 0));
END ENTITY ram;

ARCHITECTURE syncrama OF ram IS

	TYPE ram_type IS ARRAY(0 TO 2000) OF std_logic_vector(m-1 DOWNTO 0);
	SIGNAL ram : ram_type ;
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF falling_edge(clk) THEN  
					IF en = '1' THEN
						ram(to_integer(unsigned(address))) <= datain;
					END IF;
				END IF;
		END PROCESS;
		dataout <= ram(to_integer(unsigned(address)));
END syncrama;
