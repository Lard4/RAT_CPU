`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Bridget Benson 
// 
// Create Date: 10/01/2018 10:22:13 AM
// Description: Generic Clock Divider.  Divides the input clock by MAXCOUNT*2
// 
//////////////////////////////////////////////////////////////////////////////////


module ClockDivider (
    input CLK, 
    output logic SCLK = 0
    );     
   
    logic [15:0] count = 0;    
    
    always_ff @ (posedge CLK)
    begin
        count = count + 1;
        if (count >= 2272727) begin
            count <= 0;
            SCLK <= ~SCLK;
        end
    end
    
endmodule