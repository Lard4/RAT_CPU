`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2019 01:22:40 PM
// Design Name: 
// Module Name: ProgramCounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ProgramCounter(
    input [9:0] DIN,
    input PC_LD, PC_INC, RST, CLK,
    output logic [9:0] PC_COUNT = 1
    );
    
    always_ff @(posedge CLK) begin
        if (RST == 1)
            PC_COUNT <= 1;
        else begin
            if (PC_LD == 1)
                PC_COUNT <= DIN;
            else
                if (PC_INC == 1)
                    PC_COUNT <= PC_COUNT + 1;
        end
    end
    
    
endmodule
