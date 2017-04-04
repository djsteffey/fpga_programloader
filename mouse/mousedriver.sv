// Copyright Daniel J. Steffey 2016

`default_nettype none
`timescale 1ns / 1ps

module mousedriver
(
    input wire clock,                           // 100 MHz clock
    input wire reset,
    inout wire ps2_clock,
    inout wire ps2_data,
    output wire [10:0] mouse_x,
    output wire [10:0] mouse_y,
    output wire [2:0] mouse_buttons,
    output wire mouse_event
);
    typedef enum { INIT, SET_X_MAX, SET_Y_MAX, NORMAL } EState;
    EState current_state = INIT;
    parameter MAX_X = 639;
    parameter MAX_Y = 479;
     
    // internal wireing mainly to the mouse control
    // output from mouse control
    wire [11:0] internal_mouse_x_pos;
    wire [11:0] internal_mouse_y_pos;
    wire [3:0] internal_mouse_z_pos;
    wire internal_mouse_left;
    wire internal_mouse_middle;
    wire internal_mouse_right;
    wire internal_mouse_new_event;
    // input to mouse control....we dont give it any
    wire [11:0] internal_mouse_set_value;
    wire internal_mouse_set_x = 1'b0;
    wire internal_mouse_set_y = 1'b0;
    wire internal_mouse_set_x_max;
    wire internal_mouse_set_y_max;
    
    // assign the output values
    assign mouse_x = internal_mouse_x_pos[10:0];
    assign mouse_y = internal_mouse_y_pos[10:0];
    assign mouse_buttons = { internal_mouse_left, internal_mouse_middle, internal_mouse_right };
    assign mouse_event = internal_mouse_new_event;
    
    // make the connection to the mouse control
    MouseCtl mouse(clock, reset, internal_mouse_x_pos, internal_mouse_y_pos, internal_mouse_z_pos,
         internal_mouse_left, internal_mouse_middle, internal_mouse_right,
         internal_mouse_new_event, internal_mouse_set_value,
         internal_mouse_set_x, internal_mouse_set_y, internal_mouse_set_x_max,
         internal_mouse_set_y_max, ps2_clock, ps2_data);
         
    // assign wires based on state
    assign internal_mouse_set_value = (current_state == SET_X_MAX) ? MAX_X :
                                      (current_state == SET_Y_MAX) ? MAX_Y :
                                      0;
    assign internal_mouse_set_x_max = (current_state == SET_X_MAX) ? 1'b1 : 1'b0;
    assign internal_mouse_set_y_max = (current_state == SET_Y_MAX) ? 1'b1 : 1'b0;
         
    // progress through the states and let the wire assignment above
    // push the correct values
    always_ff @(posedge clock) begin
    
        case (current_state)
        
            INIT: begin
                current_state <= SET_X_MAX;
            end
            
            SET_X_MAX: begin
                current_state <= SET_Y_MAX;
            end
            
            SET_Y_MAX: begin
                current_state <= NORMAL;
            end
            
            NORMAL: begin
            end
            
        endcase
    end

endmodule
