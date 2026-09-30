`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Muddassir Ali

// Module Name: top_fsm_system
// Project Name: Counter
// Target Devices: Baasys 3
// 
//////////////////////////////////////////////////////////////////////////////////

module top_fsm_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // DEBOUNCER (Cleans up the physical reset button signal)
    wire rst_clean;
  	wire [31:0] switch_data; // hold the value read from the switches
  	reg [31:0] led_write_data = 32'd0; // counter value here
  	wire slow_clk;
  
    debouncer rst_db (
      			.clk(clk),
        		.pbin(pbin), 
      				.pbout(rst_clean)	//generated a clean signal
    ); 

    
    
    leds switch_reader (
      			.clk(clk), .rst(rst_clean),
                    .btns(16'd0),			// Not used for this FSM
                    .writeData(32'd0),			// We don't write to switches
                    .writeEnable(1'b0),			// Disabled
                    .readEnable(1'b1),			// Always ON so we can monitor switches
                    .memAddress(30'd0),       
                    .switches(physical_sw),		// Plug in the physical switches
                    .readData(switch_data)		// output data 
    );
    
    switches led_writer (
                    .clk(clk), .rst(rst_clean),
                    .writeData(led_write_data),
                    .writeEnable(1'b1),         	// Always ON so LEDs update instantly
                    .readEnable(1'b0), .memAddress(30'd0),
                    .readData(),                	// Ignored
                    .leds(physical_leds)      
    );
    
    clock_divider ticker (
                    .clk_in(clk),          		// Feed it the 100MHz fast clock
                    .rst(rst_clean),       		// Feed it the clean reset signal
                    .clk_out(slow_clk)     		// It spits out the 1Hz slow clock!
    );

    // YOUR FSM AND COUNTER LOGIC
	// YOUR CODE HERE
    endmodule