library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_ColorBars is
    Port ( 
        clk     : in  STD_LOGIC; -- 50MHz
        hsync   : out STD_LOGIC;
        vsync   : out STD_LOGIC;
        rgb     : out STD_LOGIC_VECTOR(2 downto 0) -- 3-bit Color (R, G, B) - Check hardware spec for pin width!
        -- NOTE: RZ-EasyFPGA often has 3-bit (1 pin per color) or 8-bit/16-bit DAC.
        -- Assuming minimal 3-bit for now based on common learning board layouts.
    );
end VGA_ColorBars;

architecture Behavioral of VGA_ColorBars is

    component VGA_Sync is
        Port (
            clk      : in  STD_LOGIC;
            hsync    : out STD_LOGIC;
            vsync    : out STD_LOGIC;
            video_on : out STD_LOGIC;
            pixel_x  : out unsigned(9 downto 0);
            pixel_y  : out unsigned(9 downto 0)
        );
    end component;
    
    signal clk_25mhz : std_logic := '0';
    signal video_on  : std_logic;
    signal pixel_x   : unsigned(9 downto 0);
    signal pixel_y   : unsigned(9 downto 0);
    signal rgb_out   : std_logic_vector(2 downto 0);

begin

    -- Clock Divider (50MHz -> 25MHz)
    process(clk)
    begin
        if rising_edge(clk) then
            clk_25mhz <= not clk_25mhz;
        end if;
    end process;
    
    -- Instantiate Sync Generator
    U_VGA: VGA_Sync port map (
        clk      => clk_25mhz,
        hsync    => hsync,
        vsync    => vsync,
        video_on => video_on,
        pixel_x  => pixel_x,
        pixel_y  => pixel_y
    );
    
    -- Pattern Generator: Vertical Color Bars
    -- Screen width 640. 8 Colors. 80 pixels per bar.
    -- Colors: Black, Blue, Green, Cyan, Red, Magenta, Yellow, White
    process(video_on, pixel_x)
    begin
        if video_on = '1' then
            -- Simple 3-bit color generation based on X position
            -- Bit 2 (R) = x[8]
            -- Bit 1 (G) = x[7]
            -- Bit 0 (B) = x[6]
            -- This creates a repeating pattern every 256 pixels, approx.
            
            -- Let's make 8 clear bars of 80px
            if pixel_x < 80 then
                rgb_out <= "000"; -- Black
            elsif pixel_x < 160 then
                rgb_out <= "001"; -- Blue
            elsif pixel_x < 240 then
                rgb_out <= "010"; -- Green
            elsif pixel_x < 320 then
                rgb_out <= "011"; -- Cyan
            elsif pixel_x < 400 then
                 rgb_out <= "100"; -- Red
            elsif pixel_x < 480 then
                 rgb_out <= "101"; -- Magenta
            elsif pixel_x < 560 then
                 rgb_out <= "110"; -- Yellow
            else
                 rgb_out <= "111"; -- White
            end if;
        else
            rgb_out <= "000"; -- Black (Blanking)
        end if;
    end process;

    rgb <= rgb_out;

end Behavioral;
