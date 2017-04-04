// Copyright Daniel J. Steffey 2016

`default_nettype none
`timescale 1ns / 1ps

module programloader
(
    input wire clock,                               // timing signal...12.5 MHz
    input wire enable,                              // signal to put in program load mode
    
    // UART pins
    input wire rx,
    output wire tx,
    input wire cts,
    output wire rtr,
    
    // wires for imem
    output logic wr_imem = 1'b0,
    output logic [31:0] addr_imem = 32'b0,
    output logic [31:0] data_imem = 32'b0, 
    
    // status
    output wire [2:0] state
);
    parameter START_CODE = 8'hF0;
    parameter START_ACK_CODE = 8'hF1;
    parameter COMPLETION_CODE = 8'hF2;
    parameter COMPLETION_ACK_CODE = 8'hF3;
    parameter ERROR_CODE = 8'hF4;
    
    // states
    typedef enum bit[3:0]{ WAITING_START_CODE, SENDING_START_ACK, WAITING_DATA,
        SENDING_COMPLETION_ACK, FINISHED, SENDING_ERROR, ERROR } EState;
    EState current_state = WAITING_START_CODE;
    
    // UART controller
    wire [7:0] uart_read_data;
    wire uart_read_data_available;
    wire [7:0] uart_write_data;
    wire uart_write_data_enable;
    wire uart_write_data_available;
    uart uart(clock, rx, tx, cts, rtr, uart_read_data, uart_read_data_available,
        uart_write_data, uart_write_data_enable, uart_write_data_available);
        
    // status
    assign uart_write_data = (current_state == SENDING_START_ACK) ? START_ACK_CODE :
                             (current_state == SENDING_COMPLETION_ACK) ? COMPLETION_ACK_CODE :
                             (current_state == SENDING_ERROR) ? ERROR_CODE : 
                             8'b1111_1111;
     assign uart_write_data_enable = (current_state == SENDING_START_ACK) ? 1'b1 :
                                     (current_state == SENDING_COMPLETION_ACK) ? 1'b1 :
                                     (current_state == SENDING_ERROR) ? 1'b1 : 
                                     1'b0;
    assign state = current_state;
    
    // receiving bytes
    logic [3:0] byte_counter = 0;
    
    // logic
    always_ff @(posedge clock) begin
        if (enable == 1'b0) begin                       // this block lets us reset
                current_state <= WAITING_START_CODE;    // if there was an error
        end
        if (enable == 1'b1) begin
            // we are in load a new program mode
            if (byte_counter == 4) begin                // if we have received 4 bytes of data
                wr_imem <= 1'b1;                         // turn on write to imem
                byte_counter <= 0;                       // reset the byte counter
            end
            else begin                                  // else
                wr_imem <= 1'b0;                         // turn off write to imem
            end
            
            case (current_state)
            
                WAITING_START_CODE: begin
                    if (uart_read_data_available) begin
                        if (uart_read_data == START_CODE) begin
                            // we have received the correct start code
                            current_state <= SENDING_START_ACK;     // change to the sending start ack
                            byte_counter <= 0;                      // reset byte counter
                            addr_imem <= 32'hFFFF_FFFC;   // need this to work out addr_imem to increment to 0 when all 4 bytes received
                        end else begin
                            // incorrect..byte...some kind of error
                            current_state <= SENDING_ERROR;
                        end
                    end
                end
                
                SENDING_START_ACK: begin
                    // here for only 1 tick for the tx to start
                    // according to the wire assignements above to the
                    // uart_tx module
                    current_state <= WAITING_DATA;
                end
                
                WAITING_DATA: begin
                    if (uart_read_data_available) begin
                        // first see if it is one of the codes we could receive
                        // which would be completion code or error code
                        if (byte_counter == 0 && uart_read_data == COMPLETION_CODE) begin
                            current_state <= SENDING_COMPLETION_ACK;
                        end
                        else if (byte_counter == 0 && uart_read_data == ERROR_CODE) begin
                            current_state <= SENDING_ERROR;
                        end
                        else begin
                            // neither special code so should be an instruction to store
                            data_imem <= { data_imem[23:0], uart_read_data[7:0] };  // put it into our buffer
                            addr_imem <= addr_imem + 1;                             // increment address to put it
                            byte_counter <= byte_counter + 1;                       // increment our byte counter
                        end
                    end
                end
                
                SENDING_COMPLETION_ACK: begin
                    // here for only 1 tick for the tx to start
                    // according to the wire assignements above to the
                    // uart_tx module
                    current_state <= FINISHED;
                end
                
                FINISHED: begin
                    if (enable == 1'b0) begin
                        // no longer enabled so go back to the beginning waiting state
                        // so when we get enabled again we can get started
                        current_state <= WAITING_START_CODE;
                    end
                end
                
                SENDING_ERROR: begin
                    // here for only 1 tick for the tx to start
                    // according to the wire assignements above to the
                    // uart_tx module
                    current_state <= ERROR;
                end
                
                ERROR: begin
                    if (enable == 1'b0) begin
                        // no longer enabled so go back to the beginning waiting state
                        // so when we get enabled again we can get started
                        current_state <= WAITING_START_CODE;
                    end
                end
                
            endcase
        end
    end

    
endmodule
