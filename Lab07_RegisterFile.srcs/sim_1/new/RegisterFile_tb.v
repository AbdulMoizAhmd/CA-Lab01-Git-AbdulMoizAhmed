`timescale 1ns / 1ps

module RegisterFile_tb;

    reg clk;
    reg rst;
    reg WriteEnable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] WriteData;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;


    //instantiate register file
    RegisterFile uut (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .WriteData(WriteData),

        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );


    //clock p;eriod= 10ns
    always #5 clk = ~clk;


    initial begin

        //initialize valyues
        clk = 0;
        rst = 1;
        WriteEnable = 0;

        rs1 = 0;
        rs2 = 0;
        rd = 0;

        WriteData = 0;


        
        //reset
        #10;
        rst = 0;


        //TEST 1
        //Write x5=DEADBEEF
        rd = 5'd5;
        WriteData = 32'hDEADBEEF;
        WriteEnable = 1;

        #10;

        WriteEnable = 0;

        rs1 = 5'd5;

        #5;

        if (ReadData1 == 32'hDEADBEEF)
            $display("TEST 1 PASS: x5 = DEADBEEF");
        else
            $display("TEST 1 FAIL");


        //TEST 2
        //attempt to write to x0
        rd = 5'd0;
        WriteData = 32'hFFFFFFFF;
        WriteEnable = 1;

        #10;

        WriteEnable = 0;

        rs1 = 5'd0;

        #5;
        if (ReadData1 == 32'd0)
            $display("TEST 2 PASS: x0 remains zero");
        else
            $display("TEST 2 FAIL");


        //write another value into x6
        rd = 5'd6;
        WriteData = 32'h12345678;
        WriteEnable = 1;

        #10;

        WriteEnable = 0;


        //TEST 3
        //simultaneously read from x5 and x6

        rs1 = 5'd5;
        rs2 = 5'd6;

        #5;

        if ((ReadData1 == 32'hDEADBEEF) &&
            (ReadData2 == 32'h12345678))

            $display("TEST 3 PASS: two read ports work together");

        else
            $display("TEST 3 FAIL");


        //TEST 4
        //overwrite x5

        rd = 5'd5;
        WriteData = 32'hAAAAAAAA;
        WriteEnable = 1;

        #10;

        WriteEnable = 0;

        rs1 = 5'd5;

        #5;

        if (ReadData1 == 32'hAAAAAAAA)
            $display("TEST 4 PASS: x5 overwritten correctly");
        else
            $display("TEST 4 FAIL");


        //TEST 5
        //reset clears registers

        rst = 1;

        #10;

        rst = 0;

        rs1 = 5'd5;
        rs2 = 5'd6;

        #5;

        if ((ReadData1 == 32'd0) &&
            (ReadData2 == 32'd0))

            $display("TEST 5 PASS: reset clears registers");

        else
            $display("TEST 5 FAIL");

        #20;

        $finish;

    end

endmodule