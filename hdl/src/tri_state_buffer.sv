// File: tri_state_buffer.sv
// Author: Eric Ekey
// Date: 01/03/2025
// Description: A simple 1-bit tri-state buffer.

`timescale 1ns / 1ps

module tri_state_buffer (
    input logic data_in,
    input logic enable,
    output logic data_out
);

    assign data_out = enable ? data_in : 1'bZ;

endmodule