----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2022 05:12:59 PM
-- Design Name: 
-- Module Name: InstructionFetch - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionFetch is
    Port ( clk: in STD_LOGIC;   -- semnal de ceas pt PC
           rst : in STD_LOGIC;  -- pt a reseta registrul PC la valoarea 0
           en : in STD_LOGIC;   -- valideaza scrierea in PC
           BranchAddress : in STD_LOGIC_VECTOR(15 downto 0); -- adresa de branch
           JumpAddress : in STD_LOGIC_VECTOR(15 downto 0);   -- adresa de jump
           Jump : in STD_LOGIC;  -- semnal de control jump                        
           PCSrc : in STD_LOGIC; -- semnal de control pt branch
           Instruction : out STD_LOGIC_VECTOR(15 downto 0);  -- instructiunea de executat
           PCinc : out STD_LOGIC_VECTOR(15 downto 0));       -- adresa urmatoarei instructiuni
end InstructionFetch;

architecture Behavioral of InstructionFetch is

-- Memorie ROM
type tROM is array (0 to 19) of STD_LOGIC_VECTOR (15 downto 0);
signal ROM : tROM := (
B"000_000_000_001_0_000", --"0010"
B"001_000_100_0001010", --"220A"
B"000_000_000_010_0_000",--"0020"
B"000_000_000_101_0_000",--"0050"
B"011_001_100_0000111",--"6607"
B"010_010_011_0000001",--"4981"
B"001_011_011_0000010",--"2D82"
B"011_010_011_0000001",--"6981"
B"000_101_011_101_0_000",--"15D0"
B"001_010_010_0000001",--"2901"
B"001_001_001_0000001",--"2481"
B"111_0000000000100",--"E004"
B"011_000_101_0001010",--"628A"

others=>X"0000");

signal PCD: STD_LOGIC_VECTOR(15 downto 0);
signal PCQ: STD_LOGIC_VECTOR(15 downto 0);
signal PCplus: STD_LOGIC_VECTOR(15 downto 0);
signal outmux1: STD_LOGIC_VECTOR(15 downto 0);

begin

    process(clk)
    begin
        if (rst = '1') then
            PCQ <= x"0000";
        end if;
        
        if rising_edge(clk) then
            if en = '1' then
                PCQ <= PCD;
            end if;
        end if;
    end process;

    outmux1 <= BranchAddress when PCSrc = '1' else PCplus;
    PCD <= JumpAddress when Jump = '1' else outmux1;
    PCplus <= PCQ + '1';
    PCinc <= PCplus;
    instruction <= ROM(conv_integer(PCQ));
    
end Behavioral;