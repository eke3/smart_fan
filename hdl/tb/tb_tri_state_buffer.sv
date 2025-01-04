// File: tb_tri_state_buffer.sv
// Author: Eric Ekey
// Date: 01/03/2025
// Description: Testbench for 1-bit tri-state buffer.

`timescale 1ns / 1ps

module tb_tri_state_buffer;
    // Clock.
    logic clk;

    // Inputs.
    logic data_in;
    logic enable;

    // Outputs.
    logic data_out;

    // Instantiate DUT.
    tri_state_buffer DUT (
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out)
    );

    // Stimulus process.
    initial begin
        // Transmit Z.
        data_in = 1'b1;
        enable = 1'b0;
        #20;

        data_in = 1'b0;
        enable = 1'b0;
        #20;

        // Transmit 0.
        data_in = 1'b0;
        enable = 1'b1;
        #20;

        // Transmit 1.
        data_in = 1'b1;
        enable = 1'b1;
        #20;

        // End simulation.
        $finish;
    end

    // Initialize clock process.
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end
    
    // Assert that data_out is correct.
    always @(data_out) begin
        // Check if the output is correct based on enable and data_in
        if ($time) begin
            assert (data_out == (enable ? data_in : 1'bZ)) else
                $error("Assertion failed at time %t: data_in = %b, enable = %b, data_out = %b", $time, data_in, enable, data_out);
        end
    end
    
endmodule
