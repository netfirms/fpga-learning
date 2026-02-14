# Lesson 5: VGA Controller (Color Bars)

This lesson demonstrates how to drive a VGA monitor to display a static test pattern.

## Overview
-   **Goal**: Display 8 vertical color bars on a standard VGA monitor.
-   **Resolution**: 640x480 @ 60Hz.
-   **Key Concepts**:
    -   VGA Timing (HSYNC, VSYNC, Porches).
    -   Pixel Clock Generation (25MHz).
    -   RGB signal generation.

## Hardware Requirements
-   **Board**: RZ-EasyFPGA A2.1 / A2.2.
-   **Output**: VGA Monitor (via DB15 connector).

## Pin Assignments
The RZ-EasyFPGA A2.2 typically uses a 16-bit RGB565 interface. 
For simplicity, this project drives only the **Most Significant Bit (MSB)** of each color channel to create 8 basic colors (3-bit color depth).

-   **HSYNC**: PIN_101
-   **VSYNC**: PIN_103
-   **Red MSB**: PIN_106
-   **Green MSB**: PIN_105
-   **Blue MSB**: PIN_104

> [!NOTE]
> If colors look dim or wrong, your board might map the MSB to different pins. Check `Development_board_schematic_V2.1.pdf`.

## How to Run
1.  **Compile & Program** the board with `vga.qsf`.
2.  **Connect VGA Cable** to a monitor.
3.  **Verify**: You should see 8 distinct color bars (Black, Blue, Green, Cyan, Red, Magenta, Yellow, White).
