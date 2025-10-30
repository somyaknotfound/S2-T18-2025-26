// ============================================================================
// File: dataflow.v
// Description: Dataflow modules (ALU, Comparator, BCD converters)
// ============================================================================

// ALU Unit - Dataflow Implementation
module alu_unit_dataflow (
    input  wire [7:0] balance,
    input  wire [1:0] action_type,
    output wire [7:0] new_balance,
    output wire       credit_ok
);
    wire [7:0] selected_cost, cost_complement, adder_b_input;
    wire add_sub_ctrl, carry_in, balance_ge_cost, bypass_check;
    
    assign add_sub_ctrl = action_type[0];
    assign selected_cost = action_type[1] ? 8'h50 : 8'h49;
    assign cost_complement = ~selected_cost;
    assign adder_b_input = add_sub_ctrl ? selected_cost : cost_complement;
    assign carry_in = add_sub_ctrl ? 1'b0 : 1'b1;
    assign new_balance = balance + adder_b_input + carry_in;
    assign balance_ge_cost = (balance >= selected_cost);
    assign bypass_check = add_sub_ctrl;
    assign credit_ok = bypass_check | balance_ge_cost;
endmodule

// Binary to BCD Converter
module binary_to_bcd_dataflow (
    input  wire [7:0] binary,
    output wire [3:0] tens, ones
);
    assign tens = binary / 10;
    assign ones = binary % 10;
endmodule

// BCD to 7-Segment Decoder
module bcd_to_7seg_dataflow (
    input  wire [3:0] bcd,
    output wire [6:0] segments
);
    assign segments = 
        (bcd == 4'd0) ? 7'b0111111 :
        (bcd == 4'd1) ? 7'b0000110 :
        (bcd == 4'd2) ? 7'b1011011 :
        (bcd == 4'd3) ? 7'b1001111 :
        (bcd == 4'd4) ? 7'b1100110 :
        (bcd == 4'd5) ? 7'b1101101 :
        (bcd == 4'd6) ? 7'b1111101 :
        (bcd == 4'd7) ? 7'b0000111 :
        (bcd == 4'd8) ? 7'b1111111 :
        (bcd == 4'd9) ? 7'b1101111 :
        7'b0000000;
endmodule