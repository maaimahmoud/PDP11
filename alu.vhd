LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.mine;
USE IEEE.math_real.all;

entity ALU is
    GENERIC (wordSize : integer := 16);
  port(
      B: in std_logic_vector(wordSize-1 downto 0);
      A: INOUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
      selectionLines:in std_logic_vector(4 downto 0);
      clk:in std_logic;
      flagRegEn,flagRegSrc,flagRegDstEnA,resetFlag : in STD_LOGIC;
      flagRegValue : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
      busB :out std_logic_vector(wordSize-1 downto 0)
    );

end entity ALU;


architecture aALU of ALU is


    SIGNAL flagRegT:std_logic_vector( 4 downto 0) ;
    SIGNAL flagRegFinalT:std_logic_vector( 4 downto 0) ;
    SIGNAL flagRegOut:std_logic_vector(4 downto 0) ;

    -- SIGNAL flagRegEn: std_logic ;

    -- Flag Register Bits
    SIGNAL N: std_logic:= '0' ;
    SIGNAL O: std_logic:= '0' ;
    SIGNAL Z: std_logic:= '0' ;
    SIGNAL C: std_logic:= '0' ;
    SIGNAL P: std_logic:= '0' ;


    SIGNAL aluOutput: std_logic_vector(wordSize-1 downto 0);

    -- Adder Input
    SIGNAL inA:std_logic_vector( wordSize-1 downto 0) ;
    SIGNAL inB:std_logic_vector( wordSize-1 downto 0) ;
    SIGNAL Bbar:std_logic_vector( wordSize-1 downto 0) ;
    SIGNAL Abar:std_logic_vector( wordSize-1 downto 0) ;
    SIGNAL inC:std_logic ;

    SIGNAL adderOut:std_logic_vector ( wordSize-1 downto 0);
    SIGNAL adderCarryOut:std_logic ;

    SIGNAL notA:std_logic_vector( wordSize-1 downto 0) ;
    SIGNAL notB:std_logic_vector( wordSize-1 downto 0) ;

    SIGNAL AorB:std_logic_vector( wordSize-1 downto 0) ;
    SIGNAL AandB:std_logic_vector( wordSize-1 downto 0) ;
    SIGNAL AxnorB:std_logic_vector( wordSize-1 downto 0) ;

    SIGNAL SHROUT : STD_LOGIC_VECTOR(wordSize-1 downto 0);
    SIGNAL ROROUT : STD_LOGIC_VECTOR(wordSize-1 downto 0);
    SIGNAL RRCOUT : STD_LOGIC_VECTOR(wordSize-1 downto 0);
    SIGNAL ASROUT : STD_LOGIC_VECTOR(wordSize-1 downto 0);
    SIGNAL LSLOUT : STD_LOGIC_VECTOR(wordSize-1 downto 0);
    SIGNAL ROLOUT : STD_LOGIC_VECTOR(wordSize-1 downto 0);
    SIGNAL ROCOUT : STD_LOGIC_VECTOR(wordSize-1 downto 0);


