library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;






entity SimpleALU is
    port(
        A      : in  std_logic_vector(7 downto 0);
        B      : in  std_logic_vector(7 downto 0);
        ALU_Op : in  std_logic_vector(2 downto 0); -- Operation selector
        Result : out std_logic_vector(7 downto 0);
        Zero   : out std_logic                  -- Flag for result is zero
    );
	function to_std_Logic(L: BOOLEAN) return std_ulogic is
	begin
		if L then
			return('1');
		else
			return('0');
		end if;				 
	end function to_std_Logic;
									
	
end SimpleALU;



architecture Behavioral of SimpleALU is
begin
    process(A, B, ALU_Op)
    begin
        case ALU_Op is
            when "000" =>  -- Addition
				Result <= std_logic_vector(unsigned(A) + unsigned(B));
				Zero <= to_std_logic(std_logic_vector(unsigned(A) + unsigned(B)) = "00000000");
            when "001" =>  -- Subtraction
				Result <= std_logic_vector(unsigned(A) - unsigned(B));
				Zero <= to_std_logic(A = B);
            when "010" =>  -- AND
				Result <= A and B;
				Zero <= to_std_logic((A and B) = "00000000");
            when "011" =>  -- OR
				Result <= A or B;
				Zero <= to_std_logic((A or B) = "00000000");
            when "100" =>  -- NOT
				Result <= not A;
				Zero <= to_std_logic((not A) = "00000000");
            when "111" => -- A
				Result <= A;
				Zero <= to_std_logic(A = "00000000");
			when others =>
				Result <= (others => '0');  -- Default case
				Zero <= '0';
        end case;
        			   
    end process;
end Behavioral;
