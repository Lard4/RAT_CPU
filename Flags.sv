`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kevin Dixson
// 
// Create Date: 02/07/2019 02:35:32 PM
// Design Name: 
// Module Name: Flags
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


module Flags(
    input CLK,
          C, Z,
          FLG_C_SET, FLG_C_CLR, FLG_C_LD,
          FLG_Z_LD,
          FLG_LD_SEL, FLG_SHAD_LD,
    output logic C_FLAG = 0,
    output logic Z_FLAG = 0
    );
    
    logic shad_z_out, shad_c_out = 0;
    
    always_ff @(posedge CLK) begin
        if (FLG_C_CLR == 1)
            C_FLAG <= 0;
        else if (FLG_C_SET == 1)
            C_FLAG <= 1;
        else if (FLG_C_LD == 1)
            if (FLG_LD_SEL == 0)
                C_FLAG <= C;
            else
                C_FLAG <= shad_c_out;
    end
    
    always_ff @(posedge CLK) begin
        if (FLG_Z_LD == 1)
            if (FLG_LD_SEL == 0)
                Z_FLAG <= Z;
            else
                Z_FLAG <= shad_z_out;
    end
    
     always_ff @(posedge CLK) begin
        if (FLG_SHAD_LD == 1) begin
            shad_z_out <= Z_FLAG;
            shad_c_out <= C_FLAG;
        end
    end
    
    
endmodule
