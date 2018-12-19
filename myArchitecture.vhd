LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;

-- 0 -> MAR
-- 1 -> MDR

ENTITY myArchitecture IS

        GENERIC(regNum: integer := 3;wordSize :integer := 16); -- Log number of register - word size
    -- PORT();

END myArchitecture;

----------------------------------------------------------------------

ARCHITECTURE amyArchitecture OF myArchitecture IS


    -- REGISTERS
        -- BUS WRITE TO REGISTER
        SIGNAL regDstB,regDstA: STD_LOGIC_VECTOR(regNum-1 DOWNTO 0); -- Detect which register that bus will write value to
        SIGNAL regDstEnB,regDstEnA: STD_LOGIC; -- Enable registers to read

    -- REGISTER WRITE TO BUS
        SIGNAL regSrcA: STD_LOGIC_VECTOR(regNum-1 DOWNTO 0); -- Detect which register to write
        SIGNAL regSrcEnA: STD_LOGIC; -- Enable writing to bus

   -- SPECIAL PURPOSE REGISTERS
       -- BUS WRITE TO REGISTER
             SIGNAL specialRegDstA,specialRegDstB : STD_LOGIC; -- Detect which register that bus will write value to
             SIGNAL specialRegDstEnA,specialRegDstEnB: STD_LOGIC; -- Enable registers to read
        -- REGISTER WRITE TO BUS
             SIGNAL specialRegSrcA: STD_LOGIC; -- Detect which special register to write
             SIGNAL specialRegSrcEnA: STD_LOGIC; -- Enable writing to bus       
          
   -- REGISTERS RESET
        SIGNAL regRst: STD_LOGIC_VECTOR((2**regNum)-1 DOWNTO 0); --(2**regNum)-1
        SIGNAL specialRegRst: STD_LOGIC_VECTOR(1 DOWNTO 0);

   -- READ AND WRITE FROM/TO MEMORY
        SIGNAL writeEn,readEn :  STD_LOGIC;
        -- SIGNAL ramInput : STD_LOGIC_VECTOR(wordSize-1 DONWTO 0);

    -- IR Register
        SIGNAL IREn,IRRst,IRSrc : STD_LOGIC;
        SIGNAL IRAddressOut : STD_LOGIC;
        SIGNAL addressFieldIR: STD_LOGIC_VECTOR (wordSize-1 DOWNTO 0);
        SIGNAL endInstruction : STD_LOGIC;

    -- Y Register
        SIGNAL YREn,YRRst,YSrc: STD_LOGIC;
        -- yOut : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    -- Temp Register
        SIGNAL TempEn,TempRst,TempSrc: std_logic;
        -- tempOut : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    -- ALU
        SIGNAL flagRegReset: STD_LOGIC;
        SIGNAL flagRegEn: STD_LOGIC;
        SIGNAL flagRegDstEnA: STD_LOGIC;

    --CLOCKS
        SIGNAL Sysclk: std_logic;
        SIGNAL clk: std_logic;
        SIGNAL ramClk: std_logic;
        SIGNAL clkEn : STD_LOGIC;

    -- BUSES
        SIGNAL busB : std_logic_vector(wordSize-1 DOWNTO 0); -- OutputBus
        SIGNAL busA : std_logic_vector(wordSize-1 DOWNTO 0);  -- Bi-Directionl Bus
    

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

            -- Y Register
                SIGNAL yOut : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            -- Temp Register
                SIGNAL TempOut : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            -- IR Register
                SIGNAL IROut : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);


            -- ALU
                SIGNAL aluOperation : STD_LOGIC_VECTOR(4 DOWNTO 0); -- ALU OPERATION CODE
                -- SIGNAL flagRegReset : STD_LOGIC;
                SIGNAL flagRegSrc : STD_LOGIC;
                SIGNAL flagRegValue : STD_LOGIC_VECTOR(4 DOWNTO 0);
          
            -- ROM
                SIGNAL romReset : STD_LOGIC;
                SIGNAL romOut : STD_LOGIC_VECTOR(23 DOWNTO 0);
			
    ------------------------------


  BEGIN

