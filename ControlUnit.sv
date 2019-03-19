`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2019 01:57:21 PM
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input C, Z, INTERRUPT, RESET, CLK,
    input [4:0] OPCODE_HI_5,
    input [1:0] OPCODE_LO_2,
    
    output logic IO_STRB,
    
    // Interrupt
    output logic I_SET,
    output logic I_CLR,
    
    // ProgramCounter
    output logic PC_LD,
    output logic PC_INC,
    output logic [1:0] PC_MUX_SEL,
    output logic RST,
    
    // ALU
    output logic ALU_OPY_SEL,
    output logic [3:0] ALU_SEL,
    
    // RegisterFile
    output logic RF_WR,
    output logic [1:0] RF_WR_SEL,
    
    // StackPointer
    output logic SP_LD,
    output logic SP_INCR,
    output logic SP_DECR,
    
    // ScratchRAM
    output logic SCR_WE,
    output logic [1:0] SCR_ADDR_SEL,
    output logic SCR_DATA_SEL,
    
    // Flags
    output logic FLG_C_SET,
    output logic FLG_C_CLR,
    output logic FLG_C_LD,
    output logic FLG_Z_LD,
    output logic FLG_LD_SEL,
    output logic FLG_SHAD_LD
);
    
    typedef enum {ST_INIT, ST_FETCH, ST_INTRPT, ST_EXEC} STATE;
    STATE NS, PS = ST_INIT;  // set NS and PS to ST_INIT to start
    
    always_ff @(posedge CLK) begin
        if (RESET == 1)
            PS <= ST_INIT;
        else
            PS <= NS;
    end
    
    always_comb begin
        // everything is 0 unless otherwise specified
        RST = 0;
        I_SET = 0;
        I_CLR = 0;
        PC_LD = 0;
        PC_INC = 0;
        PC_MUX_SEL = 2'b0;
        ALU_OPY_SEL = 0;
        ALU_SEL = 4'b0;
        RF_WR = 0;
        RF_WR_SEL = 2'b0;
        SP_LD = 0;
        SP_INCR = 0;
        SP_DECR = 0;
        SCR_WE = 0;
        SCR_ADDR_SEL = 2'b0;
        SCR_DATA_SEL = 0;
        FLG_C_SET = 0;
        FLG_C_CLR = 0;
        FLG_C_LD = 0;
        FLG_Z_LD = 0;
        FLG_LD_SEL = 0;
        FLG_SHAD_LD = 0;
        IO_STRB = 0;
        
        case (PS)
            ST_INIT: begin
                RST = 1;  // reset the PC
                NS = ST_FETCH;
            end
            
            ST_FETCH: begin
                PC_INC = 1;  // tell PC to keep going
                NS = ST_EXEC;
            end
            
            ST_INTRPT: begin
                I_CLR = 1;
                SP_DECR = 1;
                SCR_WE = 1;
                SCR_DATA_SEL = 1;
                SCR_ADDR_SEL = 3;
                FLG_SHAD_LD = 1;
                PC_MUX_SEL = 2;
                PC_LD = 1;
                NS = ST_FETCH;
            end
            
            ST_EXEC: begin
                // specify what should be active based on opcode
                case ({OPCODE_HI_5, OPCODE_LO_2})
                    // ADD reg-reg
                    7'b0000100: begin
                        RF_WR = 1;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // ADD reg-imm
                    7'b1010000, 7'b1010001, 7'b1010010, 7'b1010011: begin
                        RF_WR = 1;
                        ALU_OPY_SEL = 1;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // ADDC reg-reg
                    7'b0000101: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b0001;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // ADDC reg-imm
                    7'b1010100, 7'b1010101, 7'b1010110, 7'b1010111: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b0001;
                        ALU_OPY_SEL = 1;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // AND reg-reg
                    7'b0000000: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b0101;
                        FLG_C_CLR = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // AND reg-imm
                    7'b1000000, 7'b1000001, 7'b1000010, 7'b1000011: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b0101;
                        ALU_OPY_SEL = 1;
                        FLG_C_CLR = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // ASR
                    7'b0100100: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b1101;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // BRCC
                    7'b0010101: begin
                        if (C == 0)
                            PC_LD = 1;
                    end
                    
                    // BRCS
                    7'b0010100: begin
                        if (C == 1)
                            PC_LD = 1;
                    end
                    
                    // BREQ
                    7'b0010010: begin
                        if (Z == 1)
                            PC_LD = 1;
                    end
                    
                    // BRN
                    7'b0010000: begin
                        PC_LD = 1;
                    end
                    
                    // BRNE
                    7'b0010011: begin
                        if (Z == 0)
                            PC_LD = 1;
                    end
                    
                    // CALL
                    7'b0010001: begin
                        PC_LD = 1;
                        SCR_DATA_SEL = 1;
                        SCR_WE = 1;
                        SCR_ADDR_SEL = 3;
                        SP_DECR = 1;
                    end
                    
                    // CLC
                    7'b0110000: begin
                        FLG_C_CLR = 1;
                    end
                    
                    // CLI
                    7'b0110101: begin
                        I_CLR = 1;
                    end
                    
                    // CMP reg-reg
                    7'b0001000: begin
                        ALU_SEL = 4'b0100;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // CMP reg-imm
                    7'b1100000,  7'b1100001, 7'b1100010,  7'b1100011: begin
                        ALU_SEL = 4'b0100;
                        ALU_OPY_SEL = 1;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // EXOR reg-reg
                    7'b0000010: begin
                        RF_WR = 1;
                        ALU_SEL = 7;
                        FLG_C_CLR = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // EXOR reg-imm
                    7'b1001000, 7'b1001001, 7'b1001010, 7'b1001011: begin
                        RF_WR = 1;
                        ALU_SEL = 7;
                        ALU_OPY_SEL = 1;
                        FLG_C_CLR = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // IN
                    7'b1100100, 7'b1100101, 7'b1100110, 7'b1100111: begin
                        RF_WR_SEL = 3;
                        RF_WR = 1;
                    end
                    
                    // LD reg-reg
                    7'b0001010: begin
                        RF_WR = 1;
                        RF_WR_SEL = 1;
                    end
                    
                    // LD reg-imm
                    7'b1110000, 7'b1110001, 7'b1110010, 7'b1110011: begin
                        RF_WR = 1;
                        RF_WR_SEL = 1;
                        SCR_ADDR_SEL = 1;
                    end
                    
                    // LSL
                    7'b0100000: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b1001;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // LSR
                    7'b0100001: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b1010;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // MOV reg-reg
                    7'b0001001: begin
                        RF_WR = 1;
                        ALU_SEL = 14;
                    end
                    
                    // MOV reg-imm
                    7'b1101100, 7'b1101101, 7'b1101110, 7'b1101111: begin
                        RF_WR = 1;
                        ALU_SEL = 14;
                        ALU_OPY_SEL = 1;
                    end
                    
                    // OR reg-reg
                    7'b0000001: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b0110;
                        FLG_C_CLR = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // OR reg-imm
                    7'b1000100, 7'b1000101, 7'b1000110, 7'b1000111: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b0110;
                        ALU_OPY_SEL = 1;
                        FLG_C_CLR = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // OUT
                    7'b1101000, 7'b1101001, 7'b1101010, 7'b1101011: begin
                        IO_STRB = 1;
                    end
                    
                    // POP
                    7'b0100110: begin
                        RF_WR = 1;
                        RF_WR_SEL = 1;
                        SCR_ADDR_SEL = 2;
                        SP_INCR = 1;
                    end
                    
                    // PUSH
                    7'b0100101: begin
                        SCR_WE = 1;
                        SCR_ADDR_SEL = 3;
                        SP_DECR = 1;
                    end
                    
                    // RET
                    7'b0110010: begin
                        PC_LD = 1;
                        PC_MUX_SEL = 1;
                        SCR_ADDR_SEL = 2;
                        SP_INCR = 1;
                    end
                    
                    // RETID
                    7'b0110110: begin
                        PC_LD = 1;
                        PC_MUX_SEL = 1;
                        SCR_ADDR_SEL = 2;
                        SP_INCR = 1;
                        FLG_C_LD =1;
                        FLG_Z_LD = 1;
                        I_CLR = 1;
                        FLG_LD_SEL = 1;
                    end
                    
                    // RETIE
                    7'b0110111: begin
                        PC_LD = 1;
                        PC_MUX_SEL = 1;
                        SCR_ADDR_SEL = 2;
                        SP_INCR = 1;
                        FLG_C_LD =1;
                        FLG_Z_LD = 1;
                        I_SET = 1;
                        FLG_LD_SEL = 1;
                    end
                    
                    // ROL
                    7'b0100010: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b1011;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // ROR
                    7'b0100011: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b1100;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // SEC
                    7'b0110001: begin
                        FLG_C_SET = 1;
                    end
                    
                    // SEI
                    7'b0110100: begin
                        I_SET = 1;
                    end
                    
                    // ST reg-reg
                    7'b0001011: begin
                        SCR_WE = 1;
                    end
                    
                    // ST reg-imm
                    7'b1110100, 7'b1110101, 7'b1110110, 7'b1110111: begin
                        SCR_WE = 1;
                        SCR_ADDR_SEL = 1;
                    end
                    
                    // SUB reg-reg
                    7'b0000110: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b0010;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // SUB reg-imm
                    7'b1011000, 7'b1011001, 7'b1011010, 7'b1011011: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b0010;
                        ALU_OPY_SEL = 1;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // SUBC reg-reg
                    7'b0000111: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b0011;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // SUBC reg-imm
                    7'b1011100, 7'b1011101, 7'b1011110, 7'b1011111: begin
                        RF_WR = 1;
                        ALU_SEL = 4'b0011;
                        ALU_OPY_SEL = 1;
                        FLG_C_LD = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // TEST reg-reg
                    7'b0000011: begin
                        ALU_SEL = 4'b1000;
                        FLG_C_CLR = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // TEST reg-imm
                    7'b1001100, 7'b1001101, 7'b1001110, 7'b1001111: begin
                        ALU_SEL = 4'b1000;
                        ALU_OPY_SEL = 1;
                        FLG_C_CLR = 1;
                        FLG_Z_LD = 1;
                    end
                    
                    // WSP
                    7'b0101000: begin
                        SP_LD = 1;
                    end
                    
                    default:
                        RST = 1;  // should never get here
                endcase

                if (INTERRUPT == 1)
                    NS = ST_INTRPT;
                else
                    NS = ST_FETCH;
            end
            
            default:
                NS = ST_INIT;  // should never get here
        endcase
    end
endmodule
