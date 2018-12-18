LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


entity romModule is
	generic(n:integer :=16);
	port(clk,rst,en,C,Z: in std_logic; --only need carry and Z flag for branching
        ir: in std_logic_vector(n-1 downto 0);
        rom_out: out std_logic_vector(23 downto 0));
end romModule;


architecture rom of romModule is
    component reg2 is
        generic(n:integer :=6);
        port(clk,rst,en: in std_logic;
            d: in std_logic_vector(n-1 downto 0);
            q: out std_logic_vector(n-1 downto 0));
    end component;

    component rom IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic; --set when read op
		address : IN  std_logic_vector(5 DOWNTO 0);
		dataout,dataout2  : OUT std_logic_vector(23 DOWNTO 0));
    END component rom;

    signal addr: std_logic_vector(5 downto 0);
    signal rom_o: std_logic_vector(23 downto 0);
    signal address_field: std_logic_vector(5 downto 0);
    signal oring: std_logic_vector(1 downto 0);
    signal opcode: std_logic_vector(3 downto 0);
    signal add_mode_src: std_logic_vector(2 downto 0);
    signal add_mode_dst: std_logic_vector(2 downto 0);
    signal op_type: std_logic_vector(3 downto 0);

    begin

        ro:rom port map(clk,en,addr,rom_o,rom_out);
        mar: reg2 port map(clk,rst,en,address_field,addr);
        oring<= rom_o(7 downto 6);
        -- rom_out<=rom_o;
        opcode<=ir(15 downto 12);
        add_mode_src<=ir(11 downto 9);
        add_mode_dst<=ir(5 downto 3);
        op_type<=ir(11 downto 8);

        address_field<=rom_o(5)&"01"&add_mode_dst when opcode="1001" and oring="01" else
        rom_o(5)&"10111" when opcode="1010" and oring="01" else
        rom_o(5)&"11"&op_type(2 downto 0) when opcode="1011" and oring="01" else
        rom_o(5)&"00"&add_mode_src when oring="01" else
        "110000" when oring="10" and opcode="1000" and add_mode_dst="000" else 
        rom_o(5 downto 3)&add_mode_dst when oring="10" else
            rom_o(5 downto 2)&"01" when oring="11" and opcode="1001" else
                rom_o(5 downto 2)&"10" when oring="11" and opcode="1000" else
                rom_o(5 downto 2)&"00" when oring="11" else   
                (others=>'0') when rom_o(17 downto 15)="111" and ((op_type="0001"and Z='0') or (op_type="0010"and Z='1') or (op_type="0011" and C='1') or (op_type="0100" and Z='0' and C='1') or (op_type="0101" and C='0') or(op_type="0110"and C='0' and Z='0') )  --branch condition not met  
                else 
                rom_o(5 downto 0);






 
end rom;
    