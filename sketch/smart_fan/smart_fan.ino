// File: smart_fan.ino
// Author: Eric Ekey
// Date: 01/03/2025
// Desc: This program controls a fan based on temperature readings received from an FPGA board. 
// The FPGA communicates the temperature to the microcontroller using one of three protocols (I2C, UART,
// or SPI), as specified by this program. A push button toggles the mode between "auto" and "manual". 
// In "auto" mode, the fan speed is adjusted based on the current temperature, while in "manual" mode,
// the fan speed is controlled by a potentiometer. This program prompts the user via the serial monitor
// to set a starting temperature and allows changes throughout operation. The LCD displays the current
// operating mode, temperature, and fan speed at all times.

void setup() {
  // put your setup code here, to run once:

}

void loop() {
  // put your main code here, to run repeatedly:

}
