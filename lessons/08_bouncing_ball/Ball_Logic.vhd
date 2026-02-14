library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Ball_Logic is
    Generic (
        H_RES : integer := 640;
        V_RES : integer := 480;
        BALL_SIZE : integer := 10
    );
    Port ( 
        clk      : in  STD_LOGIC;
        reset_n  : in  STD_LOGIC;
        vsync    : in  STD_LOGIC; -- Update trigger
        ball_x   : out integer;
        ball_y   : out integer
    );
end Ball_Logic;

architecture Behavioral of Ball_Logic is

    signal x : integer := H_RES/2;
    signal y : integer := V_RES/2;
    signal dx : integer := 2; -- Velocity X
    signal dy : integer := 2; -- Velocity Y
    
    signal vsync_prev : std_logic := '0';

begin

    process(clk, reset_n)
    begin
        if reset_n = '0' then
            x <= H_RES/2;
            y <= V_RES/2;
            dx <= 2;
            dy <= 2;
        elsif rising_edge(clk) then
            -- Update on VSYNC Rising Edge (Frame Start/End)
            if vsync = '1' and vsync_prev = '0' then
                
                -- Move X
                if (x + dx) <= 0 then
                    dx <= 2; -- Bounce Right
                    x <= 0;
                elsif (x + dx) >= (H_RES - BALL_SIZE) then
                    dx <= -2; -- Bounce Left
                    x <= H_RES - BALL_SIZE;
                else
                    x <= x + dx;
                end if;
                
                -- Move Y
                if (y + dy) <= 0 then
                    dy <= 2; -- Bounce Down
                    y <= 0;
                elsif (y + dy) >= (V_RES - BALL_SIZE) then
                    dy <= -2; -- Bounce Up
                    y <= V_RES - BALL_SIZE;
                else
                    y <= y + dy;
                end if;
                
            end if;
            vsync_prev <= vsync;
        end if;
    end process;
    
    ball_x <= x;
    ball_y <= y;

end Behavioral;
