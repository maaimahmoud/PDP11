Library IEEE;
use IEEE.std_logic_1164.all;

entity partB is

        GENERIC (n : integer := 16);
    port(
        a,b:in std_logic_vector(n-1 downto 0);
        s:in std_logic_vector(1 downto 0);
        cin:in std_logic; cout:out std_logic;
        f:out std_logic_vector(n-1 downto 0)
        );

end entity partB;


architecture aPartB of partB is
    
    begin

    cout <= a(n-1);

    f<= a and b when s="00"
    else a OR b when s="01"
    else a xor b when s= "10"
    else NOT a when s = "11";

end architecture;