// Copyright Daniel J. Steffey 2016

`default_nettype none
`timescale 1ns / 1ps

module uart_rx(
    input wire clock,                   // 12.5 MHz clock
    input wire rx,
    output wire rtr,
    output logic [7:0] read_data = 0,
    output wire read_data_available
);
    // create the possible states
    typedef enum bit [1:0]{ IDLE, FINDING_CENTER_SAMPLE, RECEIVING_DATA_BITS } EState;
    
    //start off in the ILDE state
    EState current_state = IDLE;
    
    // clock ticks per baud tick
    parameter CLOCK_COUNT_MAX = (12500000 / 9600) / 16;        // 651 clocks per sample
    logic [15:0] clock_counter = 0;
    logic [4:0] sample_counter = 0;
    
    // hold what bit position we are receiving
    logic [3:0] bit_counter = 0;

    // buffer to hold the bits to receive
    logic [7:0] bit_buffer = 0;

    // always ready to receive
    assign rtr = (current_state == IDLE) ? 1'b0 : 1'b1;
    
    // data available only when bit counter is 9
    assign read_data_available = (bit_counter == 9) ? 1'b1 : 1'b0;
    
    // do work on the clock tick
    always_ff @(posedge clock) begin
        if (bit_counter == 9) begin             // this is so bit counter goes from 9 to 0
            bit_counter <= 0;                   // in the next clock tick so read_data_avaialble
        end                                     // will only be hot for one tick
        
        case (current_state)
            
            IDLE: begin
                if ((rtr == 1'b0) && (rx == 1'b0)) begin            // we are rtr and got the start bit of 0
                    bit_counter <= 0;                               // no data bits sent yet
                    sample_counter <= 0;                            // 16 sample counter reset
                    clock_counter <= 0;                             // reset our clock counter
                    current_state <= FINDING_CENTER_SAMPLE;         // change state
                end
            end
            
            FINDING_CENTER_SAMPLE: begin
                clock_counter <= clock_counter + 1;                 // increment our clock counter
                if (clock_counter == CLOCK_COUNT_MAX) begin         // if it is at the max then we are at another sample point
                    sample_counter <= sample_counter + 1;           // increment our sample counter
                    clock_counter <= 0;                             // reset clock counter
                    if (sample_counter == 7) begin                  // check if we are 7/16 samples in
                        sample_counter <= 0;                        // found the center of the start bit, reset sample counter 
                        current_state <= RECEIVING_DATA_BITS;       // go to the next state
                    end
                end
            end
            
            RECEIVING_DATA_BITS: begin
                clock_counter <= clock_counter + 1;                  // increment clock counter
                if (clock_counter == CLOCK_COUNT_MAX) begin          // sample point reached
                    sample_counter <= sample_counter + 1;            // increment sample counter
                    clock_counter <= 0;                              // reset clock counter
                    if (sample_counter == 15) begin                  // time to pull the data
                        sample_counter <= 0;                         // reset sample counter
                        bit_counter <= bit_counter + 1;              // increment we received another bit
                        if (bit_counter == 8) begin                  // we received all the data and the stop bit
                            current_state <= IDLE;                   // go to the IDLE state
                            read_data <= bit_buffer;                // transfer the storage
                        end
                        else begin                                   // this was another data bit
                            bit_buffer <= {rx, bit_buffer[7:1] };    // attached the rx as the new LSB
                        end
                    end
                end
            end
        endcase
    end
endmodule