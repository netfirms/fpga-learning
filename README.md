# FPGA Learning

This repository documents my journey in learning FPGA development using VHDL.

## Project Structure

- **common/**: Shared VHDL components and packages.
- **docs/**: Documentation and datasheets.
- **lessons/**: Step-by-step learning projects.
  - `01_led/`: [Basic LED control and switch input](lessons/01_led).
  - `02_sev_seg_count/`: [4-digit decimal counter with 7-segment display](lessons/02_sev_seg_count).
  - `03_buzzer/`: [Passive buzzer control (PWM/Tones)](lessons/03_buzzer).
  - `04_uart/`: [serial communication with PC (Loopback)](lessons/04_uart).
  - `05_vga/`: [VGA controller (640x480 Color Bars)](lessons/05_vga).
  - `06_ps2_keyboard/`: [PS/2 Keyboard decoder](lessons/06_ps2_keyboard).
  - `07_lm75_temp/`: [Digital Thermometer (I2C LM75 Sensor)](lessons/07_lm75_temp).
  - `08_bouncing_ball/`: [VGA Bouncing Ball Game (Physics Demo)](lessons/08_bouncing_ball).
- **scripts/**: Helper scripts for building and simulation.

## Resources

- [Development Board Schematic](docs/Development_board_schematic_V2.1.pdf)

## Board Layout & Pinout

```mermaid
graph TD
    subgraph Laptop [Development Laptop]
        Terminal[Serial Terminal<br/>(Minicom/PuTTY)]
        Quartus[Quartus Prime<br/>(Programmer)]
    end

    subgraph Board [RZ-EasyFPGA Board]
        
        subgraph FPGA [Cyclone IV EP4CE6E22C8]
            CLK[Clk 50MHz: PIN_23]
            RST[Reset_n: PIN_25]
            
            %% LEDs
            LED1[LED1: PIN_87]
            LED2[LED2: PIN_86]
            LED3[LED3: PIN_85]
            LED4[LED4: PIN_84]
            
            %% Keys
            KEY1[KEY1/Mode: PIN_88]
            KEY2[KEY2: PIN_89]
            KEY3[KEY3: PIN_90]
            KEY4[KEY4: PIN_91]
            
            %% Buzzer
            BUZZ[Buzzer: PIN_110]
            
            %% UART
            UART_TX[UART TX: PIN_11]
            UART_RX[UART RX: PIN_10]
            
            %% VGA
            VGA_H[VGA HSync: PIN_101]
            VGA_V[VGA VSync: PIN_103]
            VGA_R[VGA Red: PIN_106]
            VGA_G[VGA Green: PIN_105]
            VGA_B[VGA Blue: PIN_104]
            
            %% PS/2
            PS2_C[PS2 Clk: PIN_119]
            PS2_D[PS2 Data: PIN_120]
            
            %% I2C
            I2C_SCL[I2C SCL: PIN_112]
            I2C_SDA[I2C SDA: PIN_113]
            
            %% 7-Segment
            SEV_SEL[7-Seg Sel: 133,135,136,137]
            SEV_SEG[7-Seg Seg: 128..124,127]
        end
        
        %% On-Board / External Peripherals
        Osculator((50MHz Osc)) --> CLK
        Button[Push Buttons] --> RST & KEY1 & KEY2 & KEY3 & KEY4
        
        LED1 & LED2 & LED3 & LED4 --> LEDs[4x LEDs]
        BUZZ --> Speaker[Beeper]
        
        VGA_H & VGA_V & VGA_R & VGA_G & VGA_B --> VGA_Con[VGA Connector]
        
        PS2_Dev[Keyboard/Mouse] --> PS2_C & PS2_D
        
        I2C_SCL & I2C_SDA <--> LM75[LM75 Sensor]
        I2C_SCL & I2C_SDA <--> EEPROM[AT24C08]
        
        SEV_SEL & SEV_SEG --> Disp[4-Digit 7-Seg Display]
        
        JTAG_Header[JTAG Header]
        UART_Header[UART Header]
    end
    
    %% Laptop Connections
    Terminal <==USB==> USB_TTL[USB-TTL Adapter]
    USB_TTL <==TX/RX==> UART_Header
    UART_Header --- UART_RX & UART_TX
    
    Quartus <==USB==> Blaster[USB-Blaster]
    Blaster <==JTAG==> JTAG_Header
    JTAG_Header -.-> FPGA
```
