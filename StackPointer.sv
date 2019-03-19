`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kevin Dixson
// 
// Create Date: 02/21/2019 01:58:54 PM
// Design Name: 
// Module Name: StackPointer
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


module StackPointer(
    input logic [7:0] DATA,
    input logic INCR, DECR, RST, LD, CLK,
    output logic [7:0] OUT = 0
    );
    
    always_ff @(posedge CLK) begin
        if (RST == 1)
            OUT <= 0;
        else begin
            if (LD == 1)
                OUT <= DATA;
            else if (INCR == 1)
                OUT <= OUT + 1;
            else if (DECR == 1)
                OUT <= OUT - 1;
            else
                OUT <= OUT;
        end
    end
    
endmodule
