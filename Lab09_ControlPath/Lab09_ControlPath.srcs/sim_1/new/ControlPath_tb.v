`timescale 1ns / 1ps

module ControlPath_tb;

    //inputs to the main control
    reg [6:0] opcode;
    //inputs to ALU contorl
    reg [2:0] funct3;
    reg [6:0] funct7;

    //outputs from main control
    wire RegWrite;
    wire ALUSrc;
    wire MemRead;
    wire MemWrite;
    wire MemtoReg;
    wire Branch;
    wire [1:0] ALUOp;

    //output from ALU contorl
    wire [3:0] ALUControl;


    //main control unit
    MainControl main_control (
        .opcode(opcode),

        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch(Branch),

        .ALUOp(ALUOp)
    );


    //alu contorl unit
    ALUControl alu_control (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),

        .ALUControl(ALUControl)
    );

    initial begin

        //initial values
        opcode = 7'd0;
        funct3 = 3'd0;
        funct7 = 7'd0;

        #10;


        //test 1 add r type

        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;

        #10;

        if ((RegWrite == 1) &&
            (ALUSrc == 0) &&
            (MemRead == 0) &&
            (MemWrite == 0) &&
            (MemtoReg == 0) &&
            (Branch == 0) &&
            (ALUOp == 2'b10) &&
            (ALUControl == 4'b0000))

            $display("PASS: ADD");

        else
            $display("FAIL: ADD");


        //test 2 sub

        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0100000;

        #10;

        if (ALUControl == 4'b0001)
            $display("PASS: SUB");
        else
            $display("FAIL: SUB");


        //test 3 sll

        opcode = 7'b0110011;
        funct3 = 3'b001;
        funct7 = 7'b0000000;

        #10;

        if (ALUControl == 4'b0101)
            $display("PASS: SLL");
        else
            $display("FAIL: SLL");


        //test 4 srl

        opcode = 7'b0110011;
        funct3 = 3'b101;
        funct7 = 7'b0000000;

        #10;

        if (ALUControl == 4'b0110)
            $display("PASS: SRL");
        else
            $display("FAIL: SRL");


        //test 5 and

        opcode = 7'b0110011;
        funct3 = 3'b111;
        funct7 = 7'b0000000;

        #10;

        if (ALUControl == 4'b0010)
            $display("PASS: AND");
        else
            $display("FAIL: AND");


        //test 6 or

        opcode = 7'b0110011;
        funct3 = 3'b110;
        funct7 = 7'b0000000;

        #10;

        if (ALUControl == 4'b0011)
            $display("PASS: OR");
        else
            $display("FAIL: OR");


        //test 7 xor

        opcode = 7'b0110011;
        funct3 = 3'b100;
        funct7 = 7'b0000000;

        #10;

        if (ALUControl == 4'b0100)
            $display("PASS: XOR");
        else
            $display("FAIL: XOR");


        //test 8 addi

        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;

        #10;

        if ((RegWrite == 1) &&
            (ALUSrc == 1) &&
            (MemRead == 0) &&
            (MemWrite == 0) &&
            (MemtoReg == 0) &&
            (Branch == 0) &&
            (ALUOp == 2'b11) &&
            (ALUControl == 4'b0000))

            $display("PASS: ADDI");

        else
            $display("FAIL: ADDI");


        //test 9 lw

        opcode = 7'b0000011;
        funct3 = 3'b010;

        #10;

        if ((RegWrite == 1) &&
            (ALUSrc == 1) &&
            (MemRead == 1) &&
            (MemWrite == 0) &&
            (MemtoReg == 1) &&
            (Branch == 0) &&
            (ALUOp == 2'b00) &&
            (ALUControl == 4'b0000))

            $display("PASS: LW");

        else
            $display("FAIL: LW");


        //test 10 lh

        opcode = 7'b0000011;
        funct3 = 3'b001;

        #10;

        if ((MemRead == 1) &&
            (RegWrite == 1) &&
            (ALUControl == 4'b0000))

            $display("PASS: LH");

        else
            $display("FAIL: LH");


        //test 11 lb

        opcode = 7'b0000011;
        funct3 = 3'b000;

        #10;

        if ((MemRead == 1) &&
            (RegWrite == 1) &&
            (ALUControl == 4'b0000))

            $display("PASS: LB");

        else
            $display("FAIL: LB");


        //test 12 sw

        opcode = 7'b0100011;
        funct3 = 3'b010;

        #10;

        if ((RegWrite == 0) &&
            (ALUSrc == 1) &&
            (MemRead == 0) &&
            (MemWrite == 1) &&
            (Branch == 0) &&
            (ALUOp == 2'b00) &&
            (ALUControl == 4'b0000))

            $display("PASS: SW");

        else
            $display("FAIL: SW");


        //test 13 sh

        opcode = 7'b0100011;
        funct3 = 3'b001;

        #10;

        if ((MemWrite == 1) &&
            (RegWrite == 0) &&
            (ALUControl == 4'b0000))

            $display("PASS: SH");

        else
            $display("FAIL: SH");


        //test 14 sb

        opcode = 7'b0100011;
        funct3 = 3'b000;

        #10;

        if ((MemWrite == 1) &&
            (RegWrite == 0) &&
            (ALUControl == 4'b0000))

            $display("PASS: SB");

        else
            $display("FAIL: SB");


        //test 15 beq

        opcode = 7'b1100011;
        funct3 = 3'b000;

        #10;

        if ((RegWrite == 0) &&
            (ALUSrc == 0) &&
            (MemRead == 0) &&
            (MemWrite == 0) &&
            (Branch == 1) &&
            (ALUOp == 2'b01) &&
            (ALUControl == 4'b0001))

            $display("PASS: BEQ");

        else
            $display("FAIL: BEQ");


        #20;

        $finish;

    end

endmodule