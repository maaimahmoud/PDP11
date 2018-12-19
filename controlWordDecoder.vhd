LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
use IEEE.math_real.all;


ENTITY ControlWordDecoder IS

    PORT(

        -- IR
            IRout : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

        -- INPUTS FROM CONTROL WORD
            romOut : IN STD_LOGIC_VECTOR (23 DOWNTO 0);

        -- OUTPUTS FROM DECODING CIRCUTS

            -- INSTRUCTIONS
                endInstruction : OUT STD_LOGIC;
                clkEn : OUT STD_LOGIC;

            -- Y REGISTER
                yEn : OUT STD_LOGIC; -- Save value on BUS A in Y resgister

            -- TEMP REGISTER
                tempEn : OUT STD_LOGIC; -- Save value on BUS A in Y resgister
                tempOut : OUT STD_LOGIC; -- Out temp to BUS B

            -- ALU PARAMETERS
                flagRegEn : OUT STD_LOGIC; --SAVE VALUES IN FLAG REGISTER FROM ALU OPERATION
                flagRegOut : OUT STD_LOGIC; -- OUT FLAG REGISTER TO BUS A
                flagRegDstEnA : OUT STD_LOGIC; -- SAVE VALUES IN FLAG REGISTER FROM BUS A
                aluOperation : OUT STD_LOGIC_VECTOR(4 DOWNTO 0); -- ALU OPERATION CODE

            -- IR REGISTER
                IRRegEn : OUT STD_LOGIC ; -- Save value on BUS A in IR resgister
                IRAddressOut : OUT STD_LOGIC ; -- Out Address-Field-of-IR on BUS A
                -- checkFlagReg : OUT STD_LOGIC ;
                
            -- REGISTERS
                -- BUS WRITE TO REGISTER
                     regDstB,regDstA: OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- Detect which register that bus will write value to
                     regDstEnB,regDstEnA: OUT STD_LOGIC; -- Enable registers to read

                -- REGISTER WRITE TO BUS
                    regSrcA: OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- Detect which register to write
                    regSrcEnA: OUT STD_LOGIC; -- Enable writing to bus

            -- SPECIAL PURPOSE REGISTERS
                -- BUS WRITE TO REGISTER
                    specialRegDstA,specialRegDstB : OUT STD_LOGIC; -- Detect which register that bus will write value to
                    specialRegDstEnA,specialRegDstEnB: OUT STD_LOGIC; -- Enable registers to read
                 -- REGISTER WRITE TO BUS
                    specialRegSrcA: OUT STD_LOGIC; -- Detect which special register to write
                    specialRegSrcEnA: OUT STD_LOGIC; -- Enable writing to bus
            
            
            
            -- REGISTERS RESET
                regRst:OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --(2**regNum)-1
                specialRegRst:OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

            -- READ AND WRITE FROM/TO MEMORY
                writeEn,readEn : OUT STD_LOGIC

  
    );

END ControlWordDecoder;

