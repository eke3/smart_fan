`timescale 1ns / 1ps
// File:    top_adt7420_driver.sv
// Author:  Eric Ekey
// Date:    01/05/2025
// Desc:    Top-level module for reading temperature from the ADT7420 temperature sensor.

module top_adt7420_driver #(
    // Do not change. Default 0 for normal operation. 
    // Set to 1950 to shorten powerup time in testbench.
    parameter POWER_UP_TIME = 12'd0 
)(
    input logic clk_100MHz,
    inout logic sda,
    output logic [7:0] temperature_c, // 8-bit binary temperature in Celsius.
    output logic [7:0] temperature_f, // 8-bit binary temperature in Fahrenheit.
    output logic scl
);

    logic clk_200kHz;

    // Temperatures in Celsius and Fahrenheit.
    logic [7:0] temperature_c_reg;
    logic [7:0] temperature_f_reg;

    // Instantiate clock generator.
    adt7420_clock_generator clock_wizard (
        .clk_100MHz(clk_100MHz),
        .clk_200kHz(clk_200kHz),
        .clk_10kHz(scl)
    );

    // Instantiate ADT7420 I2C master.
    adt7420_i2c_master #(
        .POWER_UP_TIME(POWER_UP_TIME) 
    ) adt7420_i2c_master (
        .clk_200kHz(clk_200kHz),
        .sda(sda),
        .temperature(temperature_reg)
    );

    // Instantiate C to F temperature converter.
    temp_converter c2f (
        .temp_c(temperature_c_reg),
        .temp_f(temperature_f_reg)
    );

    // Assign temperatures to output ports.
    assign {temperature_c, temperature_f} = {temperature_c_reg, temperature_f_reg};

endmodule