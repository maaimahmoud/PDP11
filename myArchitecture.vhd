LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;


ENTITY myArchitecture IS
      GENERIC(m:integer := 32);
  PORT(
      regSrc,regDst: IN std_logic_vector(1 downto 0);
      specialRegSrc,specialRegDst:IN std_logic;
      regSrcEn,regDstEn,specialRegSrcEn,specialRegDstEn:IN std_logic;
      regRst:IN std_logic_vector(3 downto 0);
      specialRegRst:IN std_logic_vector(1 downto 0);
      writeEn,readEn : IN std_logic;
      clk: IN std_logic;
      ramClk: IN std_logic;
      myBus : INOUT std_logic_vector(m-1 DOWNTO 0) 
  );

END myArchitecture;

----------------------------------------------------------------------

ARCHITECTURE amyArchitecture OF myArchitecture IS
     
      COMPONENT regFile IS
              GENERIC (m : integer := 32);
        PORT(
              src,dst : IN std_logic_vector(1  DOWNTO 0);
              src_en,dst_en : IN std_logic;
              rst: IN std_logic_vector(3 downto 0);
              clk: IN std_logic ;
              myBus : INOUT std_logic_vector(m-1 DOWNTO 0)
            );
            
      END COMPONENT;

      COMPONENT specialReg IS
            GENERIC (m : integer := 32);
        PORT(
            src,dst,writeEn,readEn : IN std_logic;
            src_en,dst_en : IN std_logic;
            rst: IN std_logic_vector(1 downto 0);
            clk: IN std_logic ;
	        ramClk: IN std_logic;
            myBus : INOUT std_logic_vector(m-1 DOWNTO 0) 
            );
        END COMPONENT;


   COMPONENT reg IS
            GENERIC (m : integer := 32);
        PORT(
            T : IN std_logic_vector(m-1  DOWNTO 0);
            en,rst,clk: IN std_logic ; 
            myBus : INOUT std_logic_vector(m-1 DOWNTO 0)
        );
    END COMPONENT;


    COMPONENT decoder1x2 IS
        PORT(
                T : IN std_logic;
                en:IN std_logic;
                decoded : OUT std_logic_vector(1 DOWNTO 0)
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

    COMPONENT ram IS
            GENERIC (m : integer := 32);
        PORT(
            clk : IN std_logic;
            en  : IN std_logic;
            address : IN  std_logic_vector(5 DOWNTO 0);
            datain  : IN  std_logic_vector(m-1 DOWNTO 0);
            dataout : OUT std_logic_vector(m-1 DOWNTO 0)
            );
    END COMPONENT;


    COMPONENT mux2 IS
            GENERIC (n : integer := 32);
        PORT(
                T1 : IN std_logic_vector(n-1  DOWNTO 0);
                T2 : IN std_logic_vector(n-1  DOWNTO 0);
                s : IN std_logic;
                output : OUT std_logic_vector(n-1 DOWNTO 0)
            );
    END COMPONENT;


    SIGNAL MARout : std_logic_vector(m-1 DOWNTO 0);
    SIGNAL MDRout : std_logic_vector(m-1 DOWNTO 0);

    SIGNAL reset : std_logic;

    SIGNAL SrcDecoded : std_logic_vector(1 DOWNTO 0);
    SIGNAL DstDecoded : std_logic_vector(1 DOWNTO 0);

    SIGNAL MemoryOut : std_logic_vector(m-1 downto 0);

    SIGNAL MuxOutData : std_logic_vector(m-1 DOWNTO 0);

    SIGNAL MuxOutEn : std_logic;



  BEGIN

      regFileMap: regFile GENERIC MAP(m) PORT MAP  (regSrc,regDst,regSrcEn,regDstEn,regRst,clk,myBus);

      --specialRegMap : specialReg GENERIC MAP(m) PORT MAP  (specialRegSrc,specialRegDst,writeEn,readEn,specialRegSrcEn,specialRegDstEn,specialRegRst,clk,ramClk,myBus);
	


     reset <= '0';

    srcDecodMap: decoder1x2 PORT MAP (specialRegSrc,specialRegSrcEn,SrcDecoded);

    MARMap: reg GENERIC MAP(m) PORT MAP  (mybus,DstDecoded(0),reset,clk,MARout );

    muxMDR : mux2 GENERIC MAP(m) PORT MAP (mybus,memoryOut,readEn,MuxOutData);


    MuxOutEn <= '1' when readEn='1'
    else DstDecoded(1);
   

    MDRMap: reg GENERIC MAP(m) PORT MAP  (MuxOutData,MuxOutEn,reset,clk,MDRout );

    ramMap: ram PORT MAP (ramClk,writeEn,MARout,MDRout,memoryOut);

    dstDecodMap: decoder1x2 PORT MAP (specialRegDst,specialRegDstEn,DstDecoded);

      mybus <= MARout when SrcDecoded(0) = '1'
      else MDRout when SrcDecoded(1) = '1'
      else (others=>'Z');


  END amyArchitecture;