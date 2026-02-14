library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Keyboard_Demo is
    Port ( 
        clk      : in  STD_LOGIC;
        ps2_clk  : in  STD_LOGIC; -- PIN_119
        ps2_data : in  STD_LOGIC; -- PIN_120
        seg_out  : out STD_LOGIC_VECTOR(6 downto 0); -- Segments
        sel_out  : out STD_LOGIC_VECTOR(3 downto 0)  -- Digit Select
    );
end Keyboard_Demo;

architecture Behavioral of Keyboard_Demo is

    component PS2_RX is
        Port ( 
            clk        : in  STD_LOGIC;
            ps2_clk    : in  STD_LOGIC;
            ps2_data   : in  STD_LOGIC;
            rx_data    : out STD_LOGIC_VECTOR(7 downto 0);
            rx_done    : out STD_LOGIC
        );
    end component;

    component SevenSegDecoder is
        Port ( 
            hex_in  : in  STD_LOGIC_VECTOR (3 downto 0);
            seg_out : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

    signal rx_byte : std_logic_vector(7 downto 0);
    signal rx_done : std_logic;
    signal current_scancode : std_logic_vector(7 downto 0) := x"00";
    
    -- Multiplexing signals
    signal refresh_counter : unsigned(19 downto 0) := (others => '0');
    signal digit_select    : std_logic_vector(1 downto 0);
    signal hex_to_display  : std_logic_vector(3 downto 0);

begin

    -- PS/2 Receiver
    U_PS2: PS2_RX port map (
        clk      => clk,
        ps2_clk  => ps2_clk,
        ps2_data => ps2_data,
        rx_data  => rx_byte,
        rx_done  => rx_done
    );

    -- Latch Scancode on Done
    process(clk)
    begin
        if rising_edge(clk) then
            if rx_done = '1' then
                current_scancode <= rx_byte;
            end if;
        end if;
    end process;

    -- Display Multiplexing (Show Hex Value of Scancode)
    -- Digit 0 (Right): Lower Nibble
    -- Digit 1 (Left): Upper Nibble
    -- Digits 2,3: OFF
    process(clk)
    begin
        if rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;
    
    digit_select <= std_logic_vector(refresh_counter(19 downto 18));
    
    process(digit_select, current_scancode)
    begin
        case digit_select is
            when "00" => -- Digit 0 (Right)
                hex_to_display <= current_scancode(3 downto 0);
                sel_out        <= "1110"; 
            when "01" => -- Digit 1 (Left of Right)
                hex_to_display <= current_scancode(7 downto 4);
                sel_out        <= "1101"; 
            when others => -- Digits 2,3 OFF
                hex_to_display <= "0000"; -- Doesn't matter, just turn off digit
                sel_out        <= "1111"; -- All OFF? Wait, we want to enable only 0 and 1.
                                          -- Logic above enables 0 or 1.
                                          -- For others, we should probably output "1111" to SEL, so no digit is active.
                                          -- Wait, Case covers "Others".
                sel_out <= "1111"; -- Disable all (Wait, this overrides previous assignments if put here? No, inside Case)
        end case;
        
        -- Override for upper digits
        if digit_select = "10" or digit_select = "11" then
            sel_out <= "1111";
        end if;
    end process;
    
    -- Decoder (Re-used logic, simpler to just include file or duplicate)
    -- We'll assume the file is copied.
    U_Seg: SevenSegDecoder port map (hex_to_display, seg_out);

end Behavioral;
