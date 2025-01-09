// File:    sketch_smart_fan.ino
// Author:  Eric Ekey
// Date:    01/03/2025
// Desc:    This program controls a fan based on temperature readings received from an FPGA board.
//          The FPGA communicates the temperature to the microcontroller using one of three protocols (I2C,
//          UART, or SPI), as specified by this program. A push button toggles the mode between "auto" and
//          "manual". In "auto" mode, the fan speed is adjusted based on the current temperature, while in
//          "manual" mode, the fan speed is controlled by a potentiometer. This program prompts the user via
//          the serial monitor to set a starting temperature and allows changes throughout operation. The LCD
//          displays the current operating mode, temperature, and fan speed at all times.

#include "displayDriver.h"
#include "fanDriver.h"
#include "resetDetector.h"
#include "opModeDriver.h"

constexpr int CELSIUS = 0;
constexpr int FAHRENHEIT = 1;
constexpr int AUTO = 1;
constexpr int MANUAL = 0;


int temperature; // will move to another file
int tempMode = 0;

extern void setUpFanDriver();
extern void TASK_FAN();

extern void setUpDisplayDriver();
extern void TASK_DISPLAY();

/*** Pending Implementations ***/
// extern void setUpManualInput();
// extern void TASK_READ_MANUAL(); // from potentiometer

// extern void setUpAutoInput();
// extern void TASK_READ_AUTO(); // from fpga board

extern void setUpOpModeDriver();
extern void TASK_OP_MODE();

extern void setUpResetDetector();
extern void TASK_DETECT_RESET();

void (*taskQueue[7])();

void setup() {
  tempMode = FAHRENHEIT;

  // setUpAutoInput();
  // setUpManualInput();
  setUpFanDriver();
  setUpDisplayDriver();
  setUpOpModeDriver();
  setUpResetDetector();

  // initialize the task queue
  // taskQueue[0] = TASK_READ_AUTO;
  // taskQueue[1] = TASK_READ_MANUAL;
  taskQueue[2] = TASK_FAN;
  taskQueue[3] = TASK_DISPLAY;
  taskQueue[4] = TASK_OP_MODE;
  taskQueue[5] = TASK_DETECT_RESET;
  taskQueue[6] = NULL;

}

void loop() {
  int i = 0;
  while (taskQueue[i] != NULL) {
    (*taskQueue[i])();
    i++;
  }
}

