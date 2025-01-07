`timescale 1ns / 1ps
// File:    adt7420_clock_generator.sv
// Author:  Eric Ekey
// Date:    01/05/2025
// Desc:    Derives 200kHz clock and 10kHz clock from 100MHz clock, to use for I2C communication
//          with the ADT7420 temperature sensor.

module adt7420_clock_generator (
    input logic clk_100MHz,
    output logic clk_200kHz,
    output logic clk_10kHz
);

    // Instantiate clock generators.
    clock_generator_200khz clock_generator_200khz (
        .clk_100MHz(clk_100MHz),
        .clk_200kHz(clk_200kHz)
    );
    
    clock_generator_10khz clock_generator_10khz (
        .clk_200kHz(clk_200kHz),
        .clk_10kHz(clk_10kHz)
    );

endmodule
