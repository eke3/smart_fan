#ifndef FANDRIVER_H
#define FANDRIVER_H

#define FAN_PIN 9

#include <Arduino.h>

extern constexpr int AUTO;
extern constexpr int MANUAL;
extern constexpr int CELSIUS;
extern constexpr int FAHRENHEIT;

extern int temperature;
extern int tempMode;
extern int opMode;
extern int manualIntensity;

int fanSpeed;

void setUpFanDriver();

void TASK_FAN();

#endif