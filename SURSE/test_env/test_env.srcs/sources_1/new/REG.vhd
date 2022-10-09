
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

entity REG is
 Port ( clk :in std_logic;
        regWrite: in std_logic;
        ra1: in std_logic_vector(3 downto 0);
        ra2: in std_logic_vector(3 downto 0);
        wa :in std_logic_vector(3 downto 0);
        wd :in std_logic_vector(15 downto 0);
        rd1: out std_logic_vector(15 downto 0);
        rd2: out std_logic_vector(15 downto 0));
end REG;

architecture Behavioral of REG is

type registerFile is array(0 to 255) of std_logic_vector(15 downto 0);
signal reg_file : registerFile:=(   
    x"0001",
    x"0010",
    x"0011",
    x"0021",
    x"0123",
    x"0333",
    others =>x"0000"); 
   
begin

process(clk)
begin
    if(rising_edge(clk))then
        if(regWrite='1')then
            reg_file(conv_integer(wa))<=wd;
        end if;
    end if;
      rd1<=reg_file(conv_integer((ra1)));
      rd2<=reg_file(conv_integer((ra2)));
end process;

end Behavioral;
