`timescale 1ns / 1ps

module MemorySystem_tb;

    reg clk;
    reg rst;
    reg [31:0] address;
    reg readEnable;
    reg writeEnable;
    reg [31:0] writeData;
    reg [15:0] switches;
    wire [31:0] readData;
    wire [15:0] leds;


  

    AddressDecoderTop uut (
        .clk(clk),
        .rst(rst),
        .address(address),

        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .writeData(writeData),
        .switches(switches),
        .readData(readData),
        .leds(leds)
        
        
        
    );


    //100 mhz clock and 10 ns period
    always #5 clk = ~clk;

    initial begin

        //the starting vals

        clk = 0;
        rst = 1;
        address = 32'd0;
        readEnable = 0;
        writeEnable = 0;
        writeData = 32'd0;
        switches = 16'd0;


        //reset
        #10;
        rst = 0;


        //test 1: write DEADBEEF to Data Memory
        // address[9:8] = 00
        address = 32'h00000020;
        writeData = 32'hDEADBEEF;
        writeEnable = 1;
        readEnable = 0;

        #10;
        writeEnable = 0;


        //test 2:read the same data memory location

        readEnable = 1;
        #5;

        if (readData == 32'hDEADBEEF)
            $display("PASS: Data Memory write/read correct");
        else
            $display("FAIL: Data Memory write/read");

        //check decoder
        if ((uut.DataMemRead == 1'b1) &&
            (uut.LEDWrite == 1'b0) &&
            (uut.SwitchReadEnable == 1'b0))
            $display("PASS: Data Memory decoder selection correct");
        else
            $display("FAIL: Data Memory decoder selection");




        readEnable = 0;


        //test 3: write value to LEDs
        // address[9:8] = 01

        address = 32'h00000100;
        writeData = 32'h000000A5;
        writeEnable = 1;
        #10;

        writeEnable = 0;
        #5;


        if (leds == 16'h00A5)
            $display("PASS: LED write correct");
        else
            $display("FAIL: LED write");


        //during led access only ledwrite should be active
        address = 32'h00000100;
        writeEnable = 1;

        #1;

        if ((uut.LEDWrite == 1'b1) &&
            (uut.DataMemWrite == 1'b0) &&
            (uut.SwitchReadEnable == 1'b0))

            $display("PASS: LED decoder selection correct");

        else
            $display("FAIL: LED decoder selection");


        writeEnable = 0;


        //test 4: read physical switches
        // address[9:8] = 10

        switches = 16'h5A3C;

        address = 32'h00000200;

        readEnable = 1;

        #5;


        if (readData == 32'h00005A3C)
            $display("PASS: Switch read correct");
        else
            $display("FAIL: Switch read");


        //check deoder
        if ((uut.SwitchReadEnable == 1'b1) &&
            (uut.DataMemRead == 1'b0) &&
            (uut.LEDWrite == 1'b0))

            $display("PASS: Switch decoder selection correct");

        else
            $display("FAIL: Switch decoder selection");


        readEnable = 0;


        //tets 5: unused address range
        //address[9:8] = 11

        address = 32'h00000300;

        readEnable = 1;
        writeEnable = 1;

        #5;


        if (readData == 32'd0)
            $display("PASS: Unused address returns zero");
        else
            $display("FAIL: Unused address");


        if ((uut.DataMemRead == 1'b0) &&
            (uut.DataMemWrite == 1'b0) &&
            (uut.LEDWrite == 1'b0) &&
            (uut.SwitchReadEnable == 1'b0))

            $display("PASS: No device selected for unused address");

        else
            $display("FAIL: Unused address decoder");


        readEnable = 0;
        writeEnable = 0;


        #20;
        $finish;

    end

endmodule