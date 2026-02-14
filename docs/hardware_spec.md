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

## Pin Assignments
The following assignments are derived from the existing project configuration (`SwitchDrivesLED`).

### User LEDs
| Signal | Pin | Note |
|:-------|:----|:-----|
| led1   | PIN_87 | |
| led2   | PIN_86 | |
| led3   | PIN_85 | |
| led4   | PIN_84 | |

### User Switches
| Signal | Pin | Note |
|:-------|:----|:-----|
| sw1    | PIN_88 | |
| sw2    | PIN_89 | |
| sw3    | PIN_90 | |
| sw4    | PIN_91 | |

### Clock & Reset
- **Clock (50 MHz)**: Likely **PIN_23** or **PIN_25**.
  > [!NOTE]
  > Common configurations use **PIN_23** for 50MHz input. However, some variants use PIN_23 for UART RX. Please verify.
- **Reset**: Often **PIN_25** (if not clock) or a dedicated key.

### UART (Serial)
- **TX**: **PIN_10** (Typical)
- **RX**: **PIN_23** (Typical, check for conflict with Clock)

### 7-Segment Display & Buzzer
**Pinouts for these peripherals vary significantly between board revisions (V2.0, V2.1, etc.).**
- **Buzzer**: **Unknown**. (Some sources suggest PIN_85, but your QSF uses PIN_85 for `led3`).
- **7-Segment**: Requires "Development_board_schematic_V2.1.pdf" to identify segment (A-G, DP) and digit select (D1-D4) pins.

> [!IMPORTANT]
> The assignments for LEDs and Switches are confirmed from your `fpga-learning.qsf`. Other assignments are derived from common "Cyclone IV E Core Board" documentation and should be verified.
