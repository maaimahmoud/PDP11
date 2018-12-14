LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;


ENTITY specialReg IS
        GENERIC (m : integer := 32);
    PORT(
        src,dst,writeEn,readEn : IN std_logic;
        src_en,dst_en : IN std_logic;
        rst: IN std_logic_vector(1 downto 0);
        clk: IN std_logic ;
	    ramClk: IN std_logic;
        myBus : INOUT std_logic_vector(m-1 DOWNTO 0) 
        );

END specialReg;

ARCHITECTURE aspecialReg OF specialReg IS


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
    reset <= '0';

    srcDecodMap: decoder1x2 PORT MAP (src,src_en,SrcDecoded);

    MARMap: reg GENERIC MAP(m) PORT MAP  (mybus,DstDecoded(0),reset,clk,MARout );

    muxMDR : mux2 GENERIC MAP(m) PORT MAP (mybus,memoryOut,readEn,MuxOutData);

    --muxMDREn : mux2 GENERIC MAP(1) PORT MAP (DstDecoded(1),readEn,readEn,MuxOutEn);

    MuxOutEn <= readEn when readEn='1'
    else DstDecoded(1);
   

    MDRMap: reg GENERIC MAP(m) PORT MAP  (MuxOutData,MuxOutEn,reset,clk,MDRout );

    ramMap: ram PORT MAP (ramClk,writeEn,MARout,MDRout,memoryOut);

    dstDecodMap: decoder1x2 PORT MAP (dst,dst_en,DstDecoded);


    --TriMAR: tristate GENERIC MAP(m) PORT MAP  (MARout,SrcDecoded(0),mybus );
    --TriMDR: tristate GENERIC MAP(m) PORT MAP  (MDRout,SrcDecoded(1),mybus );

    --TriRead: tristate GENERIC MAP(m) PORT MAP  (memoryOut,readEn,mybus );


     --MDRout <= memoryOut when readEn = '1'
     --else (OTHERS=>'Z');

      mybus <= MARout when SrcDecoded(0) = '1'
      else (OTHERS=>'Z') when SrcDecoded = "00"
      else MDRout when readEn ='0'
      else memoryOut;

END aspecialReg;
