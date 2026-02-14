# Lesson 2: 7-Segment Display Counter

This lesson demonstrates how to use the FPGA's 7-segment display and a push button to create a simple counter.

## Overview
- **Goal**: Increment a hex digit (0-F) on the 7-segment display every time a button is pressed.
- **Key Concepts**:
    -   Debouncing mechanical switches.
    -   7-Segment display decoding.
    -   VHDL `process` blocks and state management.

## Hardware Requirements
- Cyclone IV E FPGA Board.
- 1 x Push Button (or Toggle Switch).
- 1 x 7-Segment Display.

## Critical Step: Pin Assignments

> [!WARNING]
> The pin assignments for the 7-segment display in `sev_seg.qsf` are **Generic Placeholders (`PIN_XXX`)**. 
> 
> **You MUST update `sev_seg.qsf` with the correct PIN numbers from your board's schematic (`Development_board_schematic_V2.1.pdf`) before compiling.**

Look for pins labeled:
-   **Segments**: `seg[0]` (A) through `seg[6]` (G).
-   **Digit Selects**: `sel[0]` through `sel[3]` (D1-D4).

## How to Run

1.  **Open Quartus Prime**.
2.  Open the project file `sev_seg.qsf` (or create a new project using this file).
3.  **Update Pin Assignments**:
    -   Open `Assignments` -> `Pin Planner` OR edit `sev_seg.qsf` directly.
    -   Replace `PIN_XXX` with actual pin numbers.
4.  **Compile**:
    -   Click `Processing` -> `Start Compilation`.
    -   Ensure there are no critical errors.
5.  **Program**:
    -   Connect your FPGA board (USB Blaster).
    -   Open `Tools` -> `Programmer`.
    -   Click `Start` to upload the `.sof` file.

## Expected Behavior
-   The 7-segment display should show `0`.
-   Pressing the button (connected to `PIN_90`) should increment the count.
-   The count goes from `0` to `9`, then `A` to `F`, and wraps back to `0`.
-   **Note**: If you are using a toggle switch instead of a momentary button, you will need to toggle it ON and then OFF to register one count.
