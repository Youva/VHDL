library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.sha256_pkg.all;

entity sha256_tb is
    -- Testbench has no ports
end entity sha256_tb;

architecture behavior of sha256_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component sha256
        generic(
            RESET_VALUE : std_logic := '0'
        );
        port(
            clk : in std_logic;
            rst : in std_logic;
            data_ready : in std_logic;
            n_blocks : in natural;
            msg_block_in : in std_logic_vector(0 to (16 * WORD_SIZE)-1);
            finished : out std_logic;
            data_out : out std_logic_vector((WORD_SIZE * 8)-1 downto 0)
        );
    end component;

    -- Constants
    constant WORD_SIZE : natural := 32; -- Adjust WORD_SIZE as needed

    -- Inputs
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal data_ready : std_logic := '0';
    signal n_blocks : natural := 0;
    signal msg_block_in : std_logic_vector(0 to (16 * WORD_SIZE)-1) := (others => '0');

    -- Outputs
    signal finished : std_logic;
    signal data_out : std_logic_vector((WORD_SIZE * 8)-1 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: sha256
        generic map (
            RESET_VALUE => '0'
        )
        port map (
            clk => clk,
            rst => rst,
            data_ready => data_ready,
            n_blocks => n_blocks,
            msg_block_in => msg_block_in,
            finished => finished,
            data_out => data_out
        );

    -- Clk
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin 
					
		-- Reset
        rst <= '1';
        wait for 10 ns;
        rst <= '0';

		
		-- Test case
        data_ready <= '1';
        n_blocks <= 1;
        -- Message abc
		msg_block_in <= x"61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";	
		
		if finished = '1' then
			assert data_out = x"BA7816BF8F01CFEA4140DE5DAE2223B00361A396177A9CB410FF61F20015AD"
			report "Hash incorrect pour la valeur abc"
			severity error;
		else	   
			report "Hash not finished"
			severity error;
		end if;		
		
		
    end process;

end architecture;
