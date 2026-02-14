library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PS2_RX is
    Port ( 
        clk        : in  STD_LOGIC; -- System Clock (50MHz)
        ps2_clk    : in  STD_LOGIC; -- Keyboard Clock
        ps2_data   : in  STD_LOGIC; -- Keyboard Data
        rx_data    : out STD_LOGIC_VECTOR(7 downto 0);
        rx_done    : out STD_LOGIC
    );
end PS2_RX;

architecture Behavioral of PS2_RX is
    -- Double sync for PS2 clock
    signal ps2_clk_reg  : std_logic_vector(1 downto 0) := "11";
    signal ps2_clk_fall : std_logic;
    
    -- Shift register for 11-bit frame
    signal frame_reg    : std_logic_vector(10 downto 0) := (others => '1');
    signal bit_count    : integer range 0 to 11 := 0;

begin

    -- Synchronize PS2 Clock and Detect Falling Edge
    process(clk)
    begin
        if rising_edge(clk) then
            ps2_clk_reg <= ps2_clk_reg(0) & ps2_clk;
        end if;
    end process;
    
    -- Falling Edge: High (Old) -> Low (New)
    ps2_clk_fall <= '1' when (ps2_clk_reg = "10") else '0';

    -- Capture Data on Falling Edge of PS2 Clock
    process(clk)
    begin
        if rising_edge(clk) then
            rx_done <= '0';
            
            if ps2_clk_fall = '1' then
                frame_reg <= ps2_data & frame_reg(10 downto 1); -- Shift Right
                bit_count <= bit_count + 1;
                
                if bit_count = 10 then -- Receive 11 bits (0 to 10)
                    bit_count <= 0;
                    rx_done <= '1';
                    rx_data <= frame_reg(9 downto 2); -- Extract 8 data bits (skip start bit at index 0)
                end if;
            end if;
        end if;
    end process;

end Behavioral;
