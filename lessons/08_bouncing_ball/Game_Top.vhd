library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Game_Top is
    Port ( 
        clk     : in  STD_LOGIC; -- 50MHz
        reset_n : in  STD_LOGIC; -- Active Low (KEY1 or similar)
        
        -- VGA Output
        hsync   : out STD_LOGIC;
        vsync   : out STD_LOGIC;
        rgb     : out STD_LOGIC_VECTOR(2 downto 0) -- R, G, B (1 bit each)
    );
end Game_Top;

architecture Behavioral of Game_Top is

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
    
    component Ball_Logic is
        Port ( 
            clk      : in  STD_LOGIC;
            reset_n  : in  STD_LOGIC;
            vsync    : in  STD_LOGIC;
            ball_x   : out integer;
            ball_y   : out integer
        );
    end component;
    
    signal clk_25mhz : std_logic := '0';
    signal hsync_sig : std_logic;
    signal vsync_sig : std_logic;
    signal video_on  : std_logic;
    signal pix_x_Uns : unsigned(9 downto 0);
    signal pix_y_Uns : unsigned(9 downto 0);
    signal pix_x     : integer;
    signal pix_y     : integer;
    
    signal b_x, b_y  : integer;
    constant B_SIZE  : integer := 10;

begin

    -- Clock Divider (50 -> 25)
    process(clk)
    begin
        if rising_edge(clk) then
            clk_25mhz <= not clk_25mhz;
        end if;
    end process;

    -- Instantiation
    U_VGA: VGA_Sync port map (
        clk => clk_25mhz, hsync => hsync_sig, vsync => vsync_sig, video_on => video_on,
        pixel_x => pix_x_Uns, pixel_y => pix_y_Uns
    );
    
    hsync <= hsync_sig;
    vsync <= vsync_sig;
    pix_x <= to_integer(pix_x_Uns);
    pix_y <= to_integer(pix_y_Uns);
    
    U_Ball: Ball_Logic port map (
        clk => clk_25mhz, reset_n => reset_n, vsync => vsync_sig,
        ball_x => b_x, ball_y => b_y
    );
    
    -- Renderer
    process(video_on, pix_x, pix_y, b_x, b_y)
    begin
        if video_on = '1' then
            -- Draw Ball (Red)
            if (pix_x >= b_x and pix_x < b_x + B_SIZE) and
               (pix_y >= b_y and pix_y < b_y + B_SIZE) then
                rgb <= "100"; -- Red
            else
                rgb <= "000"; -- Black Background
            end if;
        else
            rgb <= "000"; -- Blanking
        end if;
    end process;

end Behavioral;
