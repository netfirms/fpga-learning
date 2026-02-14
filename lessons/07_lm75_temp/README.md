# Lesson 7: Digital Thermometer (LM75)

This lesson reads the ambient temperature from the onboard **LM75** sensor via I2C and displays it in degrees Celsius.

## Overview
-   **Goal**: Communicate with the LM75 sensor using the I2C protocol and display the temperature.
-   **Key Concepts**:
    -   I2C (Inter-Integrated Circuit) protocol.
    -   Master/Slave communication.
    -   Reading registers.

## Hardware Requirements
-   **Board**: RZ-EasyFPGA A2.1 / A2.2.
-   **Sensor**: Onboard LM75 (or LM75A).

## Pin Assignments (CRITICAL CHECK)

> [!WARNING]
> Please verify the I2C Pins!
> This project assumes the standard RZ-EasyFPGA I2C pins:
> -   **SCL**: `PIN_112`
> -   **SDA**: `PIN_113`
>
> If your board uses different pins (check your schematic for `SCL` and `SDA` connected to the LM75), you MUST update `temp.qsf`.

## How to Run
1.  **Compile & Program** with `temp.qsf`.
2.  **Observe**:
    -   The 7-segment display should show the temperature in Celsius (e.g., `25` C).
    -   Touch the sensor (small 8-pin chip usually labeled LM75) to see the value rise.

## Controls
-   **SW1 (PIN_88)**: Toggle between **Celsius** (C) and **Fahrenheit** (F).
-   **Display Format**: `XX.F C` or `XX.F F`.
    -   Shows temperature with **0.5°C** resolution.

## Troubleshooting
-   **Display shows 00**: Communication failure (SDA/SCL stuck or wrong address).
-   **Display flickers**: Check power supply.
