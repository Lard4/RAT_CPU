`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Sanders Sanabria
// 
// Create Date: 03/02/2019 09:12:37 PM
// Module Name: KeypadFSM 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module KeypadFSM(
    input C, A, E, clk,
    output logic B, G, F, D, press,
    output logic [3:0] data
    );
    typedef enum{ST_B, ST_G, ST_F, ST_D} STATE;
    STATE NS, PS=ST_B;
    
    always_ff @(posedge clk)
    begin
        PS <= NS;
    end
    
    always_comb
    begin
        B=0; G=0; F=0; D=0; press=0; data=4'hF;
        case (PS)
        ST_B:
            begin
            B=1;
            NS=ST_G;
            if(C)
                begin
                press=1;
                data=1;
                end
            else if(A)
                begin
                press=1;
                data=2;
                end
            else if(E)
                begin
                press=1;
                data=3;
                end
            else
            ;
            end
        ST_G:
            begin
            G=1;
            NS=ST_F;
            if(C)
                begin
                press=1;
                data=4;
                end
            else if(A)
                begin
                press=1;
                data=5;
                end
            else if(E)
                begin
                press=1;
                data=6;
                end
            else
            ;
            end
        ST_F:
            begin
            F=1;
            NS=ST_D;
            if(C)
                begin
                press=1;
                data=7;
                end
            else if(A)
                begin
                press=1;
                data=8;
                end
            else if(E)
                begin
                press=1;
                data=9;
                end
            else
                ;
            end
        ST_D:
            begin
            D=1;
            NS=ST_B;
            if(C)
                begin
                press=1;
                data=4'hA;
                end
            else if(A)
                begin
                press=1;
                data=0;
                end
            else if(E)
                begin
                press=1;
                data=4'hB;
                end
            else
                ;
            end
            default:
            begin
                ;
            end
        endcase       
    end
    
endmodule
