					 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimpleALU_tb is
    -- Testbench has no ports
end SimpleALU_tb;

architecture Behavioral of SimpleALU_tb is
    -- Component declaration for the SimpleALU
    component SimpleALU
        port(
            A      : in  std_logic_vector(7 downto 0);
            B      : in  std_logic_vector(7 downto 0);
            ALU_Op : in  std_logic_vector(2 downto 0);
            Result : out std_logic_vector(7 downto 0);
            Zero   : out std_logic
        );
    end component;
    
    -- Signals for interfacing with the SimpleALU
    signal A      : std_logic_vector(7 downto 0);
    signal B      : std_logic_vector(7 downto 0);
    signal ALU_Op : std_logic_vector(2 downto 0);
    signal Result : std_logic_vector(7 downto 0);
    signal Zero   : std_logic;
begin
    -- Instance of the SimpleALU
    uut: SimpleALU port map (
        A      => A,
        B      => B,
        ALU_Op => ALU_Op,
        Result => Result,
        Zero   => Zero
    );

    -- Test process
    test_process: process
    begin
        -- Test case 1: Addition
        A <= "00000010";  -- 2
        B <= "00000011";  -- 3
        ALU_Op <= "000";  -- Addition operation
		wait for 10 ns;									
        assert Result = "00000101" report "Addition: " & to_hstring(Result);
	    
		
        -- Test case 2: Subtraction
        A <= "00000100";  -- 4
        B <= "00000001";  -- 1
        ALU_Op <= "001";  -- Subtraction operation
        wait for 10 ns;
        assert Result = "00000011" report "Soustraction:"& to_hstring(Result);    
		
        -- Test case 3: AND
        A <= "00001111";  -- 15
        B <= "11110000";  -- 240
        ALU_Op <= "010";  -- AND operation
		wait for 10 ns;												  
        assert Result = "00000000" report "AND:"& to_hstring(Result);
        
		
        -- Test case 4: OR
        A <= "00001111";  -- 15
        B <= "11110000";  -- 240
        ALU_Op <= "011";  -- OR operation
		wait for 10 ns;
        assert Result = "11111111" report "OR:"& to_hstring(Result);
        
		
        -- Test case 5: NOT
        A <= "11111111";  -- 255
        B <= "11111111";  -- Not used
        ALU_Op <= "100";  -- NOT operation
		wait for 10 ns;
        assert Result = "00000000" report "NOT:"& to_hstring(Result);
        
		-- Test case 6: A
        A <= "11111111";  -- 255
        B <= "00000000";  -- Not used
        ALU_Op <= "111";  -- Return A
		wait for 10 ns;
        assert Result = "11111111" report "A="& to_hstring(Result);
        
		
        -- End simulation
        wait;
    end process;
end Behavioral;
