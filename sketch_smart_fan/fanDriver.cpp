// File:    fanDriver.cpp
// Author:  Eric Ekey
// Date:    01/08/2025
// Desc:    This program controls a fan based on temperature readings received from an FPGA board.

#include "fanDriver.h"

int fanIntensity = 0;
// int fanSpeed = 0;

// Function prototypes.
void setFanIntensity();
int setFanIntensityManual();
int setFanIntensityCelsius();
int setFanIntensityFahrenheit();
void setFanSpeed();
void runFan();

void setUpFanDriver() {
    fanIntensity = 0;
    fanSpeed = 0;
    pinMode(FAN_PIN, OUTPUT);
    analogWrite(FAN_PIN, 0);
}

void TASK_FAN() {
    setFanIntensity();
    setFanSpeed();
    runFan();
}

void setFanIntensity() {
    int intensity = 0;
    
    switch (opMode) {
      case AUTO:
        switch (tempMode) {
            case CELSIUS:
                intensity = setFanIntensityCelsius();
                break;
            case FAHRENHEIT:
                intensity = setFanIntensityFahrenheit();
                break;
            }
        break;
      case MANUAL:
        intensity = setFanIntensityManual();
        break;
    }

    fanIntensity = intensity;
}

int setFanIntensityManual() {
    return manualIntensity;
}

int setFanIntensityCelsius() {
    if (temperature < 21) {
      return 0;
    }
    if (temperature >= 21 && temperature < 24) {
      return 150;
    }
    if (temperature >= 24) {
      return 255;
    }
}

int setFanIntensityFahrenheit() {  
    if (temperature < 69) {
      return 0;
    }
    if (temperature >= 69 && temperature < 75) {
      return 150;
    }
    if (temperature >= 75) {
      return 255;
    }
}

void setFanSpeed() {
    int speed = 0;

    if (fanIntensity < 150) {
      speed = 0;
    } else if (fanIntensity >= 150 && fanIntensity < 255) {
      speed = 1;
    } else if (fanIntensity >= 250) {
      speed = 2;
    }

    fanSpeed = speed;
}

void runFan() { 
    analogWrite(FAN_PIN, fanIntensity);
}