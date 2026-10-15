`timescale 1ns / 1ps

module RF_ALU_FSM_tb;

    reg clk;
    reg rst;

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

    reg [4:0] state;


    //FSM states
    localparam IDLE       = 5'd0;
    localparam WRITE_X1   = 5'd1;
    localparam WRITE_X2   = 5'd2;
    localparam WRITE_X3   = 5'd3;
    localparam ADD_OP     = 5'd4;
    localparam SUB_OP     = 5'd5;
    localparam AND_OP     = 5'd6;
    localparam OR_OP      = 5'd7;
    localparam XOR_OP     = 5'd8;
    localparam SLL_OP     = 5'd9;
    localparam SRL_OP     = 5'd10;
    localparam BEQ_SETUP  = 5'd11;
    localparam BEQ_WRITE  = 5'd12;

    localparam RAW_WRITE  = 5'd13;
    localparam RAW_READ   = 5'd14;

    localparam DONE       = 5'd15;


    //register File
    RegisterFile rf (
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


    //ALU
    ALU alu (
        .A(ReadData1),
        .B(ReadData2),
        .ALUcontrol(ALUcontrol),
        .ALUresult(ALUresult),
        .Zero(Zero)
    );


    //clock period=10ns
    always #5 clk = ~clk;


    //FSM state transitions
    always @(posedge clk) begin

        if (rst)
            state <= IDLE;

        else begin

            case (state)

                IDLE:      state <= WRITE_X1;

                WRITE_X1:  state <= WRITE_X2;
                WRITE_X2:  state <= WRITE_X3;
                WRITE_X3:  state <= ADD_OP;

                ADD_OP:    state <= SUB_OP;
                SUB_OP:    state <= AND_OP;
                AND_OP:    state <= OR_OP;
                OR_OP:     state <= XOR_OP;
                XOR_OP:    state <= SLL_OP;
                SLL_OP:    state <= SRL_OP;
                SRL_OP:    state <= BEQ_SETUP;

                BEQ_SETUP: state <= BEQ_WRITE;
                BEQ_WRITE: state <= RAW_WRITE;

                RAW_WRITE: state <= RAW_READ;
                RAW_READ:  state <= DONE;

                DONE:      state <= DONE;

                default:   state <= IDLE;

            endcase

        end

    end


    //FSM output and control logic
    always @(*) begin

        //default values
        WriteEnable = 1'b0;

        rs1 = 5'd0;
        rs2 = 5'd0;
        rd  = 5'd0;

        WriteData = 32'd0;

        ALUcontrol = 4'b0000;


        case (state)

            //write iniital values

            WRITE_X1: begin

                rd = 5'd1;
                WriteData = 32'h10101010;
                WriteEnable = 1'b1;

            end


            WRITE_X2: begin

                rd = 5'd2;
                WriteData = 32'h01010101;
                WriteEnable = 1'b1;

            end


            WRITE_X3: begin
                rd = 5'd3;
                WriteData = 32'h00000005;
                WriteEnable = 1'b1;

            end


            //ADD x4 = x1 + x2

            ADD_OP: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUcontrol = 4'b0000;

                rd = 5'd4;
                WriteData = ALUresult;
                WriteEnable = 1'b1;

            end


            //SUB x5 = x1 - x2

            SUB_OP: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUcontrol = 4'b0001;

                rd = 5'd5;
                WriteData = ALUresult;
                WriteEnable = 1'b1;

            end


            //AND x6 = x1 AND x2

            AND_OP: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUcontrol = 4'b0010;

                rd = 5'd6;
                WriteData = ALUresult;
                WriteEnable = 1'b1;

            end


            // OR x7 = x1 OR x2

            OR_OP: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUcontrol = 4'b0011;

                rd = 5'd7;
                WriteData = ALUresult;
                WriteEnable = 1'b1;

            end


            // XOR x8 = x1 XOR x2

            XOR_OP: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUcontrol = 4'b0100;

                rd = 5'd8;
                WriteData = ALUresult;
                WriteEnable = 1'b1;

            end


            // SLL x9 = x1 << x2[4:0]

            SLL_OP: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUcontrol = 4'b0101;

                rd = 5'd9;
                WriteData = ALUresult;
                WriteEnable = 1'b1;

            end


            // SRL x10 = x1 >> x2[4:0]

            SRL_OP: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUcontrol = 4'b0110;

                rd = 5'd10;
                WriteData = ALUresult;
                WriteEnable = 1'b1;

            end


            // BEQ style comparison compare x1 with x1

            BEQ_SETUP: begin

                rs1 = 5'd1;
                rs2 = 5'd1;

                ALUcontrol = 4'b0001;

            end


            //if zero = 1 write flag x11 = 1
            BEQ_WRITE: begin

                rs1 = 5'd1;
                rs2 = 5'd1;

                ALUcontrol = 4'b0001;

                if (Zero) begin

                    rd = 5'd11;
                    WriteData = 32'd1;
                    WriteEnable = 1'b1;

                end

            end



            RAW_WRITE: begin

                rd = 5'd12;
                WriteData = 32'hCAFEBABE;
                WriteEnable = 1'b1;

            end


            RAW_READ: begin

                rs1 = 5'd12;

            end


            default: begin

                WriteEnable = 1'b0;

            end

        endcase

    end


    initial begin

        clk = 0;
        rst = 1;
        state = IDLE;

        #20;

        rst = 0;

        #200;


        if (rf.regs[1] == 32'h10101010)
            $display("PASS: x1 written correctly");
        else
            $display("FAIL: x1");


        if (rf.regs[2] == 32'h01010101)
            $display("PASS: x2 written correctly");
        else
            $display("FAIL: x2");


        if (rf.regs[4] == 32'h11111111)
            $display("PASS: ADD result correct");
        else
            $display("FAIL: ADD");


        if (rf.regs[5] == 32'h0F0F0F0F)
            $display("PASS: SUB result correct");
        else
            $display("FAIL: SUB");


        if (rf.regs[6] == 32'h00000000)
            $display("PASS: AND result correct");
        else
            $display("FAIL: AND");


        if (rf.regs[7] == 32'h11111111)
            $display("PASS: OR result correct");
        else
            $display("FAIL: OR");


        if (rf.regs[8] == 32'h11111111)
            $display("PASS: XOR result correct");
        else
            $display("FAIL: XOR");


        if (rf.regs[9] == 32'h20202020)
            $display("PASS: SLL result correct");
        else
            $display("FAIL: SLL");


        if (rf.regs[10] == 32'h08080808)
            $display("PASS: SRL result correct");
        else
            $display("FAIL: SRL");


        if (rf.regs[11] == 32'd1)
            $display("PASS: BEQ Zero check correct");
        else
            $display("FAIL: BEQ");


        if (rf.regs[12] == 32'hCAFEBABE)
            $display("PASS: read-after-write correct");
        else
            $display("FAIL: read-after-write");


        $finish;

    end

endmodule