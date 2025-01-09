// File:    displayDriver.cpp
// Author:  Eric Ekey
// Date:    01/08/2025
// Desc:    This program controls an LCD display based on temperature readings received from an FPGA board and manual controls for the speed of a fan.

#include "displayDriver.h"

LiquidCrystal lcd(RS, EN, D4, D5, D6, D7);

String fanSpeedStr = "0";
String tempStr = "0";

// Function prototypes.
void setFanSpeedStr();
void setTempStr();
void dispFanSpeed();
void dispTemp();
void dispMode();

void setUpDisplayDriver() {
    fanSpeedStr = "0";
    tempStr = "0";
    lcd.begin(16, 2);
    lcd.clear();
    lcd.noCursor();
    lcd.home();
}

void TASK_DISPLAY() {
    setFanSpeedStr();
    setTempStr();
    dispFanSpeed();
    dispTemp();
    dispMode();
}

void setFanSpeedStr() {
    fanSpeedStr = String(fanSpeed);
}

void setTempStr() {
    tempStr = String(temperature);
}

void dispFanSpeed() {
    lcd.setCursor(0, 0);
    lcd.print(FAN_SPEED_LABEL);
    lcd.setCursor(0,1);
    lcd.print(fanSpeedStr);
}

void dispTemp() {
  int startPos = 0;
  String mode;
  startPos = 13 - tempStr.length() + 1;
  mode = (tempMode == FAHRENHEIT) ? DEGREE_F : DEGREE_C;

  lcd.setCursor(11, 1);
  lcd.print("     ");

  lcd.setCursor(startPos, 1);
  lcd.print(tempStr + mode);
}

void dispMode() {
    lcd.setCursor(10,0);
    lcd.print("      ");

    switch(opMode) {
      case AUTO:
        lcd.setCursor(12,0);
        lcd.print(AUTO_LABEL);
        break;
      case MANUAL:
        lcd.setCursor(10,0);
        lcd.print(MANUAL_LABEL);
        break;
    }
}