# Hardware Specifications

## FPGA Device
- **Model**: Intel (Altera) Cyclone IV E `EP4CE6E22C8N`
- **Family**: Cyclone IV E
- **Logic Elements**: 6,272
- **Embedded Memory**: 270 Kbits
- **Multipliers**: 15 (18x18)
- **PLLs**: 2
- **Global Clock Networks**: 10
- **Package**: EQFP-144

## Board Model (Inferred)
Based on the pin assignments for LEDs (87, 86, 85, 84) and Keys (88, 89, 90, 91), this board matches the **RZ-EasyFPGA A2.1 / A2.2** (or compatible variant).

## Pin Assignments

### Clock & Reset
- **Clock (50 MHz)**: **PIN_23**
- **Reset**: **PIN_25** (Check if dedicated key or shared)

### User LEDs (Active Low)
| Signal | Pin | Note |
|:-------|:----|:-----|
| led1   | PIN_87 | |
| led2   | PIN_86 | |
| led3   | PIN_85 | |
| led4   | PIN_84 | |

### User Switches (Active Low)
These are typically push-buttons.
| Signal | Pin | Note |
|:-------|:----|:-----|
| sw1    | PIN_88 | |
| sw2    | PIN_89 | |
| sw3    | PIN_90 | |
| sw4    | PIN_91 | |

### 7-Segment Display
The board typically has a 4-digit 7-segment display (Common Anode).

**Digit Selects (Active Low scans):**
| Digit | Pin    | Note |
|:------|:-------|:-----|
| D1    | PIN_133| Leftmost digit |
| D2    | PIN_135| |
| D3    | PIN_136| |
| D4    | PIN_137| Rightmost digit |

**Segments (Active Low):**
| Segment | Pin    | Note |
|:--------|:-------|:-----|
| A       | PIN_128| |
| B       | PIN_121| |
| C       | PIN_125| |
| D       | PIN_129| |
| E       | PIN_132| |
| F       | PIN_126| |
| G       | PIN_124| |
| DP      | PIN_127| Decimal Point |

### Buzzer
- **Buzzer**: **PIN_110** (Active Low, usually requires oscillation)

### UART (Serial)
- **TX**: **PIN_11** (or PIN_10 on some variants)
- **RX**: **PIN_10** (or PIN_11 on some variants)

### Expansion Headers
*Note: Refer to specific A2.2 schematic for full GPIO mapping.*
- **VGA**: often uses a resistor ladder DAC on specific pins.
- **PS/2**: often on PIN_119 (CLK) and PIN_120 (DAT).

> [!CAUTION]
> These assignments are derived from the **RZ-EasyFPGA A2.2** schematic which matches your LED/Key layout. 
> **Please verify these pins on your actual board hardware before driving high-current signals.**

## Common Applications (RZ-EasyFPGA)

The RZ-EasyFPGA is a versatile entry-level board suitable for:

1.  **Digital Logic Learning**:
    -   Basic gates, counters, and state machines using LEDs and Keys.
    -   7-Segment display control (timers, counters).
    
2.  **Embedded Systems**:
    -   **NIOS II Soft Processor**: The EP4CE6 chip and onboard SDRAM (typically 64Mbit) support running a soft-core processor.
    -   **uClinux**: Advanced users can run uClinux on the NIOS II core.

3.  **Interface Projects**:
    -   **VGA Controller**: Generating 640x480 @ 60Hz signals (using resistor ladder DAC).
    -   **PS/2 Keyboard/Mouse**: Decoding PS/2 protocols.
    -   **UART Communication**: Serial data exchange with PC.
    -   **LCD Control**: Interfacing with LCD1602 or LCD12864 modules via the expansion header.

4.  **Sensor Integration**:
    -   Reading the onboard LM75 temperature sensor (I2C).
    -   Infrared (IR) remote decoding.
