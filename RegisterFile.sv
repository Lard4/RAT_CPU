`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2019 01:40:49 PM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input [7:0] DIN,
    input [4:0] ADRX, ADRY,
    input RF_WR,
    input CLK,
    output [7:0] DX_OUT, DY_OUT
    );
    
    logic [7:0] memory [0:31];
    
    // initialize memory with zeroes
    initial begin
        int i;
        for (i = 0; i < 32; i++)
            memory[i] = 32'd0;
    end
    
    // write to ADRX if RF_WR is enabled
    always_ff @(posedge CLK) begin
        if (RF_WR)
            memory[ADRX] <= DIN;
        
    end
    
    // async read of data
    assign DX_OUT = memory[ADRX];
    assign DY_OUT = memory[ADRY];
    
endmodule
