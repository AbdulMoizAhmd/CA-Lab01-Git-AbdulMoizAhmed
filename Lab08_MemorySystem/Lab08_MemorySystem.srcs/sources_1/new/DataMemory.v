`timescale 1ns / 1ps



module DataMemory (
    input wire clk,
    input wire MemWrite,
    input wire MemRead,
    input wire [8:0] address,
    input wire [31:0] write_data,
    
    output reg [31:0] read_data
);
    //512 words so 32 bits each
    reg [31:0] memory [0:511];

    //rising edge for clk
    always @(posedge clk) begin
        if (MemWrite)
            memory[address] <= write_data;
    end

    //read data
    always @(*) begin
        if (MemRead)
            read_data = memory[address];
        else
            read_data = 32'd0;
    end

endmodule
