library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SevenSegMux is
    Port ( 
        clk     : in  STD_LOGIC;
        reset_n : in  STD_LOGIC;
        hex0    : in  STD_LOGIC_VECTOR (3 downto 0); -- Digit 0 (Rightmost)
        hex1    : in  STD_LOGIC_VECTOR (3 downto 0); -- Digit 1
        hex2    : in  STD_LOGIC_VECTOR (3 downto 0); -- Digit 2
        hex3    : in  STD_LOGIC_VECTOR (3 downto 0); -- Digit 3 (Leftmost)
        dp_in   : in  STD_LOGIC_VECTOR (3 downto 0); -- Decimal points (1=ON)
        
        seg_out : out STD_LOGIC_VECTOR (6 downto 0); -- Segments A-G
        sel_out : out STD_LOGIC_VECTOR (3 downto 0)  -- Digit Selects (Active Low)
    );
end SevenSegMux;

architecture Behavioral of SevenSegMux is

    component SevenSegDecoder is
        Port ( 
            hex_in  : in  STD_LOGIC_VECTOR (3 downto 0);
            seg_out : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

    -- Refresh counter: 50MHz / 2^16 ~= 762Hz refresh rate
    signal refresh_counter : unsigned(19 downto 0) := (others => '0');
    signal digit_select    : std_logic_vector(1 downto 0);
    signal current_hex     : std_logic_vector(3 downto 0);
    signal current_seg     : std_logic_vector(6 downto 0);

begin

    -- Clock Divider for Refresh Rate
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            refresh_counter <= (others => '0');
        elsif rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;

    -- Use top 2 bits for digit selection
    digit_select <= std_logic_vector(refresh_counter(19 downto 18));

    -- Multiplexing Logic
    process(digit_select, hex0, hex1, hex2, hex3)
    begin
        case digit_select is
            when "00" =>
                current_hex <= hex0;
                sel_out     <= "1110"; -- Select Digit 0 (Rightmost)
            when "01" =>
                current_hex <= hex1;
                sel_out     <= "1101"; -- Select Digit 1
            when "10" =>
                current_hex <= hex2;
                sel_out     <= "1011"; -- Select Digit 2
            when "11" =>
                current_hex <= hex3;
                sel_out     <= "0111"; -- Select Digit 3 (Leftmost)
            when others =>
                current_hex <= "0000";
                sel_out     <= "1111";
        end case;
    end process;

    -- Helper instantiation (or just use logic directly if preferred, but component is cleaner)
    U_Decoder: SevenSegDecoder port map (
        hex_in  => current_hex,
        seg_out => seg_out
    );

end Behavioral;
