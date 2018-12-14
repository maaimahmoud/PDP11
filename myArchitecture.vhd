LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;


ENTITY myArchitecture IS
      GENERIC(m:integer := 32);
  PORT(
      regDstB,regSrcA,regDstA: IN std_logic_vector(1 downto 0);
      specialRegSrc,specialRegDstA,specialRegDstB:IN std_logic;
      regDstEnB,regSrcEnA,regDstEnA,specialRegSrcEn,specialRegDstEnA,specialRegDstEnB:IN std_logic;
      regRst:IN std_logic_vector(3 downto 0);
      specialRegRst:IN std_logic_vector(1 downto 0);
      writeEn,readEn : IN std_logic;
      clk: IN std_logic;
      ramClk: IN std_logic;
      busB : INOUT std_logic_vector(m-1 DOWNTO 0);
      busA : INOUT std_logic_vector(m-1 DOWNTO 0) 
  );

END myArchitecture;

----------------------------------------------------------------------

ARCHITECTURE amyArchitecture OF myArchitecture IS
     

    SIGNAL MARout : std_logic_vector(m-1 DOWNTO 0);
    SIGNAL MDRout : std_logic_vector(m-1 DOWNTO 0);

    SIGNAL reset : std_logic;

    SIGNAL SrcDecoded : std_logic_vector(1 DOWNTO 0);
    SIGNAL DstDecoded : std_logic_vector(1 DOWNTO 0);

    SIGNAL MemoryOut : std_logic_vector(m-1 downto 0);

    SIGNAL MuxOutData : std_logic_vector(m-1 DOWNTO 0);

    SIGNAL MuxOutEn : std_logic;



  BEGIN

      regFileMap: entity work.regFile GENERIC MAP(m) PORT MAP  (regdstB,regdstEnB ,regsrcA,regdstA,regsrcEnA,regdstEnA,regrst,clk,busB,busA);

      --specialRegMap : specialReg GENERIC MAP(m) PORT MAP  (specialRegSrc,specialRegDst,writeEn,readEn,specialRegSrcEn,specialRegDstEn,specialRegRst,clk,ramClk,busA);
	


     reset <= '0';

    -- srcDecodMap: entity work.decoder GENERIC MAP(2) PORT MAP (specialRegSrc,specialRegSrcEn,SrcDecoded);

    -- MARMap: entity work.reg GENERIC MAP(m) PORT MAP  (busA,DstDecoded(0),reset,clk,MARout );

    -- muxMDR : entity work.mux GENERIC MAP(m) PORT MAP (busA,memoryOut,readEn,MuxOutData);


    MuxOutEn <= '1' when readEn='1'
    else DstDecoded(1);
   

    MDRMap: entity work.reg GENERIC MAP(m) PORT MAP  (MuxOutData,MuxOutEn,reset,clk,MDRout );

    ramMap: entity work.ram PORT MAP (ramClk,writeEn,MARout,MDRout,memoryOut);

    -- dstDecodMap: entity work.decoder GENERIC MAP(1) PORT MAP (specialRegDstA,specialRegDstEnA,DstDecoded);

      busA <= MARout when SrcDecoded(0) = '1'
      else MDRout when SrcDecoded(1) = '1'
      else (others=>'Z');


  END amyArchitecture;