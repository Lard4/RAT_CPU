`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Sanders Sanabria
// Create Date: 03/02/2019 09:58:53 PM
// Module Name: IntKeyFSM 
// Description: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IntKeyFSM(
    input press, clk,
    output logic interrupt
    );
    typedef enum{ST_START, ST_1, ST_2, ST_3, ST_4, ST_5, ST_6, ST_DONE} STATE;
    STATE NS, PS=ST_START;
    
    always_ff @(posedge clk)
    begin
    PS <= NS;
    end
    
    always_comb
    begin
        interrupt=0;
        case(PS)
            ST_START:
            begin
                if(press)
                    NS=ST_1;
                else
                    NS=ST_START;
            end
            ST_1:
            begin
                interrupt=1;
                NS=ST_2;
            end
            ST_2:
            begin
                interrupt=1;
                NS=ST_3;
           end
           ST_3:
           begin
                interrupt=1;
                NS=ST_4;
            end
            ST_4:
            begin
                interrupt=1;
                NS=ST_5;
            end
            ST_5:
            begin
                interrupt=1;
                NS=ST_6;
            end
            ST_6:
            begin
                interrupt=1;
                NS=ST_DONE;
            end
            ST_DONE:
            begin
                if(press)
                    NS=ST_DONE;
                else
                    NS=ST_START;
            end
            default:
            begin
                ;
            end
        endcase
    end
endmodule
