// Copyright Daniel J. Steffey 2016

`default_nettype none
`timescale 1ns / 1ps

module uart_tx(
    input wire clock,                   // 12.5 MHz clock
    output logic tx = 1'b1,
    input wire cts,
    input wire [7:0] write_data,
    input wire write_data_enable,
    output wire write_data_available
);
    // create the possible states
    typedef enum bit [0:0] { IDLE, SENDING_DATA_BITS } EState;
    
    //start off in the ILDE state
    EState current_state = IDLE;
    
    // clock ticks per baud tick
    parameter CLOCK_COUNT_MAX = 12500000 / 9600;
//    parameter CLOCK_COUNT_MAX = 100000000 / 25000000;
    logic [15:0] clock_counter = 0;
    
    // hold what bit position we are sending
    logic [3:0] bit_counter = 10;

    // buffer to hold the bits to send
    logic [8:0] bit_buffer = 0;

   
    // can transmit depends only on value of bit_counter
    assign write_data_available = ((bit_counter == 10) && (cts == 1'b0)) ? 1'b1 : 1'b0;

    // do work on the clock tick
    always_ff @(posedge clock) begin
        case (current_state)
            
            IDLE: begin
                if ((write_data_enable == 1'b1) && (write_data_available == 1'b1)) begin
                    tx <= 1'b0;                                     // start bit is a 0
                    bit_counter <= 0;                               // no data bits sent yet
//                    clock_counter <= 1;                             // reset our clock counter
                    clock_counter <= clock_counter + 1;
                    bit_buffer <= {1'b1, write_data[7:0] };         // store the data to send along with stop bit
                    current_state <= SENDING_DATA_BITS;             // change state
                end
                else begin
                    tx <= 1'b1;                                     // keep tx high
                end
            end
            
            SENDING_DATA_BITS: begin
                if (clock_counter == CLOCK_COUNT_MAX) begin         // time to send again
                    // time to send the next bit
                    tx <= bit_buffer[0];                        // send LSB first
                    bit_buffer <= { 1'b0, bit_buffer[8:1] };    // shift the bit buffer
                    bit_counter <= bit_counter + 1;             // update the bit counter
                    clock_counter <= 1;                         // reset the clock
                    
                    if (bit_counter == 9) begin
                        current_state <= IDLE;
                    end
                end
                else begin
                    clock_counter <= clock_counter + 1;         // increment clock counter
                end
            end
        endcase
    end
endmodule