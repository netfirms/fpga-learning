library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SevenSegCount is
    Port ( 
        clk     : in  STD_LOGIC;
        reset_n : in  STD_LOGIC; -- Active low reset
        btn_inc : in  STD_LOGIC; -- Button Increase
        btn_dec : in  STD_LOGIC; -- Button Decrease
        btn_rst : in  STD_LOGIC; -- Button Reset Count
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

    component SevenSegMux is
        Port ( 
            clk     : in  STD_LOGIC;
            reset_n : in  STD_LOGIC;
            hex0    : in  STD_LOGIC_VECTOR (3 downto 0);
            hex1    : in  STD_LOGIC_VECTOR (3 downto 0);
            hex2    : in  STD_LOGIC_VECTOR (3 downto 0);
            hex3    : in  STD_LOGIC_VECTOR (3 downto 0);
            dp_in   : in  STD_LOGIC_VECTOR (3 downto 0);
            seg_out : out STD_LOGIC_VECTOR (6 downto 0);
            sel_out : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    signal btn_inc_deb, btn_dec_deb, btn_rst_deb : std_logic;
    
    -- Integer Counter (0 to 9999)
    signal count_val : integer range 0 to 9999 := 0;
    
    -- Auto-Repeat Timers
    -- 50MHz clock -> 5,000,000 cycles = 0.1 seconds (10Hz)
    constant REPEAT_DELAY : integer := 5000000;
    signal inc_timer : integer range 0 to REPEAT_DELAY := 0;
    signal dec_timer : integer range 0 to REPEAT_DELAY := 0;
    
    -- Digits
    signal digit0, digit1, digit2, digit3 : unsigned(3 downto 0);

begin

    -- LED Debug (Show binary of lower 4 bits)
    led <= std_logic_vector(to_unsigned(count_val, 14)(3 downto 0));

    -- Debounce Instantiations
    U_Deb_Inc: Debounce port map (clk, reset_n, btn_inc, btn_inc_deb);
    U_Deb_Dec: Debounce port map (clk, reset_n, btn_dec, btn_dec_deb);
    U_Deb_Rst: Debounce port map (clk, reset_n, btn_rst, btn_rst_deb);

    -- Digit Extraction
    digit0 <= to_unsigned(count_val mod 10, 4);
    digit1 <= to_unsigned((count_val / 10) mod 10, 4);
    digit2 <= to_unsigned((count_val / 100) mod 10, 4);
    digit3 <= to_unsigned((count_val / 1000) mod 10, 4);

    -- Display Multiplexer
    U_Mux: SevenSegMux port map (
        clk     => clk,
        reset_n => reset_n,
        hex0    => std_logic_vector(digit0),
        hex1    => std_logic_vector(digit1),
        hex2    => std_logic_vector(digit2),
        hex3    => std_logic_vector(digit3),
        dp_in   => "0000",
        seg_out => seg,
        sel_out => sel
    );

    -- Main Counting Process
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            count_val <= 0;
            inc_timer <= 0;
            dec_timer <= 0;
        elsif rising_edge(clk) then
        
            -- RESET (Priority)
            if btn_rst_deb = '0' then
                count_val <= 0;
                inc_timer <= 0;
                dec_timer <= 0;
            else
                -- INCREASE (Auto-Repeat)
                if btn_inc_deb = '0' then
                    if inc_timer = 0 then
                        if count_val = 9999 then
                            count_val <= 0;
                        else
                            count_val <= count_val + 1;
                        end if;
                        inc_timer <= REPEAT_DELAY;
                    else
                        inc_timer <= inc_timer - 1;
                    end if;
                else
                    inc_timer <= 0; -- Reset timer when released
                end if;
                
                -- DECREASE (Auto-Repeat)
                if btn_dec_deb = '0' then
                    if dec_timer = 0 then
                        if count_val = 0 then
                            count_val <= 9999;
                        else
                            count_val <= count_val - 1;
                        end if;
                        dec_timer <= REPEAT_DELAY;
                    else
                        dec_timer <= dec_timer - 1;
                    end if;
                else
                    dec_timer <= 0; -- Reset timer when released
                end if;
            end if;
            
        end if;
    end process;

end Behavioral;
