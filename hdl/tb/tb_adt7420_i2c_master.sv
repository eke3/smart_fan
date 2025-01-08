`timescale 1ns / 1ps
// File:    tb_adt7420_i2c_master.sv
// Author:  Eric Ekey
// Date:    01/05/2025
// Desc:    Testbench for ADT7420 I2C master.

module tb_adt7420_i2c_master;
    // Inputs.
    localparam [11:0] POWER_UP_TIME = 12'd1950;
    logic clk_200kHz;

    // Inouts.
    tri sda;

    // Instantiate DUT.
    adt7420_i2c_master #(
        .POWER_UP_TIME(POWER_UP_TIME)
    ) DUT (
        .clk_200kHz(clk_200kHz),
        .sda(sda),
        .temperature()
    );

    // Stimulus process.
    initial begin 
        #6000 $finish;
    end

    // Clock process.
    initial begin
        clk_200kHz = 1'b0;
        forever #1 clk_200kHz = ~clk_200kHz;
    end

endmodule