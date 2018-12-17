library ieee;
use ieee.std_logic_1164.all;
entity reg is
	generic(n:integer :=6);
	port(clk,rst,en: in std_logic;
		d: in std_logic_vector(n-1 downto 0);
		q: out std_logic_vector(n-1 downto 0));
end reg;

architecture my_reg of reg is
begin
process(clk,rst,en)
begin
if rst='1' then
	q<=(others=>'0');
elsif  en='1' and rising_edge(clk) then
	q<=d;
end if;
end process;
end my_reg;


