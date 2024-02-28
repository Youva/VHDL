					 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimpleMemory_tb is
    -- Testbench has no ports
end SimpleMemory_tb;

architecture Behavioral of SimpleMemory_tb is
    -- Component declaration for the SimpleMemory
    component SimpleMemory
        generic (
            ADDR_WIDTH : integer := 8;
            DATA_WIDTH : integer := 8
        );
        port (
            clk       : in std_logic;
            addr      : in std_logic_vector(ADDR_WIDTH-1 downto 0);
            data_in   : in std_logic_vector(DATA_WIDTH-1 downto 0);
            write_en  : in std_logic;
            data_out  : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    -- Signal declarations for interfacing with the SimpleMemory
    signal clk       : std_logic := '0';
    signal addr      : std_logic_vector(7 downto 0) := (others => '0');
    signal data_in   : std_logic_vector(7 downto 0) := (others => '0');
    signal write_en  : std_logic := '0';
    signal data_out  : std_logic_vector(7 downto 0);

begin
    -- Instance of the SimpleMemory
    uut: SimpleMemory
        port map (
            clk       => clk,
            addr      => addr,
            data_in   => data_in,
            write_en  => write_en,
            data_out  => data_out
        );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Test process
    test_process: process
    begin
        -- Write test
        write_en <= '1';  -- Enable write operation
        for i in 0 to 255 loop  -- Assuming a 256-deep memory
            addr <= std_logic_vector(to_unsigned(i, 8));  -- Set address
            data_in <= std_logic_vector(to_unsigned(i, 8));  -- Write data (same as address for simplicity)
            wait for 20 ns;  -- Wait for one clock cycle
        end loop;
        
        write_en <= '0';  -- Disable write for read operations
        wait for 20 ns;  -- Wait for one clock cycle to ensure separation between write and read operations
        
        -- Read and check test
        for i in 0 to 255 loop
            addr <= std_logic_vector(to_unsigned(i, 8));  -- Set address
            assert data_out = addr report to_hstring(addr) & "," & to_hstring(data_out); -- Data_out is checked manually or by adding assert statements here
            wait for 20 ns;  -- Wait for one clock cycle
        end loop;

        -- End simulation
        wait;
    end process;
end Behavioral;
