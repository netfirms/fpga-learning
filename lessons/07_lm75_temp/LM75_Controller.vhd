library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LM75_Controller is
    Port ( 
        clk        : in  STD_LOGIC; -- 50MHz
        reset_n    : in  STD_LOGIC;
        
        -- I2C Interface
        scl        : out STD_LOGIC;
        sda        : inout STD_LOGIC;
        
        -- Output
        temp_data  : out STD_LOGIC_VECTOR(15 downto 0); -- Raw 16-bit register
        error      : out STD_LOGIC
    );
end LM75_Controller;

architecture Behavioral of LM75_Controller is

    -- I2C Timing (100kHz SCL from 50MHz Clock)
    -- Divider = 500 / 2 = 250 ticks per half cycle? No.
    -- 50,000,000 / 100,000 = 500 ticks per SCL period.
    constant CLK_DIV : integer := 500; 
    signal clk_cnt   : integer range 0 to CLK_DIV := 0;
    signal i2c_clk_en : std_logic := '0'; -- Pulse at 200kHz (4x SCL?) typically need 4 states per bit
    
    -- State Machine
    type state_type is (IDLE, START, ADDR, WRITE_ACK, READ_MSB, ACK_MSB, READ_LSB, NACK_LSB, STOP);
    signal state : state_type := IDLE;
    
    -- Data
    signal bit_cnt : integer range 0 to 7 := 0;
    signal shift_reg : std_logic_vector(7 downto 0);
    signal temp_reg : std_logic_vector(15 downto 0) := (others => '0');
    
    -- I2C Signals
    signal sda_out : std_logic := '1';
    signal sda_in  : std_logic;
    signal sda_oe  : std_logic := '0'; -- 1 = Drive Low, 0 = Float High (Pull-up)
    signal scl_out : std_logic := '1';

    -- Address: 1001000 (0x48) + Read(1) = 10010001 (0x91)
    constant SLAVE_ADDR_READ : std_logic_vector(7 downto 0) := x"91";

