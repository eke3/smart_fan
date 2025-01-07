`timescale 1ns / 1ps
// File:    temp_converter.sv
// Author:  Eric Ekey
// Date:    01/06/2025
// Desc:    Converts Celsius to Fahrenheit.

module temp_converter (
    input logic [7:0] temp_c,
    output logic [7:0] temp_f
);

    // Intermediate signal for calculating temperature in Fahrenheit.
    logic [15:0] temp_f_reg;
    
    always_comb begin
        temp_f_reg = temp_c * 9;
        temp_f_reg = temp_f_reg / 5;
        temp_f_reg = temp_f_reg + 32;
        temp_f = temp_f_reg[7:0];
    end

endmodule