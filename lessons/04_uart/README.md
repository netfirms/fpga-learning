# Lesson 4: UART Serial Communication

This lesson implements a **UART Loopback (Echo)** system.
Whatever you type in a serial terminal on your PC will be sent to the FPGA and immediately sent back (echoed) to your screen.

## Overview
-   **Goal**: Establish reliable serial communication between FPGA and PC.
-   **Config**:
    -   **Baud Rate**: 115200
    -   **Data Bits**: 8
    -   **Parity**: None
    -   **Stop Bits**: 1
    -   (Commonly written as 115200 8N1)

## Hardware Requirements
-   **Board**: RZ-EasyFPGA A2.1 / A2.2.
-   **Connection**: USB-to-Serial cable connected to the FPGA's UART header OR the onboard USB-Serial chip (if equipped and connected to PIN_10/11).
    -   **TX**: PIN_11
    -   **RX**: PIN_10

## How to Run
1.  **Compile & Program** the board with `uart.qsf`.
2.  **Connect** your board to PC via USB.
3.  **Identify COM Port**: Check Device Manager (Windows) or `/dev/ttyUSB*` (Linux).
4.  **Open Terminal**: Use Putty, TeraTerm, Minicom, or Screen.
    -   Set Baud Rate to **115200**.
5.  **Test**:
    -   Type characters on your keyboard.
    -   If working, you will see them appear on the terminal window.
    -   The onboard **LEDs** will also flash showing the binary pattern of the character you typed.

## Troubleshooting
-   **Garbage Characters**: Likely a baud rate mismatch. Ensure software is set to 115200.
-   **No Output**: Check TX/RX pin swap. Try swapping PIN_10 and PIN_11 in `uart.qsf` if your board layout differs.
