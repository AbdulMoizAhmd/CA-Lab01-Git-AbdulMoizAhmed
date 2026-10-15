`timescale 1ns / 1ps

module RegisterFile (
    input wire clk,
    input wire rst,
    input wire WriteEnable,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [31:0] WriteData,
    output wire [31:0] ReadData1,
    output wire [31:0] ReadData2
);

    //32 registers
    reg [31:0] regs [31:0];
    
    integer i;

    //synchornous write and reset 
    always @(posedge clk) begin

        if (rst) begin

            //clear all the registers on reset
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'd0;

        end

        else if (WriteEnable && (rd != 5'd0)) begin

            //if its not x0 then writedata
            regs[rd] <= WriteData;

        end


    end


    //tow asynchronous read prts 
    //x0=zero
    assign ReadData1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];

    assign ReadData2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

endmodule