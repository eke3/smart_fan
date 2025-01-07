`timescale 1ns / 1ps
// File:    adt7420_i2c_master.sv
// Author:  Eric Ekey
// Date:    01/05/2025
// Desc:    I2C master for the ADT7420 temperature sensor.

module adt7420_i2c_master #(
    // Do not change in this file. Set to 0 for normal operation.
    parameter [11:0] POWER_UP_TIME = 12'd0
)(
    input logic clk_200kHz,
    inout logic sda,
    output logic [7:0] temperature // 8-bit binary temperature in Celsius.
);

    localparam [7:0] SENSOR_ADDR = 7'h4B; // ADT7420 I2C address.
    localparam RW = 1'b1; // Always reading.
    localparam SENSOR_ADDR_PLUS_RW = {SENSOR_ADDR[6:0], RW}; // 0x97 or 1001_0111

    // I2C communication states.
    typedef enum {
        S_POWER_UP,
        S_START,
        S_SEND_ADDR6,
        S_SEND_ADDR5,
        S_SEND_ADDR4,
        S_SEND_ADDR3,
        S_SEND_ADDR2,
        S_SEND_ADDR1,
        S_SEND_ADDR0,
        S_SEND_RW,
        S_RECEIVE_ACK,
        S_RECEIVE_MSB7,
        S_RECEIVE_MSB6,
        S_RECEIVE_MSB5,
        S_RECEIVE_MSB4,
        S_RECEIVE_MSB3,
        S_RECEIVE_MSB2,
        S_RECEIVE_MSB1,
        S_RECEIVE_MSB0,
        S_SEND_ACK,
        S_RECEIVE_LSB7,
        S_RECEIVE_LSB6,
        S_RECEIVE_LSB5,
        S_RECEIVE_LSB4,
        S_RECEIVE_LSB3,
        S_RECEIVE_LSB2,
        S_RECEIVE_LSB1,
        S_RECEIVE_LSB0,
        S_SEND_NACK
    } state_i2c_master_t;

    // Current state and next state.
    state_i2c_master_t CS = S_POWER_UP;
    state_i2c_master_t NS;

    // Byte registers.
    logic [7:0] msb_reg = 8'b0;
    logic [7:0] lsb_reg = 8'b0;

    // Register for temperature data.
    logic [7:0] temperature_reg;

    // Registers for bi-directional I2C interface.
    logic sda_out_reg = 1'b1;
    logic sda_in_reg;
    logic sda_direction;

    // Clock counter.
    logic [11:0] clk_200kHz_counter = 12'd0;

    always_ff @(posedge clk_200kHz) begin
        msb_reg <= msb_reg;
        lsb_reg <= lsb_reg;
        sda_out_reg <= sda_out_reg;
        clk_200kHz_counter <= clk_200kHz_counter + 1;
        temperature_reg <= temperature_reg;
        CS <= CS;

        if (CS == S_SEND_NACK)
            temperature_reg <= {msb_reg[6:0], lsb_reg[7]};

        // State machine for I2C communication.
        unique0 case (CS)
            S_POWER_UP: begin
                if (clk_200kHz_counter == (12'd1999 - POWER_UP_TIME)) 
                    NS = S_START;
            end
            S_START: begin
                if (clk_200kHz_counter == (12'd2004 - POWER_UP_TIME))
                    sda_out_reg <= 1'b0;
                if (clk_200kHz_counter == (12'd2013 - POWER_UP_TIME)) 
                    NS = S_SEND_ADDR6;
            end
            S_SEND_ADDR6: begin
                sda_out_reg <= SENSOR_ADDR_PLUS_RW[7];
                if (clk_200kHz_counter == (12'd2033 - POWER_UP_TIME)) 
                    NS = S_SEND_ADDR5;
            end
            S_SEND_ADDR5: begin
                sda_out_reg <= SENSOR_ADDR_PLUS_RW[6];
                if (clk_200kHz_counter == (12'd2053 - POWER_UP_TIME)) 
                    NS = S_SEND_ADDR4;
            end
            S_SEND_ADDR4: begin
                sda_out_reg <= SENSOR_ADDR_PLUS_RW[5];
                if (clk_200kHz_counter == (12'd2073 - POWER_UP_TIME)) 
                    NS = S_SEND_ADDR3;
            end
            S_SEND_ADDR3: begin
                sda_out_reg <= SENSOR_ADDR_PLUS_RW[4];
                if (clk_200kHz_counter == (12'd2093 - POWER_UP_TIME)) 
                    NS = S_SEND_ADDR2;
            end
            S_SEND_ADDR2: begin
                sda_out_reg <= SENSOR_ADDR_PLUS_RW[3];
                if (clk_200kHz_counter == (12'd2113 - POWER_UP_TIME)) 
                    NS = S_SEND_ADDR1;
            end
            S_SEND_ADDR1: begin
                sda_out_reg <= SENSOR_ADDR_PLUS_RW[2];
                if (clk_200kHz_counter == (12'd2133 - POWER_UP_TIME)) 
                    NS = S_SEND_ADDR0;
            end
            S_SEND_ADDR0: begin
                sda_out_reg <= SENSOR_ADDR_PLUS_RW[1];
                if (clk_200kHz_counter == (12'd2153 - POWER_UP_TIME)) 
                    NS = S_SEND_RW;
            end
            S_SEND_RW: begin
                sda_out_reg <= SENSOR_ADDR_PLUS_RW[0];
                if (clk_200kHz_counter == (12'd2169 - POWER_UP_TIME)) 
                    NS = S_RECEIVE_ACK;
            end
            S_RECEIVE_ACK: begin
                if (clk_200kHz_counter == (12'd2189 - POWER_UP_TIME))
                    NS = S_RECEIVE_MSB7;
            end
            S_RECEIVE_MSB7: begin
                if (clk_200kHz_counter == (12'd2209 - POWER_UP_TIME))
                    NS = S_RECEIVE_MSB6;
                else
                    msb_reg[7] <= sda_in_reg;    
            end
            S_RECEIVE_MSB6: begin
                if (clk_200kHz_counter == (12'd2229 - POWER_UP_TIME))
                    NS = S_RECEIVE_MSB5;
                else 
                    msb_reg[6] <= sda_in_reg;
            end
            S_RECEIVE_MSB5: begin
                if (clk_200kHz_counter == (12'd2249 - POWER_UP_TIME))
                    NS = S_RECEIVE_MSB4;
                else
                    msb_reg[5] <= sda_in_reg;
            end
            S_RECEIVE_MSB4: begin
                if (clk_200kHz_counter == (12'd2269 - POWER_UP_TIME))
                    NS = S_RECEIVE_MSB3;
                else
                    msb_reg[4] <= sda_in_reg;
            end
            S_RECEIVE_MSB3: begin
                if (clk_200kHz_counter == (12'd2289 - POWER_UP_TIME))
                    NS = S_RECEIVE_MSB2;
                else
                    msb_reg[3] <= sda_in_reg;
            end
            S_RECEIVE_MSB2: begin
                if (clk_200kHz_counter == (12'd2309 - POWER_UP_TIME))
                    NS = S_RECEIVE_MSB1;
                else
                    msb_reg[2] <= sda_in_reg;
            end
            S_RECEIVE_MSB1: begin
                if (clk_200kHz_counter == (12'd2329 - POWER_UP_TIME))
                    NS = S_RECEIVE_MSB0;
                else
                    msb_reg[1] <= sda_in_reg;
            end
            S_RECEIVE_MSB0: begin
                sda_out_reg <= 1'b0;
                if (clk_200kHz_counter == (12'd2349 - POWER_UP_TIME)) 
                    NS = S_SEND_ACK;
                else
                    msb_reg[0] <= sda_in_reg;
            end
            S_SEND_ACK: begin
                if (clk_200kHz_counter == (12'd2369 - POWER_UP_TIME)) 
                    NS = S_RECEIVE_LSB7;
            end
            S_RECEIVE_LSB7: begin
                if (clk_200kHz_counter == (12'd2389 - POWER_UP_TIME))
                    NS = S_RECEIVE_LSB6;
                else
                    lsb_reg[7] <= sda_in_reg;
            end
            S_RECEIVE_LSB6: begin
                if (clk_200kHz_counter == (12'd2409 - POWER_UP_TIME))
                    NS = S_RECEIVE_LSB5;
                else
                    lsb_reg[6] <= sda_in_reg;
            end
            S_RECEIVE_LSB5: begin
                if (clk_200kHz_counter == (12'd2429 - POWER_UP_TIME))
                    NS = S_RECEIVE_LSB4;
                else
                    lsb_reg[5] <= sda_in_reg;
            end
            S_RECEIVE_LSB4: begin
                if (clk_200kHz_counter == (12'd2449 - POWER_UP_TIME))
                    NS = S_RECEIVE_LSB3;
                else 
                    lsb_reg[4] <= sda_in_reg;
            end
            S_RECEIVE_LSB3: begin
                if (clk_200kHz_counter == (12'd2469 - POWER_UP_TIME))
                    NS = S_RECEIVE_LSB2;
                else
                    lsb_reg[3] <= sda_in_reg;
            end
            S_RECEIVE_LSB2: begin
                if (clk_200kHz_counter == (12'd2489 - POWER_UP_TIME))
                    NS = S_RECEIVE_LSB1;
                else
                    lsb_reg[2] <= sda_in_reg;
            end
            S_RECEIVE_LSB1: begin
                if (clk_200kHz_counter == (12'd2509 - POWER_UP_TIME))
                    NS = S_RECEIVE_LSB0;
                else
                    lsb_reg[1] <= sda_in_reg;
            end
            S_RECEIVE_LSB0: begin
                sda_out_reg <= 1'b1;
                if (clk_200kHz_counter == (12'd2529 - POWER_UP_TIME)) 
                    NS = S_SEND_NACK;
                else
                    lsb_reg[0] <= sda_in_reg;
            end
            S_SEND_NACK: begin
                if (clk_200kHz_counter == (12'd2559 - POWER_UP_TIME)) begin
                    clk_200kHz_counter <= (12'd2000 - POWER_UP_TIME);
                    NS = S_START;
                end
            end
        endcase
        CS <= NS;
    end

    // Data coming in from SDA bidirectional inout signal.
    assign sda_in_reg = sda;
    
    // Control direction of SDA bidirectional inout signal (1 for output, 0 for input).
    assign sda_direction = (
        CS == S_POWER_UP || CS == S_START || 
        CS == S_SEND_ADDR6 || CS == S_SEND_ADDR5 || 
        CS == S_SEND_ADDR4 || CS == S_SEND_ADDR3 || 
        CS == S_SEND_ADDR2 || CS == S_SEND_ADDR1 || 
        CS == S_SEND_ADDR0 || CS == S_SEND_RW || 
        CS == S_SEND_ACK || CS == S_SEND_NACK
    ) ? 1'b1 : 1'b0;

    // Tri-state buffer for SDA bidirectional inout signal.
    tri_state_buffer sda_tri_state_buffer (
        .data_in(sda_out_reg), 
        .enable(sda_direction), 
        .data_out(sda)
    );

    // Assign temperature output.
    assign temperature = temperature_reg;

endmodule
