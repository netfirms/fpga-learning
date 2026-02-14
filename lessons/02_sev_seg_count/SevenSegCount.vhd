library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SevenSegCount is
    Port ( 
        clk     : in  STD_LOGIC;
        reset_n : in  STD_LOGIC; -- Active low reset
        btn     : in  STD_LOGIC;
        led     : out STD_LOGIC_VECTOR(3 downto 0);
        seg     : out STD_LOGIC_VECTOR(6 downto 0);
        sel     : out STD_LOGIC_VECTOR(3 downto 0) -- Digit select
    );
end SevenSegCount;

architecture Behavioral of SevenSegCount is

    component Debounce is
        Port ( 
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            button  : in  STD_LOGIC;
            result  : out STD_LOGIC
        );
    end component;

    component SevenSegDecoder is
        Port ( 
            hex_in  : in  STD_LOGIC_VECTOR (3 downto 0);
            seg_out : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

    signal btn_debounced : std_logic;
    signal btn_prev      : std_logic := '0';
    signal counter       : unsigned(3 downto 0) := (others => '0');

begin

    -- Select the first digit (active low for common anode usually, check schematic)
    -- Assuming active low digit select for now
    sel <= "1110"; 
    
    -- Show counter on LEDs as well
    led <= std_logic_vector(counter);

    -- Instantiation of Debounce
    U1: Debounce port map (
        clk     => clk,
        reset   => reset_n,
        button  => btn,
        result  => btn_debounced
    );

    -- Instantiation of SevenSegDecoder
    U2: SevenSegDecoder port map (
        hex_in  => std_logic_vector(counter),
        seg_out => seg
    );

    -- Counting Process
    process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                counter <= (others => '0');
                btn_prev <= '0';
            else
                -- Detect rising edge of debounced button
                if (btn_debounced = '1' and btn_prev = '0') then
                    counter <= counter + 1;
                end if;
                btn_prev <= btn_debounced;
            end if;
        end if;
    end process;

end Behavioral;
