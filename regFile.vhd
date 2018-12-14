LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;
LIBRARY work;
USE work.mine;
USE IEEE.numeric_std.all;


-- Register File Entity

ENTITY regFile IS
    GENERIC (regNum : integer := 3 ; wordSize : integer := 16); -- log of Number of registers , Size of each Register
  PORT(
        dstB : IN std_logic_vector(regNum-1  DOWNTO 0);
        dstEnB : IN std_logic;
        srcA,dstA : IN std_logic_vector(regNum-1  DOWNTO 0);
        srcEnA,dstEnA : IN std_logic;
        rst: IN std_logic_vector((2**regNum)-1 downto 0);
        clk: IN std_logic ;
        busB : IN std_logic_vector(wordSize-1 DOWNTO 0);
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
                en: IN std_logic;
                output : OUT std_logic_vector(n-1 DOWNTO 0)
            );
      END COMPONENT;

      COMPONENT MUX IS 
        
            GENERIC (inputNum : integer := 2 ; wordSize : integer := 16); -- Number of inputs to MUX and word Size of each
        PORT(
                inputs : IN  mine.genericArrayofVector16bit(0 to inputNum-1);
                selectionLines : IN std_logic_vector (integer(ceil(log2(real(inputNum))))-1 downto 0);
                output : OUT std_logic_vector(wordSize-1 DOWNTO 0)
            );
      END COMPONENT;

      SIGNAL SrcDecoded : std_logic_vector((2**regNum - 1) DOWNTO 0);

      SIGNAL DstDecodedA : std_logic_vector((2**regNum - 1) DOWNTO 0);

      SIGNAL DstDecodedB : std_logic_vector((2**regNum - 1) DOWNTO 0);

      SIGNAL finalDstEn : std_logic_vector((2**regNum - 1) DOWNTO 0);


      type myArray is array(0 to 2**regNum -1) of STD_LOGIC_VECTOR(wordSize-1 downto 0);
      

      SIGNAL myRegisters :myArray  ;

      SIGNAL writingBus :myArray ;



  BEGIN


      srcDecodMap: decoder GENERIC MAP (regNum) PORT MAP (srcA,srcEnA,SrcDecoded);

      dstDecodAMap: decoder GENERIC MAP (regNum) PORT MAP (dstA,dstEnA,DstDecodedA);

      dstDecodBMap: decoder GENERIC MAP (regNum) PORT MAP (dstB,dstEnB,DstDecodedB);

      

      loop1: FOR i IN 0 TO (2**regNum - 1)
          GENERATE
            
            finalDstEn(i) <= (DstDecodedA(i) OR DstDecodedB(i));

            WritingBus(i) <= busA when (DstDecodedA(i) = '1')
            else busB;


              regMap: reg GENERIC MAP(wordSize) PORT MAP (WritingBus(i),finalDstEn(i),rst(i),clk,myRegisters(i));
              
              tristateMap: tristate GENERIC MAP(wordSize) PORT MAP (myRegisters(i),SrcDecoded(i),busA);

          END GENERATE;


  END aRegFile;