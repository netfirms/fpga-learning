library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_Sync is
    Generic (
        -- 640x480 @ 60Hz Timing (25.175 MHz Pixel Clock)
        H_VIS    : integer := 640;
        H_FP     : integer := 16;
        H_SYNC   : integer := 96;
        H_BP     : integer := 48;
        
        V_VIS    : integer := 480;
        V_FP     : integer := 10;
        V_SYNC   : integer := 2;
        V_BP     : integer := 33
    );
    Port (
        clk      : in  STD_LOGIC; -- 25MHz Pixel Clock
        hsync    : out STD_LOGIC;
        vsync    : out STD_LOGIC;
        video_on : out STD_LOGIC;
        pixel_x  : out unsigned(9 downto 0);
        pixel_y  : out unsigned(9 downto 0)
    );
end VGA_Sync;

architecture Behavioral of VGA_Sync is

    constant H_TOTAL : integer := H_VIS + H_FP + H_SYNC + H_BP; -- 800
    constant V_TOTAL : integer := V_VIS + V_FP + V_SYNC + V_BP; -- 525

    signal h_count : integer range 0 to H_TOTAL - 1 := 0;
    signal v_count : integer range 0 to V_TOTAL - 1 := 0;
    
    signal h_video : std_logic;
    signal v_video : std_logic;

begin

    -- Horizontal Counter
    process(clk)
    begin
        if rising_edge(clk) then
            if h_count = H_TOTAL - 1 then
                h_count <= 0;
            else
                h_count <= h_count + 1;
            end if;
        end if;
    end process;

    -- Vertical Counter
    process(clk)
    begin
        if rising_edge(clk) then
            if h_count = H_TOTAL - 1 then
                if v_count = V_TOTAL - 1 then
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
                end if;
            end if;
        end if;
    end process;
    
    -- Sync Pulses (Active Low)
    hsync <= '0' when (h_count >= (H_VIS + H_FP) and h_count < (H_VIS + H_FP + H_SYNC)) else '1';
    vsync <= '0' when (v_count >= (V_VIS + V_FP) and v_count < (V_VIS + V_FP + V_SYNC)) else '1';
    
    -- Video On Signal (Active High when in visible area)
    h_video <= '1' when (h_count < H_VIS) else '0';
    v_video <= '1' when (v_count < V_VIS) else '0';
    video_on <= h_video and v_video;
    
    -- Pixel Coordinates
    pixel_x <= to_unsigned(h_count, 10);
    pixel_y <= to_unsigned(v_count, 10);

end Behavioral;