-- Stop Clk if ClkEnable Equals Zero
    clk <= Sysclk AND clkEn;
    -- clkMap : entity work.clock PORT MAP (clkEn,'0',clk);

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
                enMAR <= '1' when (DstDecodedA(0)='1' OR DstDecodedB(0)='1')
                else '0';
                enMDR <= '1' when (DstDecodedA(1)='1' OR DstDecodedB(1)='1' or readEn='1')
                else '0';

            -- Detect which bus will write
                writingBusMAR <= busA when DstDecodedA(0) ='1'
                else busB when DstDecodedB(0)='1';

                writingBusMDR <= busA when (DstDecodedA(1) ='1')
                else busB when (DstDecodedB(1) ='1')
                else memoryOut;

  
        -- Detect Which Register will output on bus
            SrcDecodedA <= "00" when specialRegSrcEnA = '0'
            else "01" when specialRegSrcA = '0'
            else "10" when specialRegSrcA = '1';

        -- MAR and MDR registers
            MARMap: entity work.reg GENERIC MAP(wordSize) PORT MAP  (writingBusMAR,enMAR,specialRegRst(0),clk,MARout );

            MDRMap: entity work.reg GENERIC MAP(wordSize) PORT MAP  (writingBusMDR,enMDR,specialRegRst(1),ramClk,MDRout );
        
        -- Registers OUT to BUS A
            tristateMapMAR: entity work.tristate GENERIC MAP(wordSize) PORT MAP (MARout,SrcDecodedA(0),busA);

            tristateMapMDR: entity work.tristate GENERIC MAP(wordSize) PORT MAP (MDRout,SrcDecodedA(1),busA);

            -- ramInput <= writingBusMDR

            ramMap: entity work.ram GENERIC MAP (wordSize) PORT MAP (ramClk,writeEn,MARout,writingBusMDR,memoryOut);


----------------------------------

    -- Y register
         YRegisterMap : entity work.reg GENERIC MAP(wordSize) PORT MAP (busA,YREn,YRRst,clk,yOut);
         tristateMapYR : entity work.tristate GENERIC MAP (wordSize) PORT MAP(yOut,YSrc,busA);
       
    -- IR register
        IRegisterMap : entity work.reg GENERIC MAP(wordSize) PORT MAP (busA,IREn,IRRst,clk,IRout);
        tristateMapIR : entity work.tristate GENERIC MAP(wordSize) PORT MAP(IRout,IRSrc,busA);
        -- Out Address-field of IR to bus A
            addressFieldIR(15 DOWNTO 7) <= (OTHERS=>IRout(7));
            addressFieldIR(6 DOWNTO 0) <= IRout(6 DOWNTO 0);
            tristateMapIRaddress : entity work.tristate GENERIC MAP(wordSize) PORT MAP (addressFieldIR,IRAddressOut,busA);
        
    -- Temp register
        TempRegisterMap : entity work.reg GENERIC MAP(wordSize) PORT MAP(busA,TempEn,TempRst,clk,TempOut);
        tristateMapTemp : entity work.tristate GENERIC MAP (wordSize) PORT MAP(TempOut,TempSrc,busA);
        

----------------------------------

    -- ALU
        aluMap : entity work.ALU GENERIC MAP (wordSize) PORT MAP (yOut,busA,aluOperation,clk,flagRegEn,flagRegSrc,flagRegDstEnA,flagRegReset,flagRegValue,busB);


----------------------------------

    -- ROM
        romMap : entity work.romModule GENERIC MAP(wordSize) PORT MAP (clk,romReset,'1',flagRegValue(3),flagRegValue(2),IRout,romOut);


    -- Decoder for control word

        decoderControlMap : entity work.ControlWordDecoder PORT MAP(
        IRout,romOut,endInstruction ,clkEn ,YREn,tempEn,TempSrc,flagRegEn,
        flagRegSrc,flagRegDstEnA,aluOperation,IREn,
        IRAddressOut,regDstB,regDstA,regDstEnB,regDstEnA,
        regSrcA,regSrcEnA,specialRegDstA,specialRegDstB,
        specialRegDstEnA,specialRegDstEnB,specialRegSrcA,
        specialRegSrcEnA,regRst,specialRegRst,writeEn,readEn);

----------------------------------      
END amyArchitecture;