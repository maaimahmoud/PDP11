Library IEEE;
use IEEE.std_logic_1164.all;
entity partD is
GENERIC (n : integer := 16);
port(a,b:in std_logic_vector(n-1 downto 0); s:in std_logic_vector(1 downto 0); cin:in std_logic; cout:out std_logic; f:out std_logic_vector(n-1 downto 0));
end entity partD;


architecture a_partD of partD is
begin

cout <=  a(15);

f <= a(n-2 downto 0)&'0'  when s="00"
else a(n-2 downto 0)&a(n-1)  when s="01"
else a(n-2 downto 0)&cin  when s= "10"
else "0000000000000000"  when s = "11";


end architecture;