// Copyright Daniel J. Steffey 2016

`default_nettype none
`timescale 1ns / 1ps

module uart(
    input wire clock,                               // 12.5 MHz 
    input wire uart_rx, 
    output wire uart_tx,
    input wire uart_cts,
    output wire uart_rtr,
    output wire [7:0] read_data,
    output wire read_data_available,
    input wire [7:0] write_data,
    input wire write_data_enable,
    output wire write_data_available
);
    // uart tx
    uart_tx utx(clock, uart_tx, uart_cts, write_data, write_data_enable, write_data_available);
    
    // uart rx
    uart_rx urx(clock, uart_rx, uart_rtr, read_data, read_data_available); 


endmodule   