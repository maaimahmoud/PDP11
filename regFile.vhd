LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;
LIBRARY work;
USE work.mine.all;
USE IEEE.numeric_std.all;


-- Register File Entity

ENTITY regFile IS
    GENERIC (regNum : integer := 3 ; wordSize : integer := 16); -- log of Number of registers , Size of each Register
  PORT(
        src,dst : IN std_logic_vector(regNum-1  DOWNTO 0);
        src_en,dst_en : IN std_logic;
        rst: IN std_logic_vector((2**regNum)-1 downto 0);
        clk: IN std_logic ;
        busA : INOUT std_logic_vector(wordSize-1 DOWNTO 0)
      );

END regFile;

----------------------------------------------------------------------
-- Register File Architecture

ARCHITECTURE aRegFile OF regFile IS

      COMPONENT reg IS
            GENERIC (m : integer := 32);
        PORT(
            T : IN std_logic_vector(m-1  DOWNTO 0);
            en,rst,clk: IN std_logic ; 
            myBus : INOUT std_logic_vector(m-1 DOWNTO 0)
          );

      END COMPONENT;


      COMPONENT decoder IS
            GENERIC (n : integer := 3); --N : Number of selection Lines
        PORT(
                T : IN std_logic_vector(n-1  DOWNTO 0); 
                en:IN std_logic;
                decoded : OUT std_logic_vector((2**n)-1 DOWNTO 0)
            );
      END COMPONENT;


      COMPONENT tristate IS
            GENERIC (n : integer := 32);
        PORT(
                T : IN std_logic_vector(n-1  DOWNTO 0);
                en:IN std_logic;
                output : OUT std_logic_vector(n-1 DOWNTO 0)
            );
      END COMPONENT;

      SIGNAL SrcDecoded : std_logic_vector((2**regNum - 1) DOWNTO 0);

      SIGNAL DstDecoded : std_logic_vector((2**regNum - 1) DOWNTO 0);


      type registers is array(0 to 2**regNum -1) of STD_LOGIC_VECTOR(wordSize-1 downto 0);
      

      SIGNAL myRegisters :registers  ;



  BEGIN


      srcDecodMap: decoder GENERIC MAP (regNum) PORT MAP (src,src_en,SrcDecoded);

      dstDecodMap: decoder GENERIC MAP (regNum) PORT MAP (dst,dst_en,DstDecoded);


      loop1: FOR i IN 0 TO (2**regNum - 1)
          GENERATE
              regMap: reg GENERIC MAP(wordSize) PORT MAP  (busA,DstDecoded(i),rst(i),clk,myRegisters(i) );
              
              tristateMap: tristate GENERIC MAP(wordSize) PORT MAP (myRegisters(i),SrcDecoded(i),busA);

          END GENERATE;


  END aRegFile;