begin

    -- Tri-state SDA
    sda <= '0' when sda_oe = '1' else 'Z';
    sda_in <= sda;
    scl <= scl_out;

    -- I2C Clock Enable Generator (Running at 400kHz for 100kHz SCL steps)
    -- 50MHz / 125 = 400kHz
    process(clk)
    begin
        if rising_edge(clk) then
            if clk_cnt = 124 then
                clk_cnt <= 0;
                i2c_clk_en <= '1';
            else
                clk_cnt <= clk_cnt + 1;
                i2c_clk_en <= '0';
            end if;
        end if;
    end process;
    
    -- Main State Machine
    process(clk, reset_n)
        variable sub_state : integer range 0 to 3 := 0; -- 0: SCL Low, 1: SCL High, 2: SCL High, 3: SCL Low
    begin
        if reset_n = '0' then
            state <= IDLE;
            sda_oe <= '0';
            scl_out <= '1';
            temp_data <= (others => '0');
        elsif rising_edge(clk) then
            if i2c_clk_en = '1' then
                
                -- SCL Generation Logic (Simplified for Master)
                -- We toggle SCL in specific states
                
                case state is
                    when IDLE =>
                        scl_out <= '1';
                        sda_oe <= '0';
                        state <= START;
                        
                    when START =>
                        -- Generate Start Condition (SDA High->Low while SCL High)
                        if sub_state = 0 then sda_oe <= '0'; scl_out <= '1'; end if;
                        if sub_state = 1 then sda_oe <= '1'; scl_out <= '1'; end if; -- SDA Low
                        if sub_state = 2 then sda_oe <= '1'; scl_out <= '0'; end if; -- SCL Low
                        if sub_state = 3 then 
                            sub_state := 0;
                            state <= ADDR;
                            bit_cnt <= 7;
                            shift_reg <= SLAVE_ADDR_READ;
                        else
                            sub_state := sub_state + 1;
                        end if;
                        
                    when ADDR =>
                        -- Send Address Bit
                        if sub_state = 0 then 
                            if shift_reg(7) = '0' then sda_oe <= '1'; else sda_oe <= '0'; end if;
                            scl_out <= '0';
                        elsif sub_state = 1 then scl_out <= '1';
                        elsif sub_state = 2 then scl_out <= '1';
                        elsif sub_state = 3 then scl_out <= '0';
                            if bit_cnt = 0 then
                                state <= WRITE_ACK;
                            else
                                bit_cnt <= bit_cnt - 1;
                                shift_reg <= shift_reg(6 downto 0) & '0';
                            end if;
                        end if;
                        sub_state := (sub_state + 1) mod 4;

                    when WRITE_ACK =>
                        -- Read ACK from Slave
                        if sub_state = 0 then sda_oe <= '0'; scl_out <= '0'; end if; -- Release SDA
                        if sub_state = 1 then scl_out <= '1'; end if;
                        if sub_state = 2 then 
                            if sda_in = '0' then error <= '0'; else error <= '1'; end if;
                            scl_out <= '1'; 
                        end if;
                        if sub_state = 3 then 
                            scl_out <= '0';
                            state <= READ_MSB;
                            bit_cnt <= 7;
                        end if;
                        sub_state := (sub_state + 1) mod 4;

                    when READ_MSB =>
                        -- Read 8 bits
                        if sub_state = 0 then sda_oe <= '0'; scl_out <= '0'; end if;
                        if sub_state = 1 then scl_out <= '1'; end if;
                        if sub_state = 2 then 
                            temp_reg(15 downto 8) <= temp_reg(14 downto 8) & sda_in; -- Just capture into specific bit? No, shift in.
                            -- Actually let's just index it.
                            temp_reg(8 + bit_cnt) <= sda_in;
                            scl_out <= '1'; 
                        end if;
                        if sub_state = 3 then 
                            scl_out <= '0';
                            if bit_cnt = 0 then state <= ACK_MSB; else bit_cnt <= bit_cnt - 1; end if;
                        end if;
                        sub_state := (sub_state + 1) mod 4;
                        
                    when ACK_MSB =>
                        -- Send ACK to Slave (Drive SDA Low)
                        if sub_state = 0 then sda_oe <= '1'; scl_out <= '0'; end if;
                        if sub_state = 1 then scl_out <= '1'; end if;
                        if sub_state = 2 then scl_out <= '1'; end if; -- Check nothing
                        if sub_state = 3 then scl_out <= '0'; state <= READ_LSB; bit_cnt <= 7; end if;
                        sub_state := (sub_state + 1) mod 4;

                    when READ_LSB =>
                        -- Read 8 bits
                        if sub_state = 0 then sda_oe <= '0'; scl_out <= '0'; end if;
                        if sub_state = 1 then scl_out <= '1'; end if;
                        if sub_state = 2 then 
                            temp_reg(bit_cnt) <= sda_in;
                            scl_out <= '1'; 
                        end if;
                        if sub_state = 3 then 
                            scl_out <= '0';
                            if bit_cnt = 0 then state <= NACK_LSB; else bit_cnt <= bit_cnt - 1; end if;
                        end if;
                        sub_state := (sub_state + 1) mod 4;
                        
                    when NACK_LSB =>
                        -- Send NACK to Slave (Drive SDA High / Release)
                        if sub_state = 0 then sda_oe <= '0'; scl_out <= '0'; end if;
                        if sub_state = 1 then scl_out <= '1'; end if;
                        if sub_state = 2 then scl_out <= '1'; end if;
                        if sub_state = 3 then scl_out <= '0'; state <= STOP; end if;
                        sub_state := (sub_state + 1) mod 4;
                        
                    when STOP =>
                        -- Generate Stop Condition (SDA Low->High while SCL High)
                        if sub_state = 0 then sda_oe <= '1'; scl_out <= '0'; end if; -- Ensure Data Low first
                        if sub_state = 1 then sda_oe <= '1'; scl_out <= '1'; end if; -- SCL High
                        if sub_state = 2 then sda_oe <= '0'; scl_out <= '1'; end if; -- SDA High (Stop)
                        if sub_state = 3 then 
                            temp_data <= temp_reg; -- Update output
                            state <= IDLE; -- Loop back to read again
                            -- Add delay? Simple state machine runs continuously usually.
                        end if;
                        sub_state := (sub_state + 1) mod 4;
                        
                    when others => state <= IDLE;
                end case;
            end if;
        end if;
    end process;

end Behavioral;
