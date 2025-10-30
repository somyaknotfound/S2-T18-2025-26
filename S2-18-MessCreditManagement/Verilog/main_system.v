// ============================================================================
// File: main_system.v
// Description: Top-level system integration
// ============================================================================

module main_system (
    input  wire clk, rst_n, meal_request, user_select,
    input  wire [1:0] action_type,
    output wire [2:0] current_state,
    output wire [7:0] current_balance,
    output wire [6:0] tens_display, ones_display,
    output wire credit_ok
);

    wire timer_done;
    wire [7:0] state_outputs, new_balance;
    wire load_enable;
    
    // Load enable when in UPDATE state AND credit is OK
    assign load_enable = state_outputs[4] & credit_ok;
    
    // FSM Core instantiation
    fsm_core_behavioral fsm (
        .clk(clk), 
        .rst_n(rst_n),
        .meal_request(meal_request), 
        .user_select(user_select),
        .current_state(current_state), 
        .timer_done(timer_done),
        .state_outputs(state_outputs)
    );
    
    // ALU Unit instantiation
    alu_unit_dataflow alu (
        .balance(current_balance), 
        .action_type(action_type),
        .new_balance(new_balance), 
        .credit_ok(credit_ok)
    );
    
    // Credit Register instantiation
    credit_register_behavioral register (
        .clk(clk), 
        .rst_n(rst_n), 
        .load_enable(load_enable),
        .data_in(new_balance), 
        .data_out(current_balance)
    );
    
    // Display Driver instantiation
    display_driver_behavioral display (
        .balance(current_balance),
        .tens_display(tens_display), 
        .ones_display(ones_display)
    );
endmodule