`timescale 1ns / 1ps
// File:    tb_adt7420_clock_generator.sv
// Author:  Eric Ekey
// Date:    01/05/2025
// Desc:    Testbench for ADT7420 clock generator.

module tb_adt7420_clock_generator;
    // Inputs.
    logic clk_100MHz = 1'b0;

    // Outputs.
    logic clk_200kHz;
    logic clk_10kHz;

    // Testbench variables.
    int cycle_count_200kHz = 0;
    int cycle_count_10kHz = 0;

    // Instantiate DUT.
    adt7420_clock_generator DUT (
        .clk_100MHz(clk_100MHz),
        .clk_200kHz(clk_200kHz),
        .clk_10kHz(clk_10kHz)
    );

    // Stimulus process.
    initial begin
        #390000;

        $finish;
    end

    // Initialize clock process.
    initial begin
        #1;
        forever #10 clk_100MHz = ~clk_100MHz;
    end
    
    always_ff @(posedge clk_200kHz) cycle_count_200kHz = cycle_count_200kHz + 1;
    always_ff @(posedge clk_10kHz) cycle_count_10kHz = cycle_count_10kHz + 1;
    
endmodule