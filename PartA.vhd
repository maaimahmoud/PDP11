LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


entity partA is
    GENERIC (n : integer := 16);

      port(
          a,b:in std_logic_vector(n-1 downto 0);
          s:in std_logic_vector(1 downto 0);
          cin:in std_logic; cout:out std_logic;
          f:out std_logic_vector(n-1 downto 0)
        );

end entity partA;


architecture aPartA of partA is

    COMPONENT my_nadder IS
       GENERIC (n : integer := 16);
          PORT(
            a,b : IN std_logic_vector(n-1  DOWNTO 0);
            cin : IN std_logic; s : OUT std_logic_vector(n-1 DOWNTO 0);
            cout : OUT std_logic
            );

      END COMPONENT;

  COMPONENT twocomp IS
    GENERIC (n : integer := 16);
      port(
          a:in std_logic_vector(n-1 downto 0);
          f:out std_logic_vector(n-1 downto 0)
        );
    END COMPONENT;

  SIGNAL inA:std_logic_vector( n-1 downto 0) ;
  SIGNAL inB:std_logic_vector( n-1 downto 0) ;
  SIGNAL Bbar:std_logic_vector( n-1 downto 0) ;
  SIGNAL inC:std_logic ;
  SIGNAL outC:std_logic ;

  begin

      inA<=  x"0000" when cin&s(1 downto 0)="111"
      else A ;

  --bar: twocomp generic map(16) port map (B,Bbar);

      inB<= x"0000"  when cin&s(1 downto 0)="000"
      else B when cin&s(1 downto 0)="001"
      else (NOT B) when cin&s(1 downto 0)= "010"
      else x"FFFF" when cin&s(1 downto 0) = "011"
      else x"0001" when cin&s(1 downto 0)="100"
      else B when cin&s(1 downto 0)="101"
      else (NOT B) when cin&s(1 downto 0)= "110"
      else x"0000" when cin&s(1 downto 0) = "111";

      inC <= '1' when cin&s(1 downto 0)= "101"
      else '1' when cin&s(1 downto 0)="110"
      else '0';

    fx: my_nadder generic map(16) PORT MAP(inA,inB,inC,f,outC);

end architecture;

