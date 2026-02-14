library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity UART_TX is
    generic (
        g_CLKS_PER_BIT : integer := 434 -- 50MHz / 115200
    );
    port (
        i_Clk       : in  std_logic;
        i_TX_DV     : in  std_logic;
        i_TX_Byte   : in  std_logic_vector(7 downto 0);
        o_TX_Active : out std_logic;
        o_TX_Serial : out std_logic;
        o_TX_Done   : out std_logic
    );
end UART_TX;
 
architecture rtl of UART_TX is
    type t_SM_Main is (s_Idle, s_TX_Start_Bit, s_TX_Data_Bits,
                       s_TX_Stop_Bit, s_Cleanup);
    signal r_SM_Main : t_SM_Main := s_Idle;
 
    signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0;
    signal r_Bit_Index : integer range 0 to 7 := 0;
    signal r_TX_Data   : std_logic_vector(7 downto 0) := (others => '0');
    signal r_TX_Done   : std_logic := '0';
    signal r_TX_Active : std_logic := '0';
    signal r_TX_Serial : std_logic := '1'; -- Drive High for Idle
    
begin
 
    process (i_Clk)
    begin
        if rising_edge(i_Clk) then
            case r_SM_Main is
                when s_Idle =>
                    o_TX_Serial <= '1';         -- Drive Line High for Idle
                    r_TX_Done   <= '0';
                    r_Clk_Count <= 0;
                    r_Bit_Index <= 0;
                    
                    if i_TX_DV = '1' then
                        r_TX_Data   <= i_TX_Byte;
                        r_SM_Main   <= s_TX_Start_Bit;
                        r_TX_Active <= '1';
                    else
                        r_SM_Main   <= s_Idle;
                        r_TX_Active <= '0';
                    end if;
 
                when s_TX_Start_Bit =>
                    o_TX_Serial <= '0';         -- Start Bit = 0
 
                    if r_Clk_Count < g_CLKS_PER_BIT-1 then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main   <= s_TX_Start_Bit;
                    else
                        r_Clk_Count <= 0;
                        r_SM_Main   <= s_TX_Data_Bits;
                    end if;
 
                when s_TX_Data_Bits =>
                    o_TX_Serial <= r_TX_Data(r_Bit_Index);
                    
                    if r_Clk_Count < g_CLKS_PER_BIT-1 then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main   <= s_TX_Data_Bits;
                    else
                        r_Clk_Count <= 0;
                        
                        if r_Bit_Index < 7 then
                            r_Bit_Index <= r_Bit_Index + 1;
                            r_SM_Main   <= s_TX_Data_Bits;
                        else
                            r_Bit_Index <= 0;
                            r_SM_Main   <= s_TX_Stop_Bit;
                        end if;
                    end if;
 
                when s_TX_Stop_Bit =>
                    o_TX_Serial <= '1';         -- Stop Bit = 1
 
                    if r_Clk_Count < g_CLKS_PER_BIT-1 then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main   <= s_TX_Stop_Bit;
                    else
                        r_TX_Done   <= '1';
                        r_Clk_Count <= 0;
                        r_SM_Main   <= s_Cleanup;
                    end if;
 
                when s_Cleanup =>
                    r_SM_Main   <= s_Idle;
                    r_TX_Done   <= '1';
                    r_TX_Active <= '0';
                    
                when others =>
                    r_SM_Main <= s_Idle;
 
            end case;
        end if;
    end process;
 
    o_TX_Active <= r_TX_Active;
    o_TX_Done   <= r_TX_Done;
    
end rtl;
