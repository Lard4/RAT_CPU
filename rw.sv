`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Paul Hummel
//
// Create Date: 06/28/2018 05:21:01 AM
// Module Name: RAT_WRAPPER
// Target Devices: RAT MCU on Basys3
// Description: Basic RAT_WRAPPER
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////

module rw(
    input CLK,
    input BTNC, BTNL,
    input C, A, E,
    output B, G, F, D, red_led, green_led, one_led, two_led, three_led, four_led
    );
    
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    localparam BTNC_ID      = 8'h10;
    localparam KEYPAD_ID    = 8'h11;
       
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    localparam GREENLED_ID  = 8'h41;
    localparam REDLED_ID    = 8'h40;
    localparam ONELED_ID  = 8'h42;
    localparam TWOLED_ID    = 8'h43;
    localparam THREELED_ID  = 8'h44;
    localparam FOURLED_ID    = 8'h45;
    
    // Signals for connecting RAT_MCU to RAT_wrapper /////////////////////////
    logic [7:0] s_output_port;
    logic [7:0] s_port_id;
    logic [7:0] KEY_NUM;
    logic s_load;
    logic s_interrupt;
    logic s_reset;
    logic s_clk_50 = 1'b0;  // 50 MHz clock
    logic DB_BTN;           //Debounce output signal
    logic s_KEY_inter;
    
    // Register definitions for output devices ///////////////////////////////
    logic [7:0]     s_input_port;
    logic           r_green_led = 0;
    logic           r_red_led   = 0;
    logic           r_one_led   = 0;
    logic           r_two_led   = 0;
    logic           r_three_led   = 0;
    logic           r_four_led   = 0;
    
    // Declare RAT_CPU ///////////////////////////////////////////////////////
    RAT_CPU MCU (.IN_PORT(s_input_port), .OUT_PORT(s_output_port),
                .PORT_ID(s_port_id), .IO_STRB(s_load), .RESET(s_reset),
                .INTERRUPT(s_interrupt), .CLK(s_clk_50));
                  
    // Declare debounce_one_shot//////////////////////////////////////////////
    
    // Declare Keypad ////////////////////////////////////////////////////////
    KeypadDriver KD (.C(C), .A(A), .E(E), .clk(CLK), .B(B), .G(G), .F(F), .D(D),
                     .interrupt(s_KEY_inter), .data(KEY_NUM));
    
    // Clock Divider to create 50 MHz Clock //////////////////////////////////
    always_ff @(posedge CLK) begin
        s_clk_50 <= ~s_clk_50;
    end
    
     
    // MUX for selecting what input to read //////////////////////////////////
    always_comb begin
        if(s_port_id==BTNC_ID)
            s_input_port    = BTNC;
        else if(s_port_id == KEYPAD_ID)
            s_input_port    = KEY_NUM;
        else
            s_input_port    = 8'h00;
    end
   
    // MUX for updating output registers /////////////////////////////////////
    // Register updates depend on rising clock edge and asserted load signal
    always_ff @ (posedge CLK)
        begin
        if (s_load == 1'b1)begin
            if (s_port_id == GREENLED_ID)
                r_green_led  <= s_output_port;
            else if (s_port_id == REDLED_ID)
                r_red_led    <= s_output_port;
            else if (s_port_id == ONELED_ID)
                r_one_led    <= s_output_port;
            else if (s_port_id == TWOLED_ID)
                r_two_led    <= s_output_port;
            else if (s_port_id == THREELED_ID)
                r_three_led    <= s_output_port;
            else if (s_port_id == FOURLED_ID)
                r_four_led    <= s_output_port;
            else begin
            
            end
        end
        else begin
            // do nothing
        end
        end
     
    // Connect Signals ///////////////////////////////////////////////////////
    assign s_reset      = BTNL;
    assign s_interrupt  = BTNC ^ s_KEY_inter;
    
    // Output Assignments ////////////////////////////////////////////////////
    assign red_led   = r_red_led;
    assign green_led = r_green_led;
    assign one_led = r_one_led;
    assign two_led = r_two_led;
    assign three_led = r_three_led;
    assign four_led = r_four_led;
    endmodule


