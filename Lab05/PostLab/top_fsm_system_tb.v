`timescale 1ns / 1ps

// Task 2 - Testbench for WAIT/COUNT FSM

module top_fsm_system_tb;

    reg clk;
    reg pbin;
    reg [15:0] physical_sw;

    wire [15:0] physical_leds;


    // Connect the FSM system
    top_fsm_system dut (
        .clk(clk),
        .pbin(pbin),
        .physical_sw(physical_sw),
        .physical_leds(physical_leds)
    );


    // 100 MHz style simulation clock
    always #5 clk = ~clk;


    initial begin

        // Starting values
        clk = 0;
        pbin = 1;
        physical_sw = 16'd0;

        // Release reset
        #20;
        pbin = 0;


        // TEST 1:
        // Give a non-zero switch value
        #10;
        physical_sw = 16'd3;

        // Hold it long enough for WAIT to read it
        #70;

        // Change switches during COUNT
        // The FSM must ignore this new value
        physical_sw = 16'd9;

        #60;
        physical_sw = 16'd0;

        // Allow countdown to finish
        #160;


        // TEST 2:
        // Start a new countdown
        physical_sw = 16'd4;

        // Hold long enough to be captured
        #80;
        physical_sw = 16'd0;

        // Let countdown begin
        #80;

        // Reset during countdown
        pbin = 1;

        #30;
        pbin = 0;

        // Wait and finish
        #50;
        $finish;

    end

endmodule