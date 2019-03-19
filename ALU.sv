`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2019 02:01:46 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [7:0] A, B,
    input [3:0] SEL,
    input CIN,
    output [7:0] RESULT,
    output C, Z
    );
    
    logic [8:0] ninebit;
    
    always_comb begin
        case (SEL)
            0: begin  //ADD
                ninebit = {1'b0, A} + {1'b0, B};
            end
            1: begin  //ADDC
                ninebit = {1'b0, A} + {1'b0, B} + {8'b0, CIN};
            end
            2: begin  //SUB
                ninebit = {1'b0, A} - {1'b0, B};
            end
            3: begin  //SUBC
                ninebit = {1'b0, A} - {1'b0, B} - {8'b0, CIN};
            end
            4: begin  //CMP
                ninebit = {1'b0, A} - {1'b0, B}; 
            end
            5: begin  //AND
                ninebit = {1'b0, A} & {1'b0, B};
            end
            6: begin  //OR
                ninebit = {1'b0, A} | {1'b0, B};
            end
            7: begin  //EXOR
                ninebit = {1'b0, A} ^ {1'b0, B};
            end
            8: begin  //TEST
                ninebit = {1'b0, A} & {1'b0, B};
            end
            9: begin  //LSL
                ninebit = {A[7:0], CIN};
            end
            10: begin  //LSR
                ninebit = {A[0], CIN, A[7:1]};
            end
            11: begin  //ROL
                ninebit = {A, A[7]};
            end
            12: begin  //ROR
                ninebit = {A[0], A[0], A[7:1]};
            end
            13: begin  //ASR
                ninebit = {A[0], A[7], A[7:1]};
            end
            14: begin  //MOV
                ninebit = {1'b0, B};
            end
        endcase
    end
    
    assign C = ninebit[8];
    assign Z = ninebit[7:0] == 0;
    assign RESULT = ninebit[7:0];
    
endmodule
