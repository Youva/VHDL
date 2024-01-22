library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity control_unit is
    Port (
		clk : in std_logic;
		rst : in std_logic;
        start : in std_logic; -- Signal to start the operation
        instruction : in std_logic_vector(31 downto 0); -- 4-byte instruction
        alu_result : out std_logic_vector(31 downto 0) -- Result of ALU operation
	);
end control_unit;

architecture Behavioral of control_unit is
	type control_state is
      (RESET, READ_INSTRUCTION, FETCH_A, FETCH_B, ALU, STORE);

	signal operand_a, operand_b : std_logic_vector(31 downto 0);
    signal result : std_logic_vector(31 downto 0);
    signal opcode : std_logic_vector(2 downto 0);
    signal addr_a, addr_b, addr_result : std_logic_vector(7 downto 0);
	signal state : control_state;
	signal memory_addr_in : std_logic_vector(7 downto 0);
	signal memory_data_out : std_logic_vector(31 downto 0);
	signal data_a : std_logic_vector(31 downto 0);
	signal data_b : std_logic_vector(31 downto 0);
	signal write_enable : std_logic;

begin
    -- Instantiate ALU
    alu_inst: entity work.simple_alu
        port map (
            operand_a => operand_a,
            operand_b => operand_b,
            opcode => opcode,
            result => result
        );

    -- Instantiate memory
    memory_inst: entity work.simple_memory
        port map (
            clk => clk,
            addr => memory_addr_in, -- This needs to change based on the operation phase
            data_in => result,
            write_enable => write_enable, -- Control this based on the operation phase
            data_out => memory_data_out
        );

    process(clk, rst)
    begin
        if rst = '1' then
			state <= RESET;
		elsif rising_edge(clk) then
			case state is
				when RESET =>
				if start = '1' then
				state <= READ_INSTRUCTION;
				end if;
				when READ_INSTRUCTION =>
				state <= FETCH_A;
				when FETCH_A =>
				state <= FETCH_B;
				when FETCH_B =>
				state <= ALU;
				when ALU =>
				state <= STORE;
				when STORE =>
				state <= RESET;
				when others =>
				state <= RESET;
			end case;
		end if;
    end process;
	
	-- state logic
	process(state)
	begin
		case state is
			when RESET =>
			write_enable <= '0';
			operand_a <= (others => '0');
			operand_b <= (others => '0');
			memory_addr_in <= (others => '0');
			when READ_INSTRUCTION =>
			opcode <= instruction(31 downto 29);
            addr_a <= instruction(23 downto 16);
            addr_b <= instruction(15 downto 8);
            addr_result <= instruction(7 downto 0);
			memory_addr_in <= instruction(23 downto 16);
			when FETCH_A =>
			operand_a <= memory_data_out;
			memory_addr_in <= addr_b;
			when FETCH_B =>
			operand_b <= memory_data_out;
			memory_addr_in <= addr_result;
			when ALU =>
			write_enable <= '1';
			when others =>
			end case;
	end process;
			
	
    alu_result <= result; -- Output the result
end Behavioral;
