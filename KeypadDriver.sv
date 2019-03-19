`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Sanders Sanabria
// 
// Create Date: 03/03/2019 01:06:26 PM
// Module Name: KeypadDriver
// Description: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module KeypadDriver(
    input C, A, E, clk,
    output B, G, F, D, interrupt,
    output logic [7:0] data
    );
    logic press, sclk;
    logic [3:0] t1;
    
    ClockDivider  CD(.CLK(clk), .SCLK(sclk));
    KeypadFSM   Key(.C(C), .A(A), .E(E), .clk(sclk), .B(B), .G(G), .F(F), .D(D), .press(press), .data(t1));
    IntKeyFSM   I(.press(press), .clk(clk), .interrupt(interrupt));
    
    always_ff @ (posedge sclk)
    begin
        if(press)
            data<=t1;
    end
endmodule
