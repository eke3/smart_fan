`timescale 1ns / 1ps
// File:    test_adt7420_driver.sv
// Author:  Eric Ekey
// Date:    01/05/2025
// Desc:    Top-level module for reading temperature from the ADT7420 temperature sensor.
//          Displays temperature in Celsius and Fahrenheit on 7-segment display and LEDs.

module test_adt7420_driver (
    input logic CLK100MHZ,
    inout logic TMP_SDA,
    output logic TMP_SCL,
    output logic [6:0] SEG,
    output logic [7:0] AN,
    output logic [15:0] LED
);

    localparam [11:0] POWER_UP_TIME = 12'd0; // Set to 0 for normal operation, 12'd1950 for testing. 

    logic clk_200kHz;

    // Temperatures in Celsius and Fahrenheit.
    logic [7:0] temperature_c_reg;
    logic [7:0] temperature_f_reg;

    // Instantiate clock generator.
    adt7420_clock_generator clock_wizard (
        .clk_100MHz(CLK100MHZ),
        .clk_200kHz(clk_200kHz),
        .clk_10kHz(TMP_SCL)
    );

    // Instantiate ADT7420 I2C master.
    adt7420_i2c_master #(
        .POWER_UP_TIME(POWER_UP_TIME) 
    ) i2c_master (
        .clk_200kHz(clk_200kHz),
        .sda(TMP_SDA),
        .temperature(temperature_c_reg)
    );

    // Instantiate C to F temperature converter.
    temp_converter c2f (
        .temp_c(temperature_c_reg),
        .temp_f(temperature_f_reg)
    );

    // Instantiate 7-segment display controller.
    seg7_driver seg7 (
        .clk_100MHz(CLK100MHZ),
        .c_data(temperature_c_reg),
        .f_data(temperature_f_reg),
        .seg(SEG),
        .an(AN)
    );

    // Display binary temperature in Celsius and Fahrenheit on LEDs.
    assign LED = {temperature_f_reg, temperature_c_reg};
    
endmodule