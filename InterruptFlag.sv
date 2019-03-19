`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2019 09:39:28 PM
// Design Name: 
// Module Name: InterruptFlag
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


module InterruptFlag(
    input SET, CLR, CLK,
    output logic OUT
    );
    
    always_ff @(posedge CLK) begin
        if (SET == 1)
            OUT <= 1;
        else if (CLR == 1)
            OUT <= 0;
    end
endmodule
