#ifndef DISPLAYDRIVER_H
#define DISPLAYDRIVER_H

#define AUTO_LABEL "AUTO"
#define MANUAL_LABEL "MANUAL"
#define DEGREE_F String((char)223)+"F"
#define DEGREE_C String((char)223)+"C"
#define FAN_SPEED_LABEL "FAN SPEED"
#define RS 12
#define EN 11
#define D4 5
#define D5 4
#define D6 3
#define D7 2

#include <Arduino.h>
#include <LiquidCrystal.h>

extern constexpr int FAHRENHEIT;
extern constexpr int AUTO;
extern constexpr int MANUAL;
extern int fanSpeed;
extern int opMode;
extern int tempMode;
extern int temperature;

void setUpDisplayDriver();

void TASK_DISPLAY();

#endif