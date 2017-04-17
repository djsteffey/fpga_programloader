//////////////////////////////////////////////////////////////////////////////////
//
// Daniel Steffey
// 11/3/2016
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module imem #(
    parameter Abits = 32,                           // number of incoming address bits
    parameter Nloc = 32,                            // number memory locations
    parameter Dbits = 32,                           // number bits in data
    parameter initfile = "imem_init.txt"            // name of the initialization file
)
(
    input wire clock,                               // 12.5 MHz clock
    input wire [Abits-1:0] addr,                    // incoming 32-bit address
    output logic [Dbits-1:0] dout,                  // output data from memory
    input wire wr_enable,
    input wire [31:0] wr_address,
    input wire [31:0] wr_data
);

    logic [Dbits-1:0] mem[Nloc-1 : 0];              // the memory storeage
    initial $readmemh(initfile, mem, 0, Nloc-1);    // initialize the memory from the file
    
    assign dout = mem[addr[$clog2(Nloc)+1:2]];      // read from memory
                                                    // only use the neccessary amount of bits
                                                    // from the incoming 32-bit address
                                                    
    always_ff @(posedge clock) begin
        if (wr_enable == 1'b1) begin
            mem[wr_address[$clog2(Nloc)+1:2]] <= wr_data;
        end
    end

endmodule