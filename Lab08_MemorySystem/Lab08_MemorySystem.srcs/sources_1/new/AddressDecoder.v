`timescale 1ns / 1ps

module AddressDecoder (
    input wire [9:0] address,
    input wire readEnable,
    input wire writeEnable,

    output reg DataMemWrite,
    output reg DataMemRead,
    output reg LEDWrite,
    output reg SwitchReadEnable
);

    always @(*) begin


        //the defaultso nothing is selected
        DataMemWrite = 1'b0;
        DataMemRead = 1'b0;
       
        LEDWrite = 1'b0;
        
        SwitchReadEnable = 1'b0;
        case (address[9:8])

            2'b00: begin
                DataMemWrite = writeEnable;
                DataMemRead = readEnable;
            end
            2'b01: begin
                LEDWrite=writeEnable;
            end

            2'b10: begin
                SwitchReadEnable= readEnable;
            end

            2'b11: begin
            end
        endcase

    end
    
    

endmodule