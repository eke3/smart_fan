#ifndef OPMODEDRIVER_H
#define OPMODEDRIVER_H

#define BUTTON_PIN 8

#include <Arduino.h>

extern constexpr int AUTO;

int opMode;

void setUpOpModeDriver();

void TASK_OP_MODE();

#endif