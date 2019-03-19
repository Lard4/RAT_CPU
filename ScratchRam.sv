`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2019 02:26:08 PM
// Design Name: 
// Module Name: ScratchRam
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


module ScratchRam(
    input [9:0] DATA_IN,
    input [7:0] SCR_ADDR,
    input SCR_WE, CLK,
    output [9:0] DATA_OUT
    );
    
    logic [9:0] memory [0:255];
    
    // initialize memory block
    initial begin
        int i;
        for (i = 0; i < 256; i++)
            memory[i] = 10'd0;
    end
    
    // assign values for writes
    always_ff @(posedge CLK) begin
        if (SCR_WE == 1)
            memory[SCR_ADDR] = DATA_IN;
    end
    
    assign DATA_OUT = memory[SCR_ADDR];
    
endmodule
