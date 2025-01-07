`timescale 1ns / 1ps
// File:    tri_state_buffer.sv
// Author:  Eric Ekey
// Date:    01/03/2025
// Desc:    A simple 1-bit tri-state buffer.

module tri_state_buffer (
    input logic data_in,
    input logic enable,
    output logic data_out
);

    assign data_out = enable ? data_in : 1'bz;

endmodule