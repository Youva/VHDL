library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  

entity simple_alu is
    Port ( 
        operand_a : in std_logic_vector(31 downto 0);
        operand_b : in std_logic_vector(31 downto 0);
        opcode : in std_logic_vector(2 downto 0); -- 3 bits for opcode
        result : out std_logic_vector(31 downto 0)
    ); 
	
	
end simple_alu;

architecture Behavioral of simple_alu is
begin
    process(operand_a, operand_b, opcode)
    begin
        case opcode is
            when "000" => -- Add
                result <= std_logic_vector(signed(operand_a) + signed(operand_b));
            when "001" => -- Subtract
                result <= std_logic_vector(signed(operand_a) - signed(operand_b));
            when "010" => -- Bitwise AND
                result <= operand_a and operand_b;
            when "011" => -- Bitwise OR
                result <= operand_a or operand_b;
            when "100" => -- Bitwise XOR
                result <= operand_a xor operand_b;
            when others => -- Default or invalid opcode
                result <= (others => '0'); -- Default to 0
        end case;
    end process;
end Behavioral;
