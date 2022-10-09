----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2022 05:12:59 PM
-- Design Name: 
-- Module Name: instrF - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instrF is
  Port ( 
  rst :  in std_logic;
  clk : in std_logic;
  en : in std_logic;
  br_addr : in std_logic_vector(15 downto 0);
  PCSrc : in std_logic;
  j_addr : in std_logic_vector(15 downto 0);
  jump : in std_logic;
  instr : out std_logic_vector(15 downto 0);
  pc_p_1 : out std_logic_vector(15 downto 0)
  );
end instrF;

architecture Behavioral of instrF is

signal out_m1 : std_logic_vector(15 downto 0);
signal out_m2 : std_logic_vector(15 downto 0);
signal q : std_logic_vector(15 downto 0);
signal d : std_logic_vector(15 downto 0);
signal s : std_logic_vector(15 downto 0);
type tROM is array (0 to 31) of std_logic_vector(15 downto 0);
signal ROM : tROM :=(
-- comenatrii cu ce face pe siruri
--programul are un array cu numerele de la 1 la 20, le parcurge
--shifteaza fiecare element cu 2 pozitii la stanga, aduna 10 la fiecare element
--apoi aduna la rezultat elementul nou
--
B"000_000_000_001_0_011", --X"0013" -- ADD $1, $0, $0 -- INITIALIZEAZA CONTORUL I=0 IN R1
B"101_000_100_0010100", -- X"A214" -- ADDI $4, $0, 20 -- PUNE IN R4 VAL MAX 20
B"000_000_000_010_0_011", --X"0023" -- ADD $2, $0, $0 -- INITIALIZEAZA INDEXUL DIN MEMORIE IN R2
B"000_000_000_101_0_011", --X"0053" -- ADD $5, $0, $0 -- INITIALIZEAZA REZ=0 IN R5
B"110_001_100_0001000", --X"C608" -- BEQ $1, $4, 8 -- LOOP DE LA I LA 20
B"001_010_011_0101000", --X"29A8" -- LW $3 A_ADDR($2) -- IAU DIN MEM DE LA ADRESA IN R2 SI PUN IN R3
B"000_0_011_011_010_000", --X"06D0" -- SLL $3, $3, 2 -- SHIFTEZ LA STANGA CU 2 POZITII CE E IN R3
B"101_011_011_0001010", --X"AD8A" --ADDI $3, $3, 10 -- ADUN LA CE E IN R3 VALOAREA 10
B"010_010_011_0101000", --X"49A8" --SW $3, A_ADDR($2) -- PUN IN MEMORIE LA ADRESA DIN R2 VAL DIN R3
B"000_101_011_101_0_011", --X"1593" -- ADD $5, $5, $3 -- ADUN CE E IN R3 LA REZ CARE E IN R5
B"101_010_010_0000100", --X"A904" -- ADDI $2, $2, 4 -- INDEX LA NOUL ELEMENT
B"101_001_001_0000001", --X"A481" -- ADDI $1, $1, 1 -- I++ LA BUCLA
B"111_0000000000100", --X"E004" -- J BEGIN LOOP -- SAR LA INCEPUTUL BUCLEI
B"010_000_101_1111000", --X"42F8" -- SW $5, REZ_ADDR($0) -- PUN REZ IN MEMORIE DIN R5
others => x"0000");


begin

    process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                q<=x"0000";
                elsif en = '1' then
                q<=out_m2;
            end if;
         end if;
    end process; 
    
    instr <= ROM(conv_integer(q(4 downto 0)));
    
    s <= 1 + q;
    
    process(PCSrc, br_addr, s)
        begin
        if(PCSrc = '0') then
            out_m1 <= s;
        else
            out_m1 <= br_addr;
        end if;
    end process;

    process(jump, j_addr, out_m1)
        begin
        if(jump = '0') then
            out_m2 <= out_m1;
        else
            out_m2 <= j_addr;
        end if;
    end process;

    pc_p_1 <= s;
    
    

end Behavioral;