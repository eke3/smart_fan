# Smart Fan Control
**Contributors**

Eric Ekey

## Description

This project controls a fan based on temperature readings received from an FPGA board (Nexys A7) and an Arduino Uno R3 microcontroller. The FPGA reads temperature data from an ADT7420 temperature sensor via I2C and communicates it to the Arduino using one of three protocols (I2C, UART, or SPI). The program allows the user to toggle between "auto" and "manual" modes using a push button. 

In **auto mode**, the fan speed is adjusted based on the current temperature, while in **manual mode**, the fan speed is controlled using a potentiometer. The current operating mode, temperature, and fan speed are displayed on an LCD screen. The program also prompts the user via the serial monitor to set a starting temperature, with the ability to change it during operation.

## Features

- **Auto Mode**: Fan speed adjusts automatically based on the temperature.
- **Manual Mode**: Fan speed is controlled by a potentiometer.
- **Temperature Input**: The user can set a starting temperature and adjust it via the serial monitor.
- **LCD Display**: Displays current mode, temperature, and fan speed.
- **Protocol Selection**: Choose between I2C, UART, or SPI communication for temperature data exchange.
- **Push Button**: Toggles between auto and manual modes.

## Hardware

- **Nexys A7 FPGA Board**: Reads temperature from the ADT7420 temperature sensor via I2C.
- **Arduino UNO R3**: Controls the fan and displays information on the LCD.
- **ADT7420 Temperature Sensor**: Measures the temperature and sends it to the FPGA board.
- **LCD Display**: Displays current operating mode, temperature, and fan speed.
- **Push Button**: Used to toggle between auto and manual modes.
- **Potentiometer**: Used to manually control fan speed in manual mode.
- **Fan**: Controlled by the Arduino for speed adjustments.

## Communication Protocols

- **I2C**: The FPGA board communicates with the temperature sensor and the Arduino over I2C.
- **UART**: The FPGA board can communicate with the Arduino via UART.
- **SPI**: The FPGA board can also communicate with the Arduino via SPI.

## Installation

1. **Clone the Repository:**
```bash
git clone https://github.com/eke3/smart_fan.git
```

2. **Setup the FPGA:**
- Use the provided FPGA top.bit file to program a Nexys A7 FPGA board.
- You can ensure the FPGA reads temperature data from the ADT7420 sensor by programming it with test_adt7420.bit and seeing the temperature on the seven segment display.

3. **Arduino Setup:**
- Upload the `sketch_smart_fan.ino` file to your Arduino UNO.
- Connect the Arduino to the FPGA board per the provided schematic. Choose a communication protocol (I2C, UART, or SPI) using the buttons on the Nexys A7.
- Connect the LCD display, push button, and potentiometer as per the schematic diagram.

## Usage

1. **Auto Mode**: 
- In this mode, the fan speed adjusts based on the temperature read from the ADT7420 sensor.
- The LCD will display the current temperature and fan speed.

2. **Manual Mode**:
- In manual mode, you control the fan speed using a potentiometer.
- The LCD will display the current mode and fan speed controlled by the potentiometer.
