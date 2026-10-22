`timescale 1ns / 1ps

module AddressDecoderTop (
    input wire clk,
    input wire rst,
    input wire [31:0] address,
    input wire readEnable,
    input wire writeEnable,
    input wire [31:0] writeData,
    input wire [15:0] switches,


    output reg [31:0] readData,
    output wire [15:0] leds
);

    //control signlas for decoder
    wire DataMemWrite;
    wire DataMemRead;
    wire LEDWrite;
    wire SwitchReadEnable;


    //read dara signals
    wire [31:0] dataMemoryReadData;
    wire [31:0] switchReadData;


    //address decoder
    AddressDecoder decoder (
        .address(address[9:0]),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .DataMemWrite(DataMemWrite),
        .DataMemRead(DataMemRead),
        .LEDWrite(LEDWrite),
        .SwitchReadEnable(SwitchReadEnable)
    );


    //data memory
    DataMemory data_memory (
        .clk(clk),
        .MemWrite(DataMemWrite),
        .MemRead(DataMemRead),
        .address(address[8:0]),
        .write_data(writeData),
        .read_data(dataMemoryReadData)
    );


    //led and swicth code from lab 5
    switches led_interface (
        .clk(clk),
        .rst(rst),
        .writeData(writeData),
        .writeEnable(LEDWrite),
        .readEnable(1'b0),
        .memAddress(address[29:0]),
        .readData(),
        
        
        .leds(leds)
    );


    

    leds switch_interface (
        .clk(clk),
        .rst(rst),
        .btns(16'd0),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(SwitchReadEnable),
        .memAddress(address[29:0]),
        .switches(switches),
        .readData(switchReadData)
    );


    //read data selection
    always @(*) begin

    if (DataMemRead)
        readData = dataMemoryReadData;
    else if (SwitchReadEnable)
        readData = switchReadData;
    else
        readData = 32'd0;

end

endmodule