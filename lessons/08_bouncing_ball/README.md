# Lesson 8: Bouncing Ball Game

This lesson implements a simple physics demo using the VGA controller.

## Overview
-   **Goal**: Display a red square bouncing off the screen edges.
-   **Resolution**: 640x480 @ 60Hz.
-   **Key Concepts**:
    -   Game Logic / Physics loop.
    -   Object rendering.
    -   Collision detection.

## Hardware Requirements
-   **Board**: RZ-EasyFPGA A2.1 / A2.2.
-   **Output**: VGA Monitor.

## Controls
-   **Reset (nRESET / KEY)**: PIN_25 (Check if this is a key on your board, otherwise map to SW1).
    -   Resets the ball to the center of the screen.

## How it Works
1.  **VGA_Sync**: Generates the monitor timing signals.
2.  **Ball_Logic**: Updates the ball's X and Y coordinates every frame (vertical sync). If the ball hits a wall (0 or Max Width/Height), its velocity is inverted.
3.  **Game_Top**: Checks if the current pixel being drawn is inside the ball's coordinates. If so, it outputs Red color.

## Troubleshooting
-   **Screen Black**: Check VGA cable and monitor input.
-   **Ball Stuck**: Press Reset.
