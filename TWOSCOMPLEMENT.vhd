
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


entity twocomp is
GENERIC (n : integer := 16);
port(a:in std_logic_vector(n-1 downto 0);  f:out std_logic_vector(n-1 downto 0));
end entity twocomp;


architecture a_twocomp of twocomp is
 COMPONENT my_nadder IS
GENERIC (n : integer := 16);
  PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0); cin : IN std_logic;   s : OUT std_logic_vector(n-1 DOWNTO 0);   cout : OUT std_logic);
   END COMPONENT;

SIGNAL inA:std_logic_vector( n-1 downto 0) ;
SIGNAL inB:std_logic_vector( n-1 downto 0) ;
SIGNAL inC:std_logic ;
SIGNAL outC:std_logic ;

begin

inA <= NOT a;
inB <= (0=>'1', OTHERS=>'0'); 
inC <= '0';
fx: my_nadder generic map(n) PORT MAP(inA,inB,inC,f,outC);

end architecture;
