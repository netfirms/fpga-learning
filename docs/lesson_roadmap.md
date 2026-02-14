# FPGA Lesson Roadmap (RZ-EasyFPGA)

This roadmap outlines a structured learning path to master the peripherals on the **RZ-EasyFPGA A2.2** board.

## Completed
- [x] **01_led**: Basic IO (LEDs & Switches).
- [x] **02_sev_seg_count**: Time-division multiplexing, BCD counters, Debouncing.

## Proposed Lessons (Beginner)

### Lesson 3: Passive Buzzer & PWM
-   **Goal**: Play different tones or a simple melody (e.g., Mario theme).
-   **Concepts**:
    -   Generating precise frequencies (Clock Division).
    -   **PWM** (Pulse Width Modulation) for volume control (optional).
    -   State machines for sequencing notes.
-   **Peripherals**: Buzzer (PIN_110).

### Lesson 4: UART Serial Communication
-   **Goal**: Send "Hello World" to the PC and control FPGA LEDs via keyboard commands from a terminal (e.g., Putty/Minicom).
-   **Concepts**:
    -   Async Serial Protocol (RS-232/UART).
    -   Baud rate generation (9600/115200).
    -   TX/RX Shift registers.
-   **Peripherals**: UART (PIN_11 TX, PIN_10 RX).

## Proposed Lessons (Intermediate)

### Lesson 5: VGA Controller (Color Bars)
-   **Goal**: Drive a VGA monitor to display static color bars or a checkerboard pattern.
-   **Concepts**:
    -   Video timing (HSYNC, VSYNC, Front/Back Porch).
    -   Pixel clock generation (PLL usage).
    -   RGB color signal generation.
-   **Peripherals**: VGA Port.

### Lesson 6: PS/2 Keyboard Decoder
-   **Goal**: Connect a USB/PS2 keyboard and display the pressed key's hex code on the 7-segment display.
-   **Concepts**:
    -   Synchronous Serial Communication.
    -   Clock domains (Keyboard clock vs System clock).
    -   Scancode decoding.
-   **Peripherals**: PS/2 Port, 7-Segment Display.

## Proposed Lessons (Advanced)

### Lesson 7: Digital Thermometer (I2C)
-   **Goal**: Read temperature from the onboard **LM75** sensor and display it on the 7-segment display.
-   **Concepts**:
    -   **I2C** (Inter-Integrated Circuit) Protocol.
    -   Bidirectional (Tri-state) buffers (`inout` ports).
    -   Register reading/writing.
-   **Peripherals**: LM75 Chip.

### Lesson 8: Bouncing Ball Game (VGA + Inputs)
-   **Goal**: Create a simple "Pong" style game on the VGA monitor controlled by buttons.
-   **Concepts**:
    -   Sprite/Object rendering.
    -   Collision detection logic.
    -   Game loops in hardware.

---
**Recommendation**: Start with **Lesson 3 (Buzzer)** for a fun, audible reward, or **Lesson 4 (UART)** to unlock powerful debugging capabilities.
