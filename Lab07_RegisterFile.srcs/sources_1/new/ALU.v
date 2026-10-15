`timescale 1ns / 1ps

module ALU(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] ALUcontrol,
    output reg [31:0] ALUresult,
    output wire Zero
);

    localparam ADD = 4'b0000;
    localparam SUB = 4'b0001;
    localparam AND = 4'b0010;
    localparam OR  = 4'b0011;
    localparam XOR = 4'b0100;
    localparam SLL = 4'b0101;
    localparam SRL = 4'b0110;

    always @(*) begin
        case (ALUcontrol)
            ADD: ALUresult = A + B;
            SUB: ALUresult = A - B;
            AND: ALUresult = A & B;
            OR:  ALUresult = A | B;
            XOR: ALUresult = A ^ B;
            SLL: ALUresult = A << B[4:0];
            SRL: ALUresult = A >> B[4:0];
            default: ALUresult = 32'd0;
        endcase
    end

    assign Zero = (ALUresult == 32'd0) ? 1'b1 : 1'b0;

endmodule