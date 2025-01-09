// File:    resetDetector.cpp
// Author:  Eric Ekey
// Date:    01/08/2025
// Desc:    This program detects a reset signal from the FPGA board and resets the microcontroller.

#include "resetDetector.h"

int reset = 0;

void setUpResetDetector() {
    reset = 0;
    pinMode(RESET_PIN, INPUT);
}

void TASK_DETECT_RESET() {
    reset = digitalRead(RESET_PIN);
    while (reset) {
        setup();
    }
}