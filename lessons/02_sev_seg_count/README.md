# Lesson 2: 7-Segment Display Counter

This lesson demonstrates how to use the FPGA's 4-digit 7-segment display and push buttons to create a decimal counter.

## Overview
- **Goal**: Create a decimal counter (0-9999) using all 4 digits of the 7-segment display.
- **Key Concepts**:
    -   Debouncing mechanical switches.
    -   7-Segment display decoding.
    -   Time-Division Multiplexing (for driving 4 digits with one segment bus).
    -   BCD (Binary Coded Decimal) or simple decimal arithmetic.

## Hardware Requirements
- **Board**: RZ-EasyFPGA A2.1 / A2.2 (Cyclone IV E).
- **Inputs**: 3 x Push Buttons (SW1, SW2, SW3).
- **Outputs**: 4-Digit 7-Segment Display.

## Pin Assignments

The project `02_sev_seg_count.qsf` uses the default pin assignments for the RZ-EasyFPGA board.

-   **Segments**: `seg[0]` (A) through `seg[6]` (G) on PINs 128, 121, 125, 129, 132, 126, 124.
-   **Digit Selects**: `sel[0]` through `sel[3]` on PINs 133, 135, 136, 137.
-   **LEDS**: Used for binary debugging of the counter's lower bits.

## How to Run

1.  **Open Quartus Prime**.
2.  Open the project file `02_sev_seg_count.qsf`.
3.  **Compile**:
    -   Click `Processing` -> `Start Compilation`.
    -   Ensure there are no critical errors.
4.  **Program**:
    -   Connect your FPGA board (USB Blaster).
    -   Open `Tools` -> `Programmer`.
    -   Click `Start` to upload the `.sof` file.

## Expected Behavior
-   **Display**: Shows a decimal number from `0` to `9999` across all 4 digits.
-   **Controls**:
    -   **SW3 (PIN_90)**: **Increase** count.
    -   **SW2 (PIN_89)**: **Decrease** count.
    -   **SW1 (PIN_88)**: **Reset** count to 0.
-   **Behavior**: 
    -   **Click**: Pressing a button triggers a single count change.
    -   **Hold**: Holding a button triggers **continuous counting** (Auto-Repeat).
        -   The counter will increment/decrement rapidly for fluid control.
    -   Counter wraps around (9999 -> 0 and 0 -> 9999).
