# Lesson 6: PS/2 Keyboard Decoder

This lesson decodes keystrokes from a PS/2 keyboard and displays the hex "Scancode" on the 7-segment display.

## Overview
-   **Goal**: Connect a keyboard and visualize the raw data sent by keys.
-   **Key Concepts**:
    -   PS/2 Serial Protocol (Clock/Data).
    -   Scancodes (Make/Break codes).
    -   Interfacing with external peripherals.

## Hardware Requirements
-   **Board**: RZ-EasyFPGA A2.1 / A2.2.
-   **Input**: USB Keyboard (with USB-to-PS/2 adapter) OR native PS/2 Keyboard connected to the PS/2 port.

## Note on Keyboards
Many modern USB keyboards work with a simple **USB-to-PS/2 purple adapter passive**. 
However, some strict USB-only keyboards may not support the PS/2 protocol even with an adapter.
Use an older keyboard or one known to support PS/2 if possible.

## How to Run
1.  **Compile & Program** the board.
2.  **Connect Keyboard**: Plug it into the PS/2 port.
3.  **Press Keys**:
    -   The 2 rightmost digits on the display will show the **Hex Scancode**.
    -   **Releasing** a key sends a "Break Code" (F0) followed by the key code.

## Common Scancodes
-   `A`: **1C**
-   `B`: **32**
-   `Enter`: **5A**
-   `Space`: **29**
-   `ESC`: **76**

Example: Pressing 'A' shows `1C`. Releasing 'A' shows `1C` (Wait, logic shows last byte, so F0 then 1C? Or just F0?).
*Actually, the logic captures every byte. Release sequence is F0 -> 1C. So you might see F0 briefly then 1C, or just F0 depending on timing.*
