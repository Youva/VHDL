library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimpleMemory is
    generic (
        ADDR_WIDTH : integer := 8;  -- Address width, determines memory depth
        DATA_WIDTH : integer := 8   -- Data width, determines size of each word
    );
    port (
        clk       : in  std_logic;
        addr      : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        data_in   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        write_en  : in  std_logic; -- Write enable signal ('1' enables write operation)
        data_out  : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end SimpleMemory;

architecture Behavioral of SimpleMemory is
    type memory_type is array (2**ADDR_WIDTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal memory : memory_type;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if write_en = '1' then
                memory(to_integer(unsigned(addr))) <= data_in;  -- Write operation
            else
                data_out <= memory(to_integer(unsigned(addr))); -- Read operation
            end if;
        end if;
    end process;
end Behavioral;
