`timescale 1ns / 1ps

module ALUControl (
    input wire [1:0] ALUOp,
    input wire [2:0] funct3,
    input wire [6:0] funct7,

    output reg [3:0] ALUControl
);

    always @(*) begin

        // safe valeus default
        ALUControl = 4'b0000;
        case (ALUOp)

            //load/store
            //address calculation uses ADD
            2'b00: begin
                ALUControl = 4'b0000;
            end

            //beq
            //compare uses sub
            2'b01: begin
                ALUControl = 4'b0001;
            end


            //r type instructions
            2'b10: begin

                case (funct3)

                    //add/sub
                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            ALUControl = 4'b0001;   //sub
                        else
                            ALUControl = 4'b0000;   //add
                    end

                    //sll
                    3'b001: begin
                        ALUControl = 4'b0101;
                    end

                    //xor
                    3'b100: begin
                        ALUControl = 4'b0100;
                    end


                    //srl
                    3'b101: begin
                        ALUControl = 4'b0110;
                    end

                    //or
                    3'b110: begin
                        ALUControl = 4'b0011;
                    end


                    //and
                    3'b111: begin
                        ALUControl = 4'b0010;
                    end


                    default: begin
                        ALUControl = 4'b0000;
                    end

                endcase

            end

            //addi
            2'b11: begin
                ALUControl = 4'b0000;
            end

            default: begin
                ALUControl = 4'b0000;
            end
        endcase
    end

endmodule