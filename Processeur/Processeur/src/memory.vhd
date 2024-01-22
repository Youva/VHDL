library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity simple_memory is
    Port (
        clk : in std_logic;
        addr : in std_logic_vector(7 downto 0); -- Address bus (256 locations)
        data_in : in std_logic_vector(31 downto 0); -- Data input
        write_enable : in std_logic; -- Write enable signal
        data_out : out std_logic_vector(31 downto 0) -- Data output
    );
end simple_memory;

architecture Behavioral of simple_memory is
    type memory_type is array (0 to 255) of std_logic_vector(31 downto 0); -- Memory array
    signal memory : memory_type; -- Memory signal
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if write_enable = '1' then
                memory(to_integer(ieee.numeric_std.unsigned(addr))) <= data_in; -- Write operation
            end if;
            data_out <= memory(to_integer(ieee.numeric_std.unsigned(addr))); -- Read operation
        end if;
    end process;
end Behavioral;
