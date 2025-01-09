#ifndef RESETDETECTOR_H
#define RESETDETECTOR_H

#define RESET_PIN 13

#include <Arduino.h>

extern void setup();

void setUpResetDetector();

void TASK_DETECT_RESET();

#endif