LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;

-- 0 -> MAR
-- 1 -> MDR

ENTITY myArchitecture IS

        GENERIC(regNum: integer := 3;wordSize :integer := 16); -- Log number of register - word size
    PORT(
        -- REGISTERS
            -- BUS WRITE TO REGISTER
                regDstB,regDstA: IN STD_LOGIC_VECTOR(regNum-1 DOWNTO 0); -- Detect which register that bus will write value to
                regDstEnB,regDstEnA: IN STD_LOGIC; -- Enable registers to read

           -- REGISTER WRITE TO BUS
               regSrcA: IN STD_LOGIC_VECTOR(regNum-1 DOWNTO 0); -- Detect which register to write
               regSrcEnA: IN STD_LOGIC; -- Enable writing to bus

       -- SPECIAL PURPOSE REGISTERS
           -- BUS WRITE TO REGISTER
               specialRegDstA,specialRegDstB : IN STD_LOGIC; -- Detect which register that bus will write value to
               specialRegDstEnA,specialRegDstEnB: IN STD_LOGIC; -- Enable registers to read
            -- REGISTER WRITE TO BUS
               specialRegSrcA: IN STD_LOGIC; -- Detect which special register to write
               specialRegSrcEnA: IN STD_LOGIC; -- Enable writing to bus       
              
       -- REGISTERS RESET
           regRst:IN STD_LOGIC_VECTOR((2**regNum)-1 DOWNTO 0); --(2**regNum)-1
           specialRegRst:IN STD_LOGIC_VECTOR(1 DOWNTO 0);

       -- READ AND WRITE FROM/TO MEMORY
           writeEn,readEn : IN STD_LOGIC;

        -- IR Register
            IREn,IRRst,IRSrc : IN STD_LOGIC;
            -- irOut : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

        -- Y Register
            YREn,YRRst,YSrc: IN STD_LOGIC;
            -- yOut : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

        -- Temp Register
            TempEn,TempRst,TempSrc: IN std_logic;
            -- tempOut : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
 

        --CLOCKS
            clk: IN std_logic;
            ramClk: IN std_logic;

        -- BUSES
            busB : INOUT std_logic_vector(wordSize-1 DOWNTO 0); -- OutputBus
            busA : INOUT std_logic_vector(wordSize-1 DOWNTO 0)  -- Bi-Directionl Bus
			
    );

END myArchitecture;

----------------------------------------------------------------------

ARCHITECTURE amyArchitecture OF myArchitecture IS
     

    --SIGNALS OF SPECIAL REGISTERS
            SIGNAL MARout : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            SIGNAL MDRout : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            -- Decode Source to Write on BUS A
                SIGNAL SrcDecodedA : STD_LOGIC_VECTOR(1 DOWNTO 0);
            -- Decode Registers that BUS A write to
                SIGNAL DstDecodedA : STD_LOGIC_VECTOR(1 DOWNTO 0);
            -- Decode Registers that BUS B write to
                SIGNAL DstDecodedB : STD_LOGIC_VECTOR(1 DOWNTO 0);

            -- Memory Out for address Saved in MAR
                SIGNAL MemoryOut : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            -- Detect which Bus will write to MAR,MDR
                SIGNAL writingBusMAR : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
                SIGNAL writingBusMDR : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            -- Final Enables for MAR,MDR after switching between two busses and memory(for MDR)
                SIGNAL enMAR : STD_LOGIC;
                SIGNAL enMDR : STD_LOGIC;

            -- ROM PARAMETERS
                SIGNAL mircoAR : STD_LOGIC_VECTOR (integer(ceil(log2(real(64))))-1 DOWNTO 0);
                SIGNAL ramOut : STD_LOGIC_VECTOR (23 DOWNTO 0);	

            -- Y Register
                SIGNAL yOut : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            -- Temp Register
                SIGNAL TempOut : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            -- IR Register
                SIGNAL IROut : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);


            -- ALU
                SIGNAL aluOperation : STD_LOGIC_VECTOR(4 DOWNTO 0); -- ALU OPERATION CODE
                SIGNAL flagRegReset : STD_LOGIC;
			
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
		
        ramMap: entity work.ram GENERIC MAP (wordSize) PORT MAP (ramClk,writeEn,MARout,MDRout,memoryOut);

        romMap: entity work.rom GENERIC MAP (24) PORT MAP (mircoAR,ramOut);

----------------------------------

    -- Y register
         YRegisterMap : entity work.reg GENERIC MAP(wordSize) PORT MAP (busA,YREn,YRRst,clk,yOut);
         tristateMapYR : entity work.tristate GENERIC MAP (wordSize) PORT MAP(yOut,YSrc,busA);
       
    -- IR register
        IRegisterMap : entity work.reg GENERIC MAP(wordSize) PORT MAP (busA,IREn,IRRst,clk,IRout);
        tristateMapIR : entity work.tristate GENERIC MAP(wordSize) PORT MAP(IRout,IRSrc,busA);
		
    -- Temp register
        TempRegisterMap : entity work.reg GENERIC MAP(wordSize) PORT MAP(busA,TempEn,TempRst,clk,TempOut);
        tristateMapTemp : entity work.tristate GENERIC MAP (wordSize) PORT MAP(TempOut,TempSrc,busA);
        

----------------------------------

    -- ALU
        aluMap : entity work.ALU GENERIC MAP (wordSize) PORT MAP (yOut,busA,aluOperation,clk,flagRegReset,busB);


END amyArchitecture;