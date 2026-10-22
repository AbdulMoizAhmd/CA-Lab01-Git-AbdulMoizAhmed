`timescale 1ns / 1ps

module top_memory_fsm (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // --------------------------------------------------
    // FSM states
    // --------------------------------------------------

    localparam WRITE_MEM   = 3'd0;
    localparam READ_MEM    = 3'd1;
    localparam SHOW_MEM    = 3'd2;
    localparam WRITE_LED   = 3'd3;
    localparam READ_SWITCH = 3'd4;
    localparam SHOW_SWITCH = 3'd5;
    localparam DONE        = 3'd6;


    // --------------------------------------------------
    // Internal signals
    // --------------------------------------------------

    wire clean_btn;

    reg previous_btn = 1'b0;
    wire button_pressed;

    reg [2:0] state = WRITE_MEM;

    reg [31:0] address;
    reg readEnable;
    reg writeEnable;
    reg [31:0] writeData;

    wire [31:0] readData;
    wire [15:0] system_leds;

    // Stores value read from Data Memory
    reg [31:0] saved_read_data = 32'd0;


    // --------------------------------------------------
    // Debouncer from Lab 5
    // --------------------------------------------------

    debouncer db (
        .clk(clk),
        .pbin(pbin),
        .pbout(clean_btn)
    );


    // --------------------------------------------------
    // Detect a new button press
    // --------------------------------------------------

    always @(posedge clk) begin
        previous_btn <= clean_btn;
    end

    assign button_pressed = clean_btn & ~previous_btn;


    // --------------------------------------------------
    // Complete memory system
    // --------------------------------------------------

    AddressDecoderTop memory_system (
        .clk(clk),
        .rst(1'b0),

        .address(address),

        .readEnable(readEnable),
        .writeEnable(writeEnable),

        .writeData(writeData),

        .switches(physical_sw),

        .readData(readData),
        .leds(system_leds)
    );


    // --------------------------------------------------
    // Save value read from Data Memory
    // --------------------------------------------------

    always @(posedge clk) begin

        if (state == READ_MEM)
            saved_read_data <= readData;

    end


    // --------------------------------------------------
    // FSM state transitions
    //
    // Each center-button press moves to next state
    // --------------------------------------------------

    always @(posedge clk) begin

        if (button_pressed) begin

            case (state)

                WRITE_MEM:
                    state <= READ_MEM;

                READ_MEM:
                    state <= SHOW_MEM;

                SHOW_MEM:
                    state <= WRITE_LED;

                WRITE_LED:
                    state <= READ_SWITCH;

                READ_SWITCH:
                    state <= SHOW_SWITCH;

                SHOW_SWITCH:
                    state <= DONE;

                DONE:
                    state <= WRITE_MEM;

                default:
                    state <= WRITE_MEM;

            endcase

        end

    end


    // --------------------------------------------------
    // FSM output logic
    // --------------------------------------------------

    always @(*) begin

        // Default values
        address = 32'd0;
        readEnable = 1'b0;
        writeEnable = 1'b0;
        writeData = 32'd0;


        case (state)

            // ------------------------------------------
            // State 0: WRITE_MEM
            //
            // Write physical switch value into
            // Data Memory location 0x020
            // ------------------------------------------

            WRITE_MEM: begin

                address = 32'h00000020;

                writeData = {
                    16'd0,
                    physical_sw
                };

                writeEnable = 1'b1;

            end


            // ------------------------------------------
            // State 1: READ_MEM
            //
            // Read back Data Memory location 0x020
            // ------------------------------------------

            READ_MEM: begin

                address = 32'h00000020;

                readEnable = 1'b1;

            end


            // ------------------------------------------
            // State 2: SHOW_MEM
            //
            // Write the saved memory value to LEDs
            //
            // address[9:8] = 01 selects LEDs
            // ------------------------------------------

            SHOW_MEM: begin

                address = 32'h00000100;

                writeData = saved_read_data;

                writeEnable = 1'b1;

            end


            // ------------------------------------------
            // State 3: WRITE_LED
            //
            // Directly write A5 to LEDs
            // ------------------------------------------

            WRITE_LED: begin

                address = 32'h00000100;

                writeData = 32'h000000A5;

                writeEnable = 1'b1;

            end


            // ------------------------------------------
            // State 4: READ_SWITCH
            //
            // Read physical switches
            //
            // address[9:8] = 10 selects switches
            // ------------------------------------------

            READ_SWITCH: begin

                address = 32'h00000200;

                readEnable = 1'b1;

            end


            // ------------------------------------------
            // State 5: SHOW_SWITCH
            //
            // Display current physical switch value
            // on LEDs
            // ------------------------------------------

            SHOW_SWITCH: begin

                address = 32'h00000100;

                writeData = {
                    16'd0,
                    physical_sw
                };

                writeEnable = 1'b1;

            end


            // ------------------------------------------
            // State 6: DONE
            //
            // No memory or peripheral access
            // ------------------------------------------

            DONE: begin

                address = 32'd0;

                readEnable = 1'b0;
                writeEnable = 1'b0;

                writeData = 32'd0;

            end


            default: begin

                address = 32'd0;

                readEnable = 1'b0;
                writeEnable = 1'b0;

                writeData = 32'd0;

            end

        endcase

    end


    // --------------------------------------------------
    // Connect memory-system LEDs to physical FPGA LEDs
    // --------------------------------------------------

    assign physical_leds = system_leds;


endmodule