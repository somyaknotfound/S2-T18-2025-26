// ============================================================================
// File: behavioral.v
// Description: Behavioral modules (FSM, Register, Display Driver)
// ============================================================================

// FSM Core - Behavioral Implementation
module fsm_core_behavioral (
    input  wire clk, rst_n, meal_request, user_select,
    output reg  [2:0] current_state,
    output reg  timer_done,
    output reg  [7:0] state_outputs
);
    localparam [2:0] IDLE = 3'b000, AUTH = 3'b001, 
                     RECOMMEND = 3'b010, TRANSACTION = 3'b011, UPDATE = 3'b100;
    
    reg [2:0] next_state;
    reg [3:0] auth_counter;
    localparam [3:0] AUTH_THRESHOLD = 4'd10;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            auth_counter  <= 4'd0;
        end else begin
            current_state <= next_state;
            if (current_state == AUTH || current_state == TRANSACTION) begin
                if (auth_counter < AUTH_THRESHOLD)
                    auth_counter <= auth_counter + 1'b1;
            end else
                auth_counter <= 4'd0;
        end
    end
    
    always @(*) begin
        next_state = current_state;
        timer_done = (auth_counter >= AUTH_THRESHOLD);
        case (current_state)
            IDLE:        next_state = meal_request ? AUTH : IDLE;
            AUTH:        next_state = timer_done ? RECOMMEND : AUTH;
            RECOMMEND:   next_state = user_select ? TRANSACTION : RECOMMEND;
            TRANSACTION: next_state = timer_done ? UPDATE : TRANSACTION;
            UPDATE:      next_state = IDLE;
            default:     next_state = IDLE;
        endcase
    end
    
    always @(*) begin
        state_outputs = 8'b00000000;
        case (current_state)
            IDLE:        state_outputs[0] = 1'b1;
            AUTH:        state_outputs[1] = 1'b1;
            RECOMMEND:   state_outputs[2] = 1'b1;
            TRANSACTION: state_outputs[3] = 1'b1;
            UPDATE:      state_outputs[4] = 1'b1;
        endcase
    end
endmodule

// Credit Register - Behavioral
module credit_register_behavioral (
    input  wire clk, rst_n, load_enable,
    input  wire [7:0] data_in,
    output reg  [7:0] data_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_out <= 8'hFF;  // Default: 255 credits
        else if (load_enable)
            data_out <= data_in;
    end
endmodule

// Display Driver - Behavioral
module display_driver_behavioral (
    input  wire [7:0] balance,
    output wire [6:0] tens_display, ones_display
);
    wire [3:0] tens_bcd, ones_bcd;
    
    binary_to_bcd_dataflow bcd_conv (
        .binary(balance), 
        .tens(tens_bcd), 
        .ones(ones_bcd)
    );
    
    bcd_to_7seg_dataflow tens_decoder (
        .bcd(tens_bcd), 
        .segments(tens_display)
    );
    
    bcd_to_7seg_dataflow ones_decoder (
        .bcd(ones_bcd), 
        .segments(ones_display)
    );
endmodule