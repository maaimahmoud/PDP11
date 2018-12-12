LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


entity ALU is
      GENERIC (n : integer := 16);
    port(
        a,b:in std_logic_vector(n-1 downto 0);
        s:in std_logic_vector(3 downto 0); cin:in std_logic;
        cout:out std_logic;
        f:out std_logic_vector(n-1 downto 0)
      );

end entity ALU;


architecture aALU of ALU is

  COMPONENT partA IS
          GENERIC (n : integer := 16);
      port(
          a,b:in std_logic_vector(n-1 downto 0);
          s:in std_logic_vector(1 downto 0); cin:in std_logic;
          cout:out std_logic; f:out std_logic_vector(n-1 downto 0)
        );
   END COMPONENT;


 COMPONENT partB IS
          GENERIC (n : integer := 16);
      port(
        a,b:in std_logic_vector(n-1 downto 0);
        s:in std_logic_vector(1 downto 0);
        cin:in std_logic; cout:out std_logic;
        f:out std_logic_vector(n-1 downto 0)
        );
   END COMPONENT;

 COMPONENT partC IS
      GENERIC (n : integer := 16);
    port(
        a,b:in std_logic_vector(n-1 downto 0);
        s:in std_logic_vector(1 downto 0);
        cin:in std_logic; cout:out std_logic;
        f:out std_logic_vector(n-1 downto 0)
      );
   END COMPONENT;

 COMPONENT partD IS
        GENERIC (n : integer := 16);
    port(
      a,b:in std_logic_vector(n-1 downto 0);
      s:in std_logic_vector(1 downto 0);
      cin:in std_logic; cout:out std_logic;
      f:out std_logic_vector(n-1 downto 0)
      );
   END COMPONENT;

SIGNAL Apart:std_logic_vector( n-1 downto 0) ;
SIGNAL Bpart:std_logic_vector( n-1 downto 0) ;
SIGNAL Cpart:std_logic_vector( n-1 downto 0) ;
SIGNAL Dpart:std_logic_vector( n-1 downto 0) ;
SIGNAL ApartOut:std_logic ;
SIGNAL BpartOut:std_logic ;
SIGNAL CpartOut:std_logic ;
SIGNAL DpartOut:std_logic ;

begin


fx: partA generic map(n) PORT MAP(a,b,s(1 downto 0),cin,ApartOut,Apart);
fy: partB generic map(n) PORT MAP(a,b,s(1 downto 0),cin,BpartOut,Bpart);
fz: partC generic map(n) PORT MAP(a,b,s(1 downto 0),cin,CpartOut,Cpart);
fw: partD generic map(n) PORT MAP(a,b,s(1 downto 0),cin,DpartOut,Dpart);


f<= Apart when s(3 downto 2)="00"
else Bpart when s(3 downto 2)="01"
else Cpart when s(3 downto 2)= "10"
else Dpart when s(3 downto 2) = "11";


cout<= ApartOut when s(3 downto 2)="00"
else BpartOut when s(3 downto 2)="01"
else CpartOut when s(3 downto 2)= "10"
else DpartOut when s(3 downto 2) = "11";


end architecture;