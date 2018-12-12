Library IEEE;
use IEEE.std_logic_1164.all;


ENTITY partC is

        GENERIC (n : integer := 16);
    port(
            a,b:in std_logic_vector(n-1 downto 0);
            s:in std_logic_vector(1 downto 0);
            cin:in std_logic; cout:out std_logic;
            f:out std_logic_vector(n-1 downto 0)
        );
end ENTITY partC;


architecture aPartC of partC is

    begin

    cout <= a(0);

    f <= '0'&a(n-1 downto 1) when s="00"
    else cin&a(n-1 downto 1) when s="01"
    else cin&a(n-1 downto 1) when s= "10"
    else a(n-1)&a(n-1 downto 1) when s = "11";


end architecture;