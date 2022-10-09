

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
    Port(WE: in std_logic;
        clk: in std_logic;
        DI: in std_logic_vector(15 downto 0);
        ADDR: in std_logic_vector(3 downto 0);
        DO: out std_logic_vector(15 downto 0));
end RAM;

architecture Behavioral of RAM is

type ram_type is array (0 to 15) of std_logic_vector(15 downto 0);
signal RAM : ram_type := (
    X"0000",
    X"0001",
    X"0002",
    X"0003",
    X"0004",
    X"0005",
    X"0006",
    X"0007",
    others => X"0000");

begin

process(clk)
begin
    if rising_edge(clk) then
            if(WE='1') then
            RAM(conv_integer(ADDR))<= DI;
            DO<=DI;
            else 
              DO<=RAM(conv_integer(ADDR));
            end if;
    end if;
end process;

end Behavioral;