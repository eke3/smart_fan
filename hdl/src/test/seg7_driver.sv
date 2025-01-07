`timescale 1ns / 1ps
// Created by David J. Marion
// Date 7.19.2022
// 7 Segment Control for the Nexys A7 Temperature Sensor
// Edited 4.28.2023

module seg7_driver(
    input logic clk_100MHz,               // Nexys A7 clock
    input logic [7:0] c_data,             // Temp data from i2c master
    input logic [7:0] f_data,             // Temp data from temp converter
    output logic [6:0] seg,           // 7 Segments of Displays
    output logic [7:0] an             // 4 Anodes of 8 to display Temp C
);
    
    // Binary to BCD conversion of temperature data
    logic [3:0] c_tens, c_ones;
    assign c_tens = c_data / 10;           // Tens value of C temp data
    assign c_ones = c_data % 10;           // Ones value of C temp data
    
    logic [3:0] f_tens, f_ones;
    assign f_tens = f_data / 10;           // Tens value of C temp data
    assign f_ones = f_data % 10;           // Ones value of C temp data 
    
    // Parameters for segment patterns
    localparam ZERO  = 7'b000_0001;  // 0
    localparam ONE   = 7'b100_1111;  // 1
    localparam TWO   = 7'b001_0010;  // 2 
    localparam THREE = 7'b000_0110;  // 3
    localparam FOUR  = 7'b100_1100;  // 4
    localparam FIVE  = 7'b010_0100;  // 5
    localparam SIX   = 7'b010_0000;  // 6
    localparam SEVEN = 7'b000_1111;  // 7
    localparam EIGHT = 7'b000_0000;  // 8
    localparam NINE  = 7'b000_0100;  // 9
    localparam DEG   = 7'b001_1100;  // degrees symbol
    localparam C     = 7'b011_0001;  // C
    localparam F     = 7'b011_1000;  // F
    
    // To select each digit in turn
    logic [2:0] anode_select;         // 2 bit counter for selecting each of 4 digits
    logic [16:0] anode_timer;         // counter for digit refresh
    
    // Logic for controlling digit select and digit timer
    always @(posedge clk_100MHz) begin
        // 1ms x 8 displays = 8ms refresh period
        if(anode_timer == 99_999) begin         // The period of 100MHz clock is 10ns (1/100,000,000 seconds)
            anode_timer <= 0;                   // 10ns x 100,000 = 1ms
            anode_select <=  anode_select + 1;
        end
        else
            anode_timer <=  anode_timer + 1;
    end
    
    // Logic for driving the 8 bit anode output based on digit select
    always @(anode_select) begin
        case(anode_select) 
            3'o0 : an = 8'b1111_1110;
            3'o1 : an = 8'b1111_1101;
            3'o2 : an = 8'b1111_1011;
            3'o3 : an = 8'b1111_0111;
            3'o4 : an = 8'b1110_1111;
            3'o5 : an = 8'b1101_1111;
            3'o6 : an = 8'b1011_1111;
            3'o7 : an = 8'b0111_1111;
        endcase
    end
    
    always @*
        case(anode_select)
            3'o0 : seg = C;    // Set to C for Celsuis
                        
            3'o1 : seg = DEG;  // Set to degrees symbol
                    
            3'o2 : begin       // C TEMPERATURE ONES DIGIT
                        case(c_ones)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                        endcase
                    end
                    
            3'o3 : begin       // C TEMPERATURE TENS DIGIT
                        case(c_tens)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                        endcase
                    end
            
            3'o4 : seg = F;    // Set to F for Fahrenheit
                        
            3'o5 : seg = DEG;  // Set to degrees symbol
                    
            3'o6 : begin       // F TEMPERATURE ONES DIGIT
                        case(f_ones)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                        endcase
                    end
                    
            3'o7 : begin       // F TEMPERATURE TENS DIGIT
                        case(f_tens)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                        endcase
                    end             
        endcase  
endmodule