BEGIN

    notA <= NOT A;
    notB <= NOT B;
    AorB <= A OR B;
    AandB <= A AND B;
    AxnorB <= A XNOR B;

    SHROUT <= '0' & A(wordSize-1 downto 1);
    ROROUT <= A(0) & A(wordSize-1 downto 1);
    RRCOUT <= flagRegT(3) & A (wordSize-1 downto 1);
    ASROUT <= A(wordSize-1) & A(wordSize-1 downto 1);
    LSLOUT <= A(wordSize-2 downto 0) & '0';
    ROLOUT <= A(wordSize-2 downto 0) & A(wordSize-1);
    ROCOUT <= A(wordSize-2 downto 0) & flagRegT(3) ;

    -- barMapA: twocomp generic map(wordSize) port map (A,Abar);

    barMapB: entity work.twocomp generic map(wordSize) port map (B,Bbar);

    muxMapA : entity work.MUX GENERIC MAP(20,wordSize) PORT MAP (inputs(0)=>A, -- A
                                                    inputs(1)=>A, -- A+B
                                                    inputs(2)=>A, -- A+B+carry
                                                    inputs(3)=>A, -- A-B
                                                    inputs(4)=>A, -- A-B-carry
                                                    inputs(5)=>A, -- A AND B
                                                    inputs(6)=>A, -- A OR B
                                                    inputs(7)=>A, -- A XNOR B
                                                    inputs(8)=>A, -- A-B
                                                    inputs(9)=>A, -- A + 1
                                                    inputs(10)=>A, -- A - 1
                                                    inputs(11)=>A, -- 0
                                                    inputs(12)=>A, -- NOT A
                                                    inputs(13)=>A,-- SHROUT
                                                    inputs(14)=>A,-- ROROUT
                                                    inputs(15)=>A, -- RRCOUT
                                                    inputs(16)=>A, -- ASROUT
                                                    inputs(17)=>A, -- LSLOUT
                                                    inputs(18)=>A, -- ROLOUT
                                                    inputs(19)=>A, -- ROCOUT
                                                    selectionLines=>selectionLines,
                                                    output=>inA);

    muxMapB : entity work.MUX GENERIC MAP(20,wordSize) PORT MAP (inputs(0)=>x"0000", -- A
                                                    inputs(1)=>B, -- A+B
                                                    inputs(2)=>B, -- A+B+carry
                                                    inputs(3)=>Bbar, -- A-B
                                                    inputs(4)=>notB, -- A-B-carry
                                                    inputs(5)=>B, -- A AND B
                                                    inputs(6)=>B, -- A OR B
                                                    inputs(7)=>B, -- A XNOR B
                                                    inputs(8)=>Bbar, -- A-B
                                                    inputs(9)=>x"0001", -- A + 1
                                                    inputs(10)=>x"FFFF", -- A - 1
                                                    inputs(11)=>B, -- 0
                                                    inputs(12)=>B, -- NOT A
                                                    inputs(13)=>B,-- SHROUT
                                                    inputs(14)=>B,-- ROROUT
                                                    inputs(15)=>B, -- RRCOUT
                                                    inputs(16)=>B, -- ASROUT
                                                    inputs(17)=>B, -- LSLOUT
                                                    inputs(18)=>B, -- ROLOUT
                                                    inputs(19)=>B, -- ROCOUT
                                                    selectionLines => selectionLines,
                                                    output => inB );

    inC <= flagRegOut(3) when selectionLines = "00010" 
    else (not(flagRegOut(3))) when selectionLines = "00100"
    else '0';

    adderMap: entity work.nAdder generic map(wordSize) PORT MAP(inA,inB,inC,adderOut,adderCarryOut);  

    muxMap : entity work.MUX GENERIC MAP(20,wordSize) PORT MAP (inputs(0)=> B, -- A
                                                    inputs(1)=>adderOut, -- A+B
                                                    inputs(2)=>adderOut, -- A+B+carry
                                                    inputs(3)=>adderOut, -- A-B
                                                    inputs(4)=>adderOut, -- A-B-carry
                                                    inputs(5)=>AandB, -- A AND B
                                                    inputs(6)=>AorB, -- A OR B
                                                    inputs(7)=>AxnorB, -- A XNOR B
                                                    inputs(8)=>adderOut, -- A-B
                                                    inputs(9)=>adderOut, -- A + 1
                                                    inputs(10)=>adderOut, -- A - 1
                                                    inputs(11)=>x"0000", -- 0
                                                    inputs(12)=>notA, -- NOT A
                                                    inputs(13)=>SHROUT,-- SHROUT
                                                    inputs(14)=>ROROUT,-- ROROUT
                                                    inputs(15)=>RRCOUT, -- RRCOUT
                                                    inputs(16)=>ASROUT, -- ASROUT
                                                    inputs(17)=>LSLOUT, -- LSLOUT
                                                    inputs(18)=>ROLOUT, -- ROLOUT
                                                    inputs(19)=>ROCOUT, -- ROCOUT
                                                    selectionLines=>selectionLines,
                                                    output=>aluOutput);
                                                  
  busB <= aluOutput;

  Z <= '1' when aluOutput = x"0000"
  else '0';

  N <= '1' when aluOutput(wordSize-1) = '1'
  else '0';

  C <= '1' when ( adderCarryOut = '1' OR (inB(wordSize-1) ='1' AND adderOut(wordSize-1) = '1')  OR (inB(wordSize-1) ='0' AND adderOut(wordSize-1) = '1') )
  else '0';

  P <= '1' when aluOutput(0)= '0'
  else '0';

  O <= '1' when (inA(wordSize-1)='0' and inB(wordSize-1)='0' and adderOut(wordSize-1)='1') or (inA(wordSize-1)='1' and inB(wordSize-1)='1' and adderOut(wordSize-1)='0' )
  else '0';


  -- flagRegT <= (wordsize-1=> N , wordsize-2=> O, wordsize-3=> Z,wordsize-4=> C, wordsize-5=> P);

  flagRegT(0) <= N;
  flagRegT(1) <= O;
  flagRegT(2) <= Z;
  flagRegT(3) <= C;
  flagRegT(4) <= P;

--   flagRegEn <= '1';

    flagRegFinalT <= B when flagRegDstEnA='1'
    else flagRegT;

  flagRegMap: entity work.reg GENERIC MAP(5) PORT MAP(flagRegFinalT,flagRegEn,resetFlag,clk,flagRegOut );

    A <= flagRegOut when flagRegSrc = '1'
    else (OTHERS=>'Z');

    flagRegValue <= flagRegOut;

end architecture;