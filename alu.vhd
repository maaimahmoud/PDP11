LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.mine;
USE IEEE.math_real.all;

entity ALU is
    GENERIC (wordSize : integer := 4);
  port(
      A, B:in std_logic_vector(wordSize-1 downto 0);
      selectionLines:in std_logic_vector(4 downto 0);
      clk:in std_logic;
      resetFlag: in std_logic;
      busB :out std_logic_vector(wordSize-1 downto 0)
    );

end entity ALU;


architecture aALU of ALU is

COMPONENT reg IS
    GENERIC (m : integer := 32);
PORT(
    T : IN std_logic_vector(m-1  DOWNTO 0);
    en,rst,clk: IN std_logic ; 
    myBus : INOUT std_logic_vector(m-1 DOWNTO 0)
  );

END COMPONENT;


COMPONENT twocomp IS
  GENERIC (n : integer := 16);
    port(
        a:in std_logic_vector(n-1 downto 0);
        f:out std_logic_vector(n-1 downto 0)
      );
  END COMPONENT;

  
  COMPONENT nAdder IS
          GENERIC (n : integer := 16);
        PORT(
          a,b : IN std_logic_vector(n-1  DOWNTO 0);
          carryIn : IN std_logic;
          sum : OUT std_logic_vector(n-1 DOWNTO 0);
          carryOut : OUT std_logic
        );
  END COMPONENT;

  COMPONENT MUX IS
        GENERIC (inputNum : integer := 2 ; wordSize : integer := 16); -- Number of inputs to MUX and word Size of each  
    PORT(
            inputs : IN  mine.genericArrayofVector16bit(0 to inputNum-1);
            selectionLines : IN std_logic_vector (integer(ceil(log2(real(inputNum)))) downto 0);
            output : OUT std_logic_vector(wordSize-1 DOWNTO 0)
        );
  END COMPONENT;


SIGNAL flagRegT:std_logic_vector( 4 downto 0) ;
SIGNAL flagRegOut:std_logic_vector(4 downto 0) ;
SIGNAL flagRegEn: std_logic ;

-- Flag Register Bits
SIGNAL N: std_logic:= '0' ;
SIGNAL O: std_logic:= '0' ;
SIGNAL Z: std_logic:= '0' ;
SIGNAL C: std_logic:= '0' ;
SIGNAL P: std_logic:= '0' ;


SIGNAL output: std_logic_vector(wordSize-1 downto 0);

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


BEGIN

    notA <= NOT A;
    notB <= NOT B;
    AorB <= A OR B;
    AandB <= A AND B;
    AxnorB <= A XNOR B;

    -- barMapA: twocomp generic map(wordSize) port map (A,Abar);

    barMapB: twocomp generic map(wordSize) port map (B,Bbar);

    muxMapA : MUX GENERIC MAP(20,wordSize) PORT MAP (inputs(0)=>A, -- A
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
                                                    inputs(13)=>A,-- SHR
                                                    inputs(14)=>A,-- ROR
                                                    inputs(15)=>A, -- RRC
                                                    inputs(16)=>A, -- ASR
                                                    inputs(17)=>A, -- LSL
                                                    inputs(18)=>A, -- ROL
                                                    inputs(19)=>A, -- ROC
                                                    selectionLines=>selectionLines,
                                                    output=>inA);

    muxMapB : MUX GENERIC MAP(20,wordSize) PORT MAP (inputs(0)=>x"0000", -- A
                                                    inputs(1)=>B, -- A+B
                                                    inputs(2)=>B, -- A+B+carry
                                                    inputs(3)=>Bbar, -- A-B
                                                    inputs(4)=>notB, -- A-B-carry
                                                    inputs(5)=>B, -- A AND B
                                                    inputs(6)=>B, -- A OR B
                                                    inputs(7)=>B, -- A XNOR B
                                                    inputs(8)=>Bbar, -- A-B
                                                    inputs(9)=>x"0000", -- A + 1
                                                    inputs(10)=>x"FFFF", -- A - 1
                                                    inputs(11)=>B, -- 0
                                                    inputs(12)=>B, -- NOT A
                                                    inputs(13)=>B,-- SHR
                                                    inputs(14)=>B,-- ROR
                                                    inputs(15)=>B, -- RRC
                                                    inputs(16)=>B, -- ASR
                                                    inputs(17)=>B, -- LSL
                                                    inputs(18)=>B, -- ROL
                                                    inputs(19)=>B, -- ROC
                                                    selectionLines => selectionLines,
                                                    output => inB );

    inC <= flagRegOut(3) when selectionLines = "00010" 
    else (not(flagRegOut(3))) when selectionLines = "00100"
    else '0';

    adderMap: nAdder generic map(wordSize) PORT MAP(inA,inB,inC,adderOut,adderCarryOut);  

    muxMap : MUX GENERIC MAP(20,wordSize) PORT MAP (inputs(0)=> A, -- A
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
                                                    inputs(13)=>A,-- SHR
                                                    inputs(14)=>A,-- ROR
                                                    inputs(15)=>A, -- RRC
                                                    inputs(16)=>A, -- ASR
                                                    inputs(17)=>A, -- LSL
                                                    inputs(18)=>A, -- ROL
                                                    inputs(19)=>A, -- ROC
                                                    selectionLines=>selectionLines,
                                                    output=>output);
                                                  
  busB <= output;


  Z <= '1' when output = x"0000"
  else '0';

  N <= '1' when output(wordSize-1) = '1'
  else '0';

  C <= adderCarryOut;

  P <= '1' when output(0)= '0'
  else '0';

  O <= '1' when (inA(wordSize-1)='0' and inB(wordSize-1)='0' and adderOut(wordSize-1)='1') or (inA(wordSize-1)='1' and inB(wordSize-1)='1' and adderOut(wordSize-1)='0' )
  else '0';


  -- flagRegT <= (wordsize-1=> N , wordsize-2=> O, wordsize-3=> Z,wordsize-4=> C, wordsize-5=> P);

  flagRegT(0) <= N;
  flagRegT(1) <= O;
  flagRegT(2) <= Z;
  flagRegT(3) <= C;
  flagRegT(4) <= P;

  flagRegEn <= '1';

  flagRegMap: reg GENERIC MAP(5) PORT MAP(flagRegT,flagRegEn,resetFlag,clk,flagRegOut );



end architecture;