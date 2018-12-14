LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;

-- 0 -> MAR
-- 1 -> MDR

ENTITY myArchitecture IS

        GENERIC(regNum: integer := 3;wordSize :integer := 16);
    PORT(
        regDstB,regSrcA,regDstA: IN std_logic_vector(regNum-1 downto 0);
        specialRegSrcA,specialRegDstA,specialRegDstB:IN std_logic;
        regDstEnB,regSrcEnA,regDstEnA,specialRegSrcEnA,specialRegDstEnA,specialRegDstEnB:IN std_logic;
        regRst:IN std_logic_vector((2**regNum)-1 downto 0);
        specialRegRst:IN std_logic_vector(1 downto 0);
        writeEn,readEn : IN std_logic;
        clk: IN std_logic;
        ramClk: IN std_logic;
        busB : INOUT std_logic_vector(wordSize-1 DOWNTO 0);
        busA : INOUT std_logic_vector(wordSize-1 DOWNTO 0) 
    );

END myArchitecture;

----------------------------------------------------------------------

ARCHITECTURE amyArchitecture OF myArchitecture IS
     

    --SIGNALS OF SPECIAL REGISTERS
        SIGNAL MARout : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL MDRout : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

        SIGNAL SrcDecodedA : STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL DstDecodedA : STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL DstDecodedB : STD_LOGIC_VECTOR(1 DOWNTO 0);

        SIGNAL MemoryOut : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);


        SIGNAL writingBusMAR : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL writingBusMDR : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

        SIGNAL enMAR : STD_LOGIC;
        SIGNAL enMDR : STD_LOGIC;
    ------------------------------


  BEGIN

--   REGISTER FILE

      regFileMap: entity work.regFile GENERIC MAP(regNum,wordSize) PORT MAP  (regdstB,regdstEnB ,regsrcA,regdstA,regsrcEnA,regdstEnA,regrst,clk,busB,busA);

----------------------------------

--  SPECIAL PURPOSE REGISTERS AND MEMORYS

   
        -- Write to Register(Regin)
            --Detect Which register bus will write 
                DstDecodedA <= "00" when specialRegDstEnA = '0'
                else "01" when specialRegDstA = '0'
                else "10" when specialRegDstA = '1';

                DstDecodedB <= "00" when specialRegDstEnB = '0'
                else "01" when specialRegDstB = '0'
                else "10" when specialRegDstB = '1';

            -- Set Enables for REGISTERS
                enMAR <= DstDecodedA(0) OR DstDecodedB(0);
                enMDR <= DstDecodedA(1) OR DstDecodedB(1) or readEn;

            -- Detect which bus will write
                writingBusMAR <= busA when specialRegDstEnA ='1'
                else busB when specialRegDstEnB = '1';

                writingBusMDR <= busA when specialRegDstEnA ='1'
                else busB when specialRegDstEnB = '1'
                else memoryOut;


                -- dstDecodMap: entity work.decoder GENERIC MAP(1) PORT MAP (specialRegDstA,specialRegDstEnA,DstDecoded);
            
            
        -- Detect Which Register will output on bus
            SrcDecodedA <= "00" when specialRegSrcEnA = '0'
            else "01" when specialRegSrcA = '0'
            else "10" when specialRegSrcA = '1';

        -- MAR and MDR registers
            MARMap: entity work.reg GENERIC MAP(wordSize) PORT MAP  (writingBusMAR,enMAR,specialRegRst(0),clk,MARout );

            MDRMap: entity work.reg GENERIC MAP(wordSize) PORT MAP  (writingBusMDR,enMDR,specialRegRst(1),clk,MDRout );
        
        -- Registers OUT to BUS A
            tristateMapMAR: entity work.tristate GENERIC MAP(wordSize) PORT MAP (MARout,SrcDecodedA(0),busA);

            tristateMapMDR: entity work.tristate GENERIC MAP(wordSize) PORT MAP (MDRout,SrcDecodedA(1),busA);

            --   busA <= MARout when SrcDecoded(0) = '1'
            --   else MDRout when SrcDecoded(1) = '1'
            --   else (others=>'Z');

        ramMap: entity work.ram GENERIC MAP (wordSize) PORT MAP (ramClk,writeEn,MARout,MDRout,memoryOut);

----------------------------------


  END amyArchitecture;