----------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE aControlWordDecoder OF ControlWordDecoder IS
    
        -- Divide IR
            SIGNAL OPCODE : STD_LOGIC_VECTOR(4 DOWNTO 0); -- 4 bits for instruction OPCODE
            SIGNAL NEXTOPCODE : STD_LOGIC_VECTOR(4 DOWNTO 0); -- NEXT 4 bits for instruction OPCODE ( 1-OPERAND )
            SIGNAL srcReg : STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits for source register
            SIGNAL dstReg : STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits for destination register
        

        -- Divide Control word to Fs
            SIGNAL F0 : STD_LOGIC;
            SIGNAL F1,F5,F6  : STD_LOGIC_VECTOR(1 DOWNTO 0);
            SIGNAL F2,F3,F4 : STD_LOGIC_VECTOR(2 DOWNTO 0);

        --SIGNALS OF SPECIAL REGISTERS
            -- SIGNAL F0DECODED: STD_LOGIC_VECTOR (1 DOWNTO 0);
            SIGNAL F1DECODED: STD_LOGIC_VECTOR (3 DOWNTO 0);
            SIGNAL F2DECODED: STD_LOGIC_VECTOR (7 DOWNTO 0);
            SIGNAL F3DECODED: STD_LOGIC_VECTOR (7 DOWNTO 0);
            SIGNAL F4DECODED: STD_LOGIC_VECTOR (7 DOWNTO 0);
            SIGNAL F5DECODED: STD_LOGIC_VECTOR (3 DOWNTO 0);
            SIGNAL F6DECODED: STD_LOGIC_VECTOR (3 DOWNTO 0);
            -- SIGNAL F7DECODED: STD_LOGIC_VECTOR (3 DOWNTO 0);
            


        -- ADDRESS SAVED IN HARDWARE

            SIGNAL ADDRESS: STD_LOGIC_VECTOR(6 DOWNTO 0):= "1011101";

        -- ALU PARAMETERS
            SIGNAL aluUsed : STD_LOGIC;
            SIGNAL adderOut : STD_LOGIC_VECTOR(4 DOWNTO 0);
            SIGNAL adderCarryOut : STD_LOGIC;

        ------------------------------


  BEGIN

            OPCODE <= '0'&IRout(15 DOWNTO 12);
            NEXTOPCODE <= '0'&IRout(11 DOWNTO 8);
            srcReg <= IRout(8 DOWNTO 6);
            dstReg <= IRout(2 DOWNTO 0);
        

            F0 <= romOut(23);
            F1 <= romOut(22 DOWNTO 21);
            F2 <= romOut(20 DOWNTO 18);
            F3 <= romOut(17 DOWNTO 15);
            F4 <= romOut(14 DOWNTO 12);
            F5 <= romOut(11 DOWNTO 10);
            F6 <= romOut(9 DOWNTO 8);
            
        -- Decoder for every F
            -- F0DECODERMAP: entity work.DECODER GENERIC MAP( 1 ) PORT MAP ( F0,'1',F0DECODED );
            F1DECODERMAP: entity work.DECODER GENERIC MAP( 2 ) PORT MAP ( F1,'1',F1DECODED );
            F2DECODERMAP: entity work.DECODER GENERIC MAP( 3 ) PORT MAP ( F2,'1',F2DECODED );
            F3DECODERMAP: entity work.DECODER GENERIC MAP( 3 ) PORT MAP ( F3,'1',F3DECODED );
            F4DECODERMAP: entity work.DECODER GENERIC MAP( 3 ) PORT MAP ( F4,'1',F4DECODED );
            F5DECODERMAP: entity work.DECODER GENERIC MAP( 2 ) PORT MAP ( F5,'1',F5DECODED );
            F6DECODERMAP: entity work.DECODER GENERIC MAP( 2 ) PORT MAP ( F6,'1',F6DECODED );
            -- F7DECODERMAP: entity work.DECODER GENERIC MAP( 2 ) PORT MAP ( F7,'1',F7DECODED );

        ------------------------------------------------------------------------------------------------------------------------
        -- F0 Decode

        ------------------------------------------------------------------------------------------------------------------------
        -- F1 Decode

            -- Check that ALU is used from bits of F3 
                    aluUsed <= '1' when ( F4DECODED(1) = '1' OR F4DECODED(2) ='1' OR F4DECODED(3) = '1' OR F4DECODED(4)='1' )
                    else '0';

            -- Enable write Values in Registers In Case of (PCin or SPin or Rin)

                -- Write From BUS A if no ALU operation is needed
                        regDstEnA <= '1' when ( (F1DECODED(1)='1' OR F1DECODED(2)='1' OR F1DECODED(3)='1')  AND aluUsed = '0' )
                        else '0';

                        -- Detect Which register will write from BUS A
                            regDstA <= "111" when (F1DECODED(1)='1' AND aluUsed = '0' ) --PCin and NO ALU operaion

                            else "110" when (F1DECODED(2)='1' AND aluUsed = '0' ) --SPin and NO ALU operaion
                
                            else srcReg when (F1DECODED(3)='1' AND aluUsed = '0'  AND F0 = '0' ) --Rsrc and NO ALU operaion

                            else dstReg when (F1DECODED(3)='1' AND aluUsed = '0'  AND F0 = '1' ); --Rdst and NO ALU operaion
            
                -- Write From BUS B if ALU operation is needed
                        regDstEnB <= '1' when ( (F1DECODED(1)='1' OR F1DECODED(2)='1' OR F1DECODED(3)='1') AND aluUsed = '1' )
                        else '0';

                            -- Detect Which register will write from BUS A
                                regDstB <= "111" when (F1DECODED(1)='1' AND aluUsed = '1' ) --PCin and NO ALU operaion

                                else "110" when (F1DECODED(2)='1' AND aluUsed = '1' ) --SPin and NO ALU operaion
                    
                                else srcReg when (F1DECODED(3)='1' AND aluUsed = '1'  AND F0 = '0' ) --Rsrc and NO ALU operaion

                                else dstReg when (F1DECODED(3)='1' AND aluUsed = '1'  AND F0 = '1' ); --Rdst and NO ALU operaion
            

            

            
        ------------------------------------------------------------------------------------------------------------------------
        -- F2 Decode

            -- Enable write Values to BUS A in Registers In Case of (PCout or SPout or Rout)

                    regSrcEnA <= '1' when ( F2DECODED(1)='1' OR F2DECODED(2)='1' OR F2DECODED(3)='1')
                    else '0';

                    -- Detect Which register will write from BUS A
                        regSrcA <= "111" when F2DECODED(1) = '1' --PCout 

                        else "110" when F2DECODED(2) = '1' --SPout
            
                        else srcReg when (F2DECODED(3) = '1' AND F0 = '0' ) --Rsrc(out)

                        else dstReg when (F2DECODED(3) = '1' AND F0 = '1' ); --Rdst(out)
        
            -- Enable write Values in Special Registers In Case of (MDRout)

                     specialRegSrcEnA <= '1' when  F2DECODED(4)='1' 
                     else '0';
                    
                     specialRegSrcA <= '1' when F2DECODED(4)='1' ;


            clkEn <= NOT F2DECODED(5);
        ------------------------------------------------------------------------------------------------------------------------
        -- F3 Decode
            specialRegDstEnA <= (F3DECODED(1) OR F3DECODED(3)); -- MARinA OR MDRinA

            specialRegDstEnB <= (F3DECODED(2) OR F3DECODED(4)); -- MARinB OR MDRinB

            specialRegDstA <= F3DECODED(3); -- 0 for MARinA, 1 for MDRinA

            specialRegDstB <= F3DECODED(4); -- 0 for MARinB, 1 for MDRinB

            IRRegEn <= F3DECODED(5);

            IRAddressOut <= F3DECODED(6);

            -- checkFlagReg <= F3DECODED(7);

        ------------------------------------------------------------------------------------------------------------------------
        -- F4 Decode
            adderMap: entity work.nAdder generic map(5) PORT MAP(OPCODE,NEXTOPCODE,'0',adderOut,adderCarryOut);  

            aluOperation <= "01001" when F4DECODED(1) = '1'
            else "01010" when  F4DECODED(2) = '1'
            else "00001" when  F4DECODED(3) = '1'
            else adderOut when OPCODE="01001"
            else OPCODE;

            flagRegEn <= '1' when F4DECODED(4) = '1'
            else '0';

            flagRegOut <= F4DECODED(5);

            flagRegDstEnA <= F4DECODED(6);

        ------------------------------------------------------------------------------------------------------------------------       
        -- F5 Decode
            endInstruction <= F5DECODED(1);
            tempEn <= F5DECODED(2);
            tempOut <= F5DECODED(3);

        ------------------------------------------------------------------------------------------------------------------------

        -- F6 Decode
            readEn <= F6DECODED(1);
            writeEn <= F6DECODED(2);
            yEn <= F6DECODED(3);

        ------------------------------------------------------------------------------------------------------------------------
        -- F7 Decode


----------------------------------


  END aControlWordDecoder;