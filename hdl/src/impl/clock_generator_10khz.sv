`timescale 1ns / 1ps
// File:    clock_generator_10khz.sv
// Author:  Eric Ekey
// Date:    01/05/2025
// Desc:    Derives 10kHz clock from 200kHz clock.

module clock_generator_10khz (
    input logic clk_200kHz,
    output logic clk_10kHz
);

    // Division factor for 200kHz clock.
    // 200kHz / 10kHz = 20 (full period). 20 / 2 = 10 (half period).
    // 10 cycles of clk_200kHz = 1 half-cycle of clk_10kHz.

    // Counters for derived clock.
    logic [3:0] clk_10kHz_counter = 4'd0;

    // Derived clock.
    logic clk_10kHz_reg = 1'b1;

    // Generate 10kHz clock.
    always_ff @(posedge clk_200kHz) begin
        clk_10kHz_reg <= clk_10kHz_reg;
        if (clk_10kHz_counter == 9) begin
            clk_10kHz_counter <= 4'd0;
            clk_10kHz_reg <= ~clk_10kHz_reg;
        end else begin
            clk_10kHz_counter <= clk_10kHz_counter + 1;
        end
    end

    // Output 10kHz clock.
    assign clk_10kHz = clk_10kHz_reg;

endmodule
