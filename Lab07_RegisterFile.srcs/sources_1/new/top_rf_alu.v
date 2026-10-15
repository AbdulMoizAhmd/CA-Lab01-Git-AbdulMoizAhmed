`timescale 1ns / 1ps

module top_rf_alu (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);



    wire rst_clean;
    wire [31:0] switch_data;

    reg [31:0] led_write_data;

    reg WriteEnable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] WriteData;

    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    reg [3:0] ALUcontrol;
    wire [31:0] ALUresult;
    wire Zero;




    localparam INIT_X1 = 2'd0;
    localparam INIT_X2 = 2'd1;
    localparam EXECUTE = 2'd2;
    localparam DISPLAY = 2'd3;

    reg [1:0] state;


    debouncer db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)
    );



    leds sw_interface (
        .clk(clk),
        .rst(rst_clean),
        .btns(16'd0),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(1'b1),
        .memAddress(30'd0),
        .switches(physical_sw),
        .readData(switch_data)
    );



    RegisterFile rf (
        .clk(clk),
        .rst(rst_clean),
        .WriteEnable(WriteEnable),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .WriteData(WriteData),

        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );


    ALU alu (
        .A(ReadData1),
        .B(ReadData2),
        .ALUcontrol(ALUcontrol),
        .ALUresult(ALUresult),
        .Zero(Zero)
    );




    always @(posedge clk) begin

        if (rst_clean) begin
            state <= INIT_X1;
        end

        else begin

            case (state)

                INIT_X1:
                    state <= INIT_X2;

                INIT_X2:
                    state <= EXECUTE;

                EXECUTE:
                    state <= DISPLAY;

                DISPLAY:
                    state <= EXECUTE;

                default:
                    state <= INIT_X1;

            endcase

        end

    end



    always @(*) begin

        WriteEnable = 1'b0;

        rs1 = 5'd0;
        rs2 = 5'd0;
        rd = 5'd0;

        WriteData = 32'd0;

        ALUcontrol = 4'b0000;


        case (state)


            INIT_X1: begin

                rd = 5'd1;

                WriteData = {
                    28'd0,
                    switch_data[3:0]
                };

                WriteEnable = 1'b1;

            end


 
            INIT_X2: begin

                rd = 5'd2;

                WriteData = {
                    28'd0,
                    switch_data[7:4]
                };

                WriteEnable = 1'b1;

            end



            EXECUTE: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUcontrol = {
                    1'b0,
                    switch_data[10:8]
                };

                rd = 5'd4;

                WriteData = ALUresult;

                WriteEnable = switch_data[11];

            end


            DISPLAY: begin

                rs1 = 5'd4;
                rs2 = 5'd0;

                WriteEnable = 1'b0;

            end


            default: begin

                WriteEnable = 1'b0;

            end

        endcase

    end



    always @(*) begin

        led_write_data = 32'd0;

        led_write_data[15:14] = state;

        led_write_data[13] = Zero;

        led_write_data[12] = WriteEnable;

        if (state == DISPLAY)
            led_write_data[11:0] = ReadData1[11:0];

        else
            led_write_data[11:0] = ALUresult[11:0];

    end


    switches led_interface (
        .clk(clk),
        .rst(rst_clean),
        .writeData(led_write_data),
        .writeEnable(1'b1),
        .readEnable(1'b0),
        .memAddress(30'd0),
        .readData(),
        .leds(physical_leds)
    );

endmodule