`timescale 1ns / 1ps

module top_control_fsm (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    //fsm states

    localparam CAPTURE_OPCODE = 2'd0;
    localparam CAPTURE_FUNCT  = 2'd1;
    localparam DISPLAY        = 2'd2;

    reg [1:0] state = CAPTURE_OPCODE;


    //internal signals

    wire clean_btn;

    reg previous_btn = 1'b0;
    wire button_pressed;

    wire [31:0] switch_data;

    reg [6:0] saved_opcode = 7'd0;
    reg [2:0] saved_funct3 = 3'd0;
    reg [6:0] saved_funct7 = 7'd0;

    wire RegWrite;
    wire ALUSrc;
    wire MemRead;
    wire MemWrite;
    wire MemtoReg;
    wire Branch;

    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    reg [31:0] led_write_data;


    //debouner

    debouncer db (
        .clk(clk),
        .pbin(pbin),
        .pbout(clean_btn)
    );


    //read physcia; switches

    leds switch_interface (
        .clk(clk),
        .rst(1'b0),

        .btns(16'd0),

        .writeData(32'd0),
        .writeEnable(1'b0),

        .readEnable(1'b1),
        .memAddress(30'd0),

        .switches(physical_sw),

        .readData(switch_data)
    );


    //detect one button presses

    always @(posedge clk) begin
        previous_btn <= clean_btn;
    end

    assign button_pressed = clean_btn & ~previous_btn;


    //fsm and input

    always @(posedge clk) begin

        if (button_pressed) begin

            case (state)

                //opcode fo sw6-sw0
                CAPTURE_OPCODE: begin

                    saved_opcode <= switch_data[6:0];

                    state <= CAPTURE_FUNCT;

                end


                //SW2-SW0  funct3
                //SW9-SW3 funct7
                CAPTURE_FUNCT: begin

                    saved_funct3 <= switch_data[2:0];
                    saved_funct7 <= switch_data[9:3];

                    state <= DISPLAY;

                end


                //return to first state for another instruction
                DISPLAY: begin

                    state <= CAPTURE_OPCODE;

                end


                default: begin

                    state <= CAPTURE_OPCODE;

                end

            endcase

        end

    end


    //main control unit

    MainControl main_control (
        .opcode(saved_opcode),

        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch(Branch),

        .ALUOp(ALUOp)
    );


    //alu
    ALUControl alu_control (
        .ALUOp(ALUOp),

        .funct3(saved_funct3),
        .funct7(saved_funct7),

        .ALUControl(ALUControl)
    );


    //led display

    always @(*) begin

        led_write_data = 32'd0;

        // Main control signals
        led_write_data[0] = RegWrite;
        led_write_data[1] = ALUSrc;
        led_write_data[2] = MemRead;
        led_write_data[3] = MemWrite;
        led_write_data[4] = MemtoReg;
        led_write_data[5] = Branch;

        //ALUOp
        led_write_data[7:6] = ALUOp;

        //final ALU control
        led_write_data[11:8] = ALUControl;

        //FSM state
        led_write_data[13:12] = state;

    end


    //drive phsycial leds

    switches led_interface (
        .clk(clk),
        .rst(1'b0),

        .writeData(led_write_data),

        .writeEnable(1'b1),
        .readEnable(1'b0),

        .memAddress(30'd0),

        .readData(),

        .leds(physical_leds)
    );

endmodule