`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2019 01:28:50 PM
// Design Name: 
// Module Name: KeyFSM
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


module KeyFSM(
    input logic CLK, C, A, E,
    output logic press, B, G, F, D,
    output logic [3:0] data
    );
    
    typedef enum {STB, STG, STF, STD} STATE;
    
    STATE NS, PS = STB;
    
    always_ff @(posedge CLK) begin
        PS <= NS;
    end
    
    always_comb begin
        B = 0;
        G = 0;
        F = 0;
        D = 0;
        press = 0;
        data = 0;
        
        case (PS)
            STB: begin
                B = 1;
                NS = STG;
                
                if (C == 1) begin
                    data = 1;
                    press = 1;
                end
                else if (A == 1) begin
                    data = 2;
                    press = 1;
                end
                else if (E == 1) begin
                    data = 3;
                    press = 1;
                end
                else begin
                    data = 13;
                    press = 0;
                end
            end
            
            STG: begin
                G = 1;
                NS = STF;
                
                if (C == 1) begin
                    data = 4;
                    press = 1;
                end
                else if (A == 1) begin
                    data = 5;
                    press = 1;
                end
                else if (E == 1) begin
                    data = 6;
                    press = 1;
                end
                else begin
                    data = 13;
                    press = 0;
                end
            end
            
            STF: begin
                F = 1;
                NS = STD;
                
                if (C == 1) begin
                    data = 7;
                    press = 1;
                end
                else if (A == 1) begin
                    data = 8;
                    press = 1;
                end
                else if (E == 1) begin
                    data = 9;
                    press = 1;
                end
                else begin
                    data = 13;
                    press = 0;
                end
            end
            
            STD: begin
                D = 1;
                NS = STB;
                
                if (C == 1) begin
                    data = 10;
                    press = 1;
                end
                else if (A == 1) begin
                    data = 0;
                    press = 1;
                end
                else if (E == 1) begin
                    data = 11;
                    press = 1;
                end
                else begin
                    data = 13;  // turns off displays
                    press = 0;
                end
            end
            
            default: begin
                //noop
            end
        endcase
    end
endmodule
