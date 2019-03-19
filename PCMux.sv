`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2019 01:36:10 PM
// Design Name: 
// Module Name: PCMux
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


module PCMux(
    input [9:0] FROM_IMMED, FROM_STACK,
    input [1:0] PC_MUX_SEL,
    output logic [9:0] Q
    );
    
    always_comb begin
        case (PC_MUX_SEL)
            0: begin
                Q = FROM_IMMED;
            end
            
            1: begin
                Q = FROM_STACK;
            end
            
            default: begin
                Q = 10'h3FF;
            end
        endcase
    end
    
endmodule
