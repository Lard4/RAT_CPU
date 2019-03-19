`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2019 01:56:45 PM
// Design Name: 
// Module Name: InterruptFSM
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


module InterruptFSM(
    input CLK, press,
    output logic interrupt
    );
    
    typedef enum {START, T1, T2, T3, T4, T5, T6, DONE} STATE;
    
    STATE NS, PS = START;
    
    always_ff @(posedge CLK) begin
        PS <= NS;
    end
    
    always_comb begin
        case (PS)
            START: begin
                if (press == 0)
                    NS = START;
                else
                    NS = T1;
            end
            
            T1: begin
                interrupt = 1;
                NS = T2;
            end
            
            T2: begin
                interrupt = 1;
                NS = T3;
            end
            
            T3: begin
                interrupt = 1;
                NS = T4;
            end
            
            T4: begin
                interrupt = 1;
                NS = T5;
            end
            
            T5: begin
                interrupt = 1;
                NS = T6;
            end
            
            T6: begin
                interrupt = 1;
                NS = DONE;
            end
            
            DONE: begin
                interrupt = 0;
                if (press == 1) 
                    NS = DONE;
                else
                    NS = START;
            end
        endcase
    end

    
endmodule
