library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debounce is
    Port ( 
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        button  : in  STD_LOGIC;
        result  : out STD_LOGIC
    );
end Debounce;

architecture Behavioral of Debounce is
    signal flipflops   : std_logic_vector(1 downto 0);
    signal counter_set : std_logic;
    signal counter_out : std_logic_vector(15 downto 0) := (others => '0');
begin

    counter_set <= flipflops(0) xor flipflops(1);
    
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '0' then
                flipflops <= "00";
                result <= '0';
            else
                flipflops(0) <= button;
                flipflops(1) <= flipflops(0);
                
                if(counter_set = '1') then
                    counter_out <= (others => '0');
                elsif(counter_out(15) = '0') then
                    counter_out <= std_logic_vector(unsigned(counter_out) + 1);
                else
                    result <= flipflops(1);
                end if;    
            end if;
        end if;
    end process;
end Behavioral;
