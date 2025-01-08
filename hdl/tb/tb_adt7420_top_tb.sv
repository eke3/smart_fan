`timescale 1ns / 1ps
// File:    tb_adt7420_top.sv
// Author:  Eric Ekey
// Date:    01/05/2025
// Desc:    Testbench for adt7420_top.

module tb_adt7420_top;
    // Acknowledge signal to send after receiving ADT7420 address and R/W from I2C master.
    localparam ADT2740_ACK = 1'b0;

    // Inputs.
    localparam [11:0] POWER_UP_TIME = 12'd1950;
    logic CLK100MHZ;

    // Inouts.
    tri sda_bidirectional;
    logic adt2740_sda_out;

    // Outputs.
    logic [7:0] temperature_c;
    logic [7:0] temperature_f;
    logic scl;

    // Instantiate DUT.
    top_adt7420_driver #(
        .POWER_UP_TIME(POWER_UP_TIME)
    ) DUT (
        .clk_100MHz(CLK100MHZ),
        .sda(sda_bidirectional),
        .temperature_c(temperature),
        .temperature_f(temperature_f),
        .scl(scl)
    );

    // Stimulus process.
    initial begin
        adt2740_sda_out = 1'bz;
        
        // Start sending MSB to I2C master when it finishes transmitting address and R/W.
        #(48999 + 170000 /*time until end of S_SEND_RW*/);
        adt2740_sda_out = ADT2740_ACK; #20000;
        adt2740_sda_out = 1'b0; #20000; // MSB[7]
        adt2740_sda_out = 1'b0; #20000; // MSB[6]
        adt2740_sda_out = 1'b1; #20000; // MSB[5]
        adt2740_sda_out = 1'b0; #20000; // MSB[4]
        adt2740_sda_out = 1'b1; #20000; // MSB[3]
        adt2740_sda_out = 1'b0; #20000; // MSB[2]
        adt2740_sda_out = 1'b0; #20000; // MSB[1]
        adt2740_sda_out = 1'b0; #20000; // MSB[0]
        
        // Receive acknowledgement of MSB reception from I2C master, on SDA line.
        adt2740_sda_out = 1'bz; #20000;
        
        // Send LSB to I2C master.
        adt2740_sda_out = 1'b1; #20000; // LSB[7]
        adt2740_sda_out = 1'b0; #20000; // LSB[6]
        adt2740_sda_out = 1'b0; #20000; // LSB[5]
        adt2740_sda_out = 1'b0; #20000; // LSB[4]
        adt2740_sda_out = 1'b0; #20000; // LSB[3]
        adt2740_sda_out = 1'b0; #20000; // LSB[2]
        adt2740_sda_out = 1'b0; #20000; // LSB[1]
        adt2740_sda_out = 1'b0; #20000; // LSB[0]
        
        // Receive null-acknowledgement of MSB reception from I2C master, on SDA line.
        adt2740_sda_out = 1'bz; #30000;
        
        #20000 $finish;
    end

    // Clock process.
    initial begin
        CLK100MHZ = 1'b0;
        forever #1 CLK100MHZ = ~CLK100MHZ;
    end
    
    // Manage SDA assignment.
    assign sda_bidirectional = adt2740_sda_out;

endmodule