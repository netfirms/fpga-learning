library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Buzzer is
    Port ( 
        clk     : in  STD_LOGIC; -- 50MHz
        sw1     : in  STD_LOGIC; -- Button 1
        sw2     : in  STD_LOGIC; -- Button 2
        sw3     : in  STD_LOGIC; -- Button 3
        buzzer  : out STD_LOGIC
    );
end Buzzer;

architecture Behavioral of Buzzer is
    -- Clock Frequency: 50,000,000 Hz
    -- Tones (Approximate):
    -- SW1 -> C4 (Middle C) = 261.63 Hz -> Period = 191113 cycles (Toggle every 95556)
    -- SW2 -> E4 = 329.63 Hz -> Period = 151685 cycles (Toggle every 75842)
    -- SW3 -> G4 = 392.00 Hz -> Period = 127551 cycles (Toggle every 63775)
    
    constant TOGGLE_C4 : integer := 95556;
    constant TOGGLE_E4 : integer := 75842;
    constant TOGGLE_G4 : integer := 63775;
    
    signal counter : integer range 0 to 100000 := 0;
    signal tone_period : integer range 0 to 100000 := 0;
    signal buzz_reg : std_logic := '0';

begin
    
    -- Assign output
    buzzer <= buzz_reg;
    
    process(clk)
    begin
        if rising_edge(clk) then
            -- Determine desired period based on pressed button (Active Low)
            -- Priority: SW1 > SW2 > SW3
            if sw1 = '0' then
                tone_period <= TOGGLE_C4;
            elsif sw2 = '0' then
                tone_period <= TOGGLE_E4;
            elsif sw3 = '0' then
                tone_period <= TOGGLE_G4;
            else
                tone_period <= 0; -- Silence
            end if;
            
            -- Generate Square Wave
            if tone_period > 0 then
                if counter >= tone_period then
                    counter <= 0;
                    buzz_reg <= not buzz_reg; -- Toggle output
                else
                    counter <= counter + 1;
                end if;
            else
                counter <= 0;
                buzz_reg <= '1'; -- Default High (Off for active low typical buzzer? Or Low for off?)
                                 -- Assuming Passive: Needs oscillation. DC High or Low stops sound.
                                 -- Let's keep it constant '1' or '0' to silence.
            end if;
            
        end if;
    end process;

end Behavioral;
