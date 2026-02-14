library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_Loopback is
    Port ( 
        clk     : in  STD_LOGIC; -- 50MHz
        rx_line : in  STD_LOGIC; -- PIN_10
        tx_line : out STD_LOGIC; -- PIN_11
        led     : out STD_LOGIC_VECTOR(3 downto 0) -- Visual debug
    );
end UART_Loopback;

architecture Behavioral of UART_Loopback is

    component UART_RX is
        generic ( g_CLKS_PER_BIT : integer := 434 );
        port (
            i_Clk       : in  std_logic;
            i_RX_Serial : in  std_logic;
            o_RX_DV     : out std_logic;
            o_RX_Byte   : out std_logic_vector(7 downto 0)
        );
    end component;

    component UART_TX is
        generic ( g_CLKS_PER_BIT : integer := 434 );
        port (
            i_Clk       : in  std_logic;
            i_TX_DV     : in  std_logic;
            i_TX_Byte   : in  std_logic_vector(7 downto 0);
            o_TX_Active : out std_logic;
            o_TX_Serial : out std_logic;
            o_TX_Done   : out std_logic
        );
    end component;

    signal w_rx_dv   : std_logic;
    signal w_rx_byte : std_logic_vector(7 downto 0);
    signal w_tx_active : std_logic;
    signal w_tx_serial : std_logic;
    
begin

    -- Drive TX line
    tx_line <= w_tx_serial;
    
    -- Show lower 4 bits of received byte on LEDs
    led <= w_rx_byte(3 downto 0);

    -- Instantiate Receiver
    U_RX : UART_RX
        generic map ( g_CLKS_PER_BIT => 434 )
        port map (
            i_Clk       => clk,
            i_RX_Serial => rx_line,
            o_RX_DV     => w_rx_dv,
            o_RX_Byte   => w_rx_byte
        );
        
    -- Instantiate Transmitter
    -- Direct Loopback: Receive Valid -> Transmit Valid
    U_TX : UART_TX
        generic map ( g_CLKS_PER_BIT => 434 )
        port map (
            i_Clk       => clk,
            i_TX_DV     => w_rx_dv,   -- Triggers transmission when byte received
            i_TX_Byte   => w_rx_byte, -- Send back what we received
            o_TX_Active => w_tx_active,
            o_TX_Serial => w_tx_serial,
            o_TX_Done   => open
        );

end Behavioral;
