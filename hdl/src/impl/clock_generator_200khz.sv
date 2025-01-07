`timescale 1ns / 1ps
// File:    clock_generator_200khz.sv
// Author:  Eric Ekey
// Date:    01/05/2025
// Desc:    Derives 200kHz clock from 100MHz clock.

module clock_generator_200khz (
    input logic clk_100MHz,
    output logic clk_200kHz
);

    // Division factor for 200kHz clock.
    // 100MHz / 200kHz = 500 (full period). 500 / 2 = 250 (half period).
    // 250 cycles of clk_100MHz = 1 half-cycle of clk_200kHz.

    // Counters for derived clock.
    logic [7:0] clk_200kHz_counter = 8'd0;

    // Derived clock.
    logic clk_200kHz_reg = 1'b1;

    // Generate 200kHz clock.
    always_ff @(posedge clk_100MHz) begin
        clk_200kHz_reg <= clk_200kHz_reg;
        if (clk_200kHz_counter == 249) begin
            clk_200kHz_counter <= 8'd0;
            clk_200kHz_reg <= ~clk_200kHz_reg;
        end else begin
            clk_200kHz_counter <= clk_200kHz_counter + 1;
        end
    end

    // Assign derived clock to output.
    assign clk_200kHz = clk_200kHz_reg;

endmodule