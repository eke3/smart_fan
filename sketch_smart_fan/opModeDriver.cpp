
// File:    opModeDriver.cpp
// Author:  Eric Ekey
// Date:    01/08/2025
// Desc:    This program toggles the operating mode of the fan between "auto" and "manual" based on button presses.

#include "opModeDriver.h"

// Flag indicating a valid button press was detected and has not yet been responded to.
bool buttonWasPressed;

// Current and previous readings from the button.
int buttonState, lastButtonState;

// The last time the button state changed.
unsigned long lastDebounceTime;  

// The debounce time. Increase if the output flickers.
unsigned long debounceDelay;    

// Function prototypes.
void getButtonPress();
void toggleOpMode();

void setUpOpModeDriver() {
  lastButtonState = 0;
  buttonWasPressed = false;
  lastDebounceTime = 0;
  debounceDelay = 50;
  opMode = AUTO;
  pinMode(BUTTON_PIN, INPUT);
}

void TASK_OP_MODE() {
  getButtonPress();
  toggleOpMode();
}

// void getButtonPress()
// Reads the button state and sets the buttonWasPressed flag if a valid button press is detected.
// Preconditions: Button pin is initialized.
// Postconditions: The buttonWasPressed flag is raised if a valid button press is detected.
void getButtonPress() {
  // Read the button state.
  int reading = digitalRead(BUTTON_PIN);

  // If the button state changed, due to noise or pressing:
  if (reading != lastButtonState) {
    // Reset the debouncing timer.
    lastDebounceTime = millis();
  }

  if ((millis() - lastDebounceTime) > debounceDelay) {
    // Reading has been there for longer than the debounce delay.
    // If the button state has changed:
    if (reading != buttonState) {
      buttonState = reading;

      // Raise the flag if the new button state is HIGH.
      if (buttonState == 1) {
        buttonWasPressed = true;
      }
    }
  }

  // Save the reading for the next loop.
  lastButtonState = reading;
}

void toggleOpMode() {
  if (buttonWasPressed) {
    opMode = !opMode;
    buttonWasPressed = false;
  }
}