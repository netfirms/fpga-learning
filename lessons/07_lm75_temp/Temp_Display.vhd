library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Temp_Display is
    Port ( 
        clk        : in  STD_LOGIC;
        reset_n    : in  STD_LOGIC;
        
        -- Control
        btn_mode   : in  STD_LOGIC; -- Toggle C/F (SW1)
        
        -- I2C
        scl        : out STD_LOGIC;
        sda        : inout STD_LOGIC;
        
        -- 7-Segment
        seg        : out STD_LOGIC_VECTOR(6 downto 0);
        seg_dp     : out STD_LOGIC; -- Decimal Point
        sel        : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Temp_Display;

architecture Behavioral of Temp_Display is

    component Debounce is
        Port ( 
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            button  : in  STD_LOGIC;
            result  : out STD_LOGIC
        );
    end component;

    component LM75_Controller is
        Port ( 
            clk        : in  STD_LOGIC;
            reset_n    : in  STD_LOGIC;
            scl        : out STD_LOGIC;
            sda        : inout STD_LOGIC;
            temp_data  : out STD_LOGIC_VECTOR(15 downto 0);
            error      : out STD_LOGIC
        );
    end component;
    
    component SevenSegDecoder is
        Port ( hex_in : in STD_LOGIC_VECTOR(3 downto 0); seg_out : out STD_LOGIC_VECTOR(6 downto 0) );
    end component;

    signal temp_raw : std_logic_vector(15 downto 0);
    
    signal is_neg   : boolean;
    -- Display Value scaled by 10 (e.g. 25.5 -> 255)
    signal display_val : integer range 0 to 9999;
    
    -- Mode Control
    signal btn_mode_deb : std_logic;
    signal btn_mode_prev : std_logic := '0';
    signal is_fahrenheit : boolean := false;
    
    -- Mux
    signal refresh_cnt : integer range 0 to 100000 := 0;
    signal digit_sel   : integer range 0 to 3 := 0;
    signal hex_digit   : std_logic_vector(3 downto 0); 
    
begin

    -- Instantiate Sensor Controller
    U_LM75: LM75_Controller port map (
        clk => clk, reset_n => reset_n, scl => scl, sda => sda, temp_data => temp_raw, error => open
    );
    
    -- Debounce Mode Button
    U_Deb: Debounce port map (clk, reset_n, btn_mode, btn_mode_deb);
    
    -- Toggle Mode Logic
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            is_fahrenheit <= false;
            btn_mode_prev <= '0';
        elsif rising_edge(clk) then
            if btn_mode_deb = '0' and btn_mode_prev = '1' then
                if is_fahrenheit then is_fahrenheit <= false; else is_fahrenheit <= true; end if;
            end if;
            btn_mode_prev <= btn_mode_deb;
        end if;
    end process;
    
    -- Process Temperature Data (Scaled x10)
    process(temp_raw, is_fahrenheit)
        variable signed_temp_int : signed(7 downto 0);
        variable frac_part       : integer; -- 0 or 5
        variable val_c_x10       : integer;
        variable val_f_x10       : integer;
    begin
        signed_temp_int := signed(temp_raw(15 downto 8));
        
        if temp_raw(7) = '1' then frac_part := 5; else frac_part := 0; end if;
        
        -- Calculate Celsius x10
        -- Handle negative temperatures for 2's complement
        -- Simple approach: ConvertToInt, Multiply, Add Frac logic carefully.
        -- Better: Work with magnitude if negative logic is creating complex signal assignments?
        -- Standard integer conversion handles negatives.
        val_c_x10 := to_integer(signed_temp_int) * 10; 
        
        -- Adjust for fraction.
        -- If positive (e.g. 25), 25.5 -> 250 + 5 = 255.
        -- If negative (e.g. -10), -10.5 -> -100 - 5 = -105.
        if val_c_x10 >= 0 then
            val_c_x10 := val_c_x10 + frac_part;
        else
            val_c_x10 := val_c_x10 - frac_part;
        end if;
        
        -- Conversion
        -- F = (C * 1.8) + 32
        -- Fx10 = (Cx10 * 18)/10 + 320 -> No, precision loss.
        -- Fx10 = (Cx10 * 9)/5 + 320
        val_f_x10 := (val_c_x10 * 9) / 5 + 320;
        
        if is_fahrenheit then
            if val_f_x10 < 0 then
                is_neg <= true;
                display_val <= abs(val_f_x10);
            else
                is_neg <= false;
                display_val <= val_f_x10;
            end if;
        else
            if val_c_x10 < 0 then
                is_neg <= true;
                display_val <= abs(val_c_x10);
            else
                is_neg <= false;
                display_val <= val_c_x10;
            end if;
        end if;
    end process;
    
    -- Seven Segment Multiplexing
    process(clk)
    begin
        if rising_edge(clk) then
            if refresh_cnt = 49999 then -- 1kHz
                refresh_cnt <= 0;
                if digit_sel = 3 then digit_sel <= 0; else digit_sel <= digit_sel + 1; end if;
            else
                refresh_cnt <= refresh_cnt + 1;
            end if;
        end if;
    end process;
    
    process(digit_sel, display_val, is_neg, is_fahrenheit)
    begin
        sel <= "1111"; -- Default OFF
        hex_digit <= x"F"; 
        seg_dp <= '1'; -- Default OFF (Assuming Active Low)
        
        case digit_sel is
            when 0 => -- Rightmost: Unit
                sel <= "1110";
                if is_fahrenheit then hex_digit <= x"F"; else hex_digit <= x"C"; end if;
                
            when 1 => -- Fraction (0.X)
                sel <= "1101";
                hex_digit <= std_logic_vector(to_unsigned(display_val mod 10, 4));
                
            when 2 => -- Units (X.)
                sel <= "1011";
                hex_digit <= std_logic_vector(to_unsigned((display_val / 10) mod 10, 4));
                seg_dp <= '0'; -- Turn ON Decimal Point (Active Low)
                
            when 3 => -- Tens (XX.)
                sel <= "0111";
                if display_val >= 100 then
                     hex_digit <= std_logic_vector(to_unsigned((display_val / 100) mod 10, 4));
                else
                     -- Blank or Sign
                     if is_neg then hex_digit <= x"E"; else sel <= "1111"; end if;
                end if;
                
            when others => null;
        end case;
        
    end process;
    
    -- Decoder Instance
    U_Dec: SevenSegDecoder port map (hex_digit, seg);

end Behavioral;
