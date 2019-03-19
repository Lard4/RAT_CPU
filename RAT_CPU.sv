`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kevin Dixson
// 
// Create Date: 02/07/2019 02:42:59 PM
// Design Name: 
// Module Name: RAT_CPU
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


module RAT_CPU(
    input CLK, INTERRUPT, RESET,
    input [7:0] IN_PORT,
    output IO_STRB, 
    output logic [7:0] OUT_PORT, PORT_ID
    );
    
    ////// PC AND PC MUX
    logic cu_to_pc_rst, cu_to_pc_ld, cu_to_pc_inc;
    logic [9:0] pc_mux_out;
    logic [9:0] pc_out;
    logic [1:0] cu_to_pc_mux_pc_mux_sel;
    ////// END PC AND PC MUX
    
    ////// PROG ROM
    logic [17:0] instruction;
    ////// END PROG ROM
    
    ////// REGISTER FILE AND MUX
    logic cu_to_rf_rf_wr;
    logic [7:0] rf_dx_out, rf_dy_out;
    logic [7:0] rf_mux_to_rf_din;
    logic [1:0] cu_to_rf_mux_rf_wr_sel;
    ////// END REGISTER FILE AND MUX
    
    ////// ALU AND MUX
    logic [3:0] cu_to_alu_alu_sel;
    logic [7:0] alu_mux_to_alu_b;
    logic [7:0] alu_result;
    logic alu_c, alu_z;
    logic cu_to_alu_mux_alu_op_y_sel;
    ////// END ALU AND MUX
    
    ////// FLAGS
    logic cu_to_flg_flg_c_set, cu_to_flg_flg_c_clr, cu_to_flg_flg_c_ld,
          cu_to_flg_flg_z_ld, cu_to_flg_flg_ld_sel, cu_to_flg_flg_shad_ld;
    logic flg_to_cu_c_flag, flg_to_cu_z_flag;
    ////// END FLAGS
    
    ////// STACK POINTER
    logic cu_to_sp_sp_ld, cu_to_sp_sp_incr, cu_to_sp_sp_decr;
    logic [7:0] sp_data_out;
    ////// END STACK POINTER

    ////// SCRATCH RAM AND MUX
    logic [9:0] scr_data_in, scr_data_out;
    logic [7:0] scr_addr;
    logic [1:0] cu_to_scr_scr_addr_sel;
    logic cu_to_scr_scr_we, cu_to_scr_scr_data_sel;
    ////// END SCRATCH RAM AND MUX
    
    ////// INTERRUPT
    logic i_out_to_and;
    logic and_to_interrupt_cu;
    logic cu_to_i_i_set, cu_to_i_i_clr;
    ////// END INTERRUPT
    
    InterruptFlag iflg (.SET(cu_to_i_i_set), 
                        .CLR(cu_to_i_i_clr), 
                        .CLK(CLK),
                        .OUT(i_out_to_and));
                        
    ScratchRam sr (.DATA_IN(scr_data_in), 
                   .SCR_ADDR(scr_addr), 
                   .SCR_WE(cu_to_scr_scr_we), 
                   .CLK(CLK),
                   .DATA_OUT(scr_data_out));
                   
    ProgramCounter pc (.RST(cu_to_pc_rst), 
                       .PC_LD(cu_to_pc_ld), 
                       .PC_INC(cu_to_pc_inc), 
                       .DIN(pc_mux_out), 
                       .CLK(CLK), 
                       .PC_COUNT(pc_out));
                       
    PCMux pcm (.FROM_IMMED(instruction[12:3]), 
               .FROM_STACK(scr_data_out), 
               .PC_MUX_SEL(cu_to_pc_mux_pc_mux_sel),
               .Q(pc_mux_out));
               
    ProgRom pr (.PROG_ADDR(pc_out), 
                .CLK(CLK),
                .PROG_IR(instruction));
                
    RegisterFile rf (.DIN(rf_mux_to_rf_din), 
                     .RF_WR(cu_to_rf_rf_wr), 
                     .ADRX(instruction[12:8]), 
                     .ADRY(instruction[7:3]), 
                     .CLK(CLK),
                     .DX_OUT(rf_dx_out), 
                     .DY_OUT(rf_dy_out));
                     
    ALU alu (.CIN(flg_to_cu_c_flag), 
             .SEL(cu_to_alu_alu_sel), 
             .A(rf_dx_out), 
             .B(alu_mux_to_alu_b),
             .RESULT(alu_result), 
             .C(alu_c), 
             .Z(alu_z));
             
    Flags f (.FLG_C_SET(cu_to_flg_flg_c_set), 
             .FLG_C_CLR(cu_to_flg_flg_c_clr), 
             .FLG_C_LD(cu_to_flg_flg_c_ld), 
             .FLG_Z_LD(cu_to_flg_flg_z_ld), 
             .FLG_LD_SEL(cu_to_flg_flg_ld_sel), 
             .FLG_SHAD_LD(cu_to_flg_flg_shad_ld), 
             .C(alu_c), 
             .Z(alu_z), 
             .CLK(CLK),
             .C_FLAG(flg_to_cu_c_flag), 
             .Z_FLAG(flg_to_cu_z_flag));
             
    StackPointer sp (.DATA(rf_dx_out), 
                     .RST(cu_to_pc_rst), 
                     .INCR(cu_to_sp_sp_incr), 
                     .DECR(cu_to_sp_sp_decr), 
                     .LD(cu_to_sp_sp_ld), 
                     .CLK(CLK),
                     .OUT(sp_data_out));
                     
    ControlUnit cu (.C(flg_to_cu_c_flag), 
                    .Z(flg_to_cu_z_flag), 
                    .INTERRUPT(and_to_interrupt_cu), 
                    .RESET(RESET), 
                    .OPCODE_HI_5(instruction[17:13]), 
                    .OPCODE_LO_2(instruction[1:0]), 
                    .CLK(CLK),
                    .I_SET(cu_to_i_i_set), 
                    .I_CLR(cu_to_i_i_clr),
                    .PC_LD(cu_to_pc_ld), 
                    .PC_INC(cu_to_pc_inc), 
                    .PC_MUX_SEL(cu_to_pc_mux_pc_mux_sel),
                    .ALU_OPY_SEL(cu_to_alu_mux_alu_op_y_sel), 
                    .ALU_SEL(cu_to_alu_alu_sel),
                    .RF_WR(cu_to_rf_rf_wr), 
                    .RF_WR_SEL(cu_to_rf_mux_rf_wr_sel),
                    .SP_LD(cu_to_sp_sp_ld), 
                    .SP_INCR(cu_to_sp_sp_incr), 
                    .SP_DECR(cu_to_sp_sp_decr),
                    .SCR_WE(cu_to_scr_scr_we), 
                    .SCR_ADDR_SEL(cu_to_scr_scr_addr_sel), 
                    .SCR_DATA_SEL(cu_to_scr_scr_data_sel),
                    .FLG_C_SET(cu_to_flg_flg_c_set), 
                    .FLG_C_CLR(cu_to_flg_flg_c_clr), 
                    .FLG_C_LD(cu_to_flg_flg_c_ld), 
                    .FLG_Z_LD(cu_to_flg_flg_z_ld), 
                    .FLG_LD_SEL(cu_to_flg_flg_ld_sel), 
                    .FLG_SHAD_LD(cu_to_flg_flg_shad_ld),
                    .RST(cu_to_pc_rst),
                    .IO_STRB(IO_STRB));

    always_comb begin
        case (cu_to_rf_mux_rf_wr_sel)
            0: 
                rf_mux_to_rf_din = alu_result;  // ALU's result
            1: 
                rf_mux_to_rf_din = scr_data_out;  // scratch ram data out
            2: 
                rf_mux_to_rf_din = 0;  // stack pointer data out
            3: 
                rf_mux_to_rf_din = IN_PORT;  // outside data
            default:
                rf_mux_to_rf_din = 0; // prevent memory creation with default
        endcase
        
        if (cu_to_alu_mux_alu_op_y_sel)
            alu_mux_to_alu_b = instruction[7:0];
        else
            alu_mux_to_alu_b = rf_dy_out;  // register file y data
                    
        case (cu_to_scr_scr_addr_sel)
            0: 
                scr_addr = rf_dy_out;  // register file y data
            1: 
                scr_addr = instruction[7:0];
            2: 
                scr_addr = sp_data_out;  // stack pointer location
            3: 
                scr_addr = sp_data_out - 1;  // stack pointer -1 location
            default:
                scr_addr = 0;  // prevent memory creation with default
        endcase
        
        if (cu_to_scr_scr_data_sel)
            scr_data_in = pc_out;  // program counter location
        else
            scr_data_in = rf_dx_out;  // register file x data
    end
    
    assign PORT_ID = instruction[7:0];
    assign OUT_PORT = rf_dx_out;
    assign and_to_interrupt_cu = INTERRUPT & i_out_to_and;
endmodule
