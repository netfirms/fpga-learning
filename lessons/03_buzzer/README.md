# Lesson 3: Passive Buzzer & PWM

This lesson demonstrates how to generate audio tones using the FPGA's passive buzzer.

## Overview
-   **Goal**: Play different musical notes when buttons are pressed.
-   **Key Concepts**:
    -   Square wave generation.
    -   Clock division for audio frequencies.
    -   Passive Piezo Buzzer control.

## Hardware Requirements
-   **Board**: RZ-EasyFPGA A2.1 / A2.2.
-   **Output**: Onboard Buzzer (PIN_110).
-   **Input**: 3 x Push Buttons.

## How to Run
1.  Open the project `buzzer.qsf` in Quartus Prime.
2.  Compile and Program the board.

## Expected Behavior
-   **SW1 (PIN_88)**: Plays Note **C4** (Do).
-   **SW2 (PIN_89)**: Plays Note **E4** (Re/Mi).
-   **SW3 (PIN_90)**: Plays Note **G4** (So).
-   **Release**: Silence.

Experiment by pressing multiple buttons (SW1 has priority) to verify the logic!
