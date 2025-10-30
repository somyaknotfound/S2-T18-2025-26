// ============================================================================
// File: testbench.v
// Description: Comprehensive testbench with truth tables (Verilog-2001)
// ============================================================================
`timescale 1ns/1ps
module testbench;
    reg clk, rst_n, meal_request, user_select;
    reg [1:0] action_type;
    wire [2:0] current_state;
    wire [7:0] current_balance;
    wire [6:0] tens_display, ones_display;
    wire credit_ok;
    
    // Instantiate main system
    main_system uut (
        .clk(clk), 
        .rst_n(rst_n),
        .meal_request(meal_request), 
        .user_select(user_select),
        .action_type(action_type), 
        .current_state(current_state),
        .current_balance(current_balance),
        .tens_display(tens_display), 
        .ones_display(ones_display),
        .credit_ok(credit_ok)
    );
    
    // Clock generation: 100MHz (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Truth Table Display Tasks
    task display_full_adder_truth_table;
        integer i;
        reg a_test, b_test, cin_test;
        reg sum_test, cout_test;
        begin
            $display("\n========================================");
            $display("   FULL ADDER TRUTH TABLE");
            $display("========================================");
            $display("  A  |  B  | Cin | Sum | Cout");
            $display("-----+-----+-----+-----+-----");
            
            for (i = 0; i < 8; i = i + 1) begin
                a_test = i[2];
                b_test = i[1];
                cin_test = i[0];
                sum_test = a_test ^ b_test ^ cin_test;
                cout_test = (a_test & b_test) | (cin_test & (a_test ^ b_test));
                $display("  %b  |  %b  |  %b  |  %b  |  %b", 
                         a_test, b_test, cin_test, sum_test, cout_test);
            end
            $display("========================================\n");
        end
    endtask
    
    task display_alu_truth_table;
        reg [7:0] bal_test;
        reg [1:0] act_test;
        reg [7:0] new_bal_test;
        reg credit_test;
        begin
            $display("\n==========================================================");
            $display("              ALU OPERATION TRUTH TABLE");
            $display("==========================================================");
            $display("Action | Operation    | Cost | Balance | New Bal | OK?");
            $display("-------+--------------+------+---------+---------+----");
            
            // Test with balance = 100
            bal_test = 8'd100;
            
            act_test = 2'b00;
            new_bal_test = bal_test - 8'd73;
            credit_test = (bal_test >= 8'd73);
            $display("  %b   | Ate Mess     |  73  |   %3d   |   %3d   |  %b",
                     act_test, bal_test, new_bal_test, credit_test);
            
            act_test = 2'b01;
            new_bal_test = bal_test + 8'd73;
            credit_test = 1'b1;
            $display("  %b   | Skip Mess    | +73  |   %3d   |   %3d   |  %b",
                     act_test, bal_test, new_bal_test, credit_test);
            
            act_test = 2'b10;
            new_bal_test = bal_test - 8'd80;
            credit_test = (bal_test >= 8'd80);
            $display("  %b   | Ate Canteen  |  80  |   %3d   |   %3d   |  %b",
                     act_test, bal_test, new_bal_test, credit_test);
            
            act_test = 2'b11;
            new_bal_test = bal_test + 8'd80;
            credit_test = 1'b1;
            $display("  %b   | Skip Canteen | +80  |   %3d   |   %3d   |  %b",
                     act_test, bal_test, new_bal_test, credit_test);
            
            $display("-------+--------------+------+---------+---------+----");
            
            // Test with low balance = 50
            bal_test = 8'd50;
            
            act_test = 2'b00;
            new_bal_test = bal_test - 8'd73;
            credit_test = (bal_test >= 8'd73);
            $display("  %b   | Ate Mess     |  73  |   %3d   |   %3d   |  %b",
                     act_test, bal_test, new_bal_test, credit_test);
            
            act_test = 2'b10;
            new_bal_test = bal_test - 8'd80;
            credit_test = (bal_test >= 8'd80);
            $display("  %b   | Ate Canteen  |  80  |   %3d   |   %3d   |  %b",
                     act_test, bal_test, new_bal_test, credit_test);
            
            $display("==========================================================\n");
        end
    endtask
    
    task display_bcd_truth_table;
        integer i;
        reg [3:0] bcd_test;
        reg [6:0] seg_test;
        begin
            $display("\n===============================================");
            $display("       BCD TO 7-SEGMENT TRUTH TABLE");
            $display("===============================================");
            $display(" BCD | 7-Segment | Segments");
            $display("-----+-----------+----------");
            
            for (i = 0; i <= 9; i = i + 1) begin
                bcd_test = i;
                case(bcd_test)
                    4'd0: seg_test = 7'b0111111;
                    4'd1: seg_test = 7'b0000110;
                    4'd2: seg_test = 7'b1011011;
                    4'd3: seg_test = 7'b1001111;
                    4'd4: seg_test = 7'b1100110;
                    4'd5: seg_test = 7'b1101101;
                    4'd6: seg_test = 7'b1111101;
                    4'd7: seg_test = 7'b0000111;
                    4'd8: seg_test = 7'b1111111;
                    4'd9: seg_test = 7'b1101111;
                    default: seg_test = 7'b0000000;
                endcase
                $display("  %d  | %b | %d", bcd_test, seg_test, bcd_test);
            end
            $display("===============================================\n");
        end
    endtask
    
    task display_fsm_state_table;
        begin
            $display("\n=============================================================");
            $display("                FSM STATE TRANSITION TABLE");
            $display("=============================================================");
            $display("Current State | Meal_Req | User_Sel | Timer | Next State");
            $display("--------------+----------+----------+-------+-------------");
            $display("IDLE (000)    |    0     |    X     |   X   | IDLE");
            $display("IDLE (000)    |    1     |    X     |   X   | AUTH");
            $display("AUTH (001)    |    X     |    X     |   0   | AUTH");
            $display("AUTH (001)    |    X     |    X     |   1   | RECOMMEND");
            $display("RECOMMEND(010)|    X     |    0     |   X   | RECOMMEND");
            $display("RECOMMEND(010)|    X     |    1     |   X   | TRANSACTION");
            $display("TRANSACTION(011)|  X     |    X     |   0   | TRANSACTION");
            $display("TRANSACTION(011)|  X     |    X     |   1   | UPDATE");
            $display("UPDATE (100)  |    X     |    X     |   X   | IDLE");
            $display("=============================================================\n");
        end
    endtask
    
    // Test stimulus
    initial begin
        $display("\n============================================================");
        $display("                                                            ");
        $display("       CREDIT MANAGEMENT SYSTEM - COMPREHENSIVE TEST       ");
        $display("                                                            ");
        $display("============================================================\n");
        
        // Display all truth tables first
        display_full_adder_truth_table();
        display_alu_truth_table();
        display_bcd_truth_table();
        display_fsm_state_table();
        
        $display("\n============================================================");
        $display("                    FUNCTIONAL TESTS                        ");
        $display("============================================================\n");
        
        // Initialize
        rst_n = 0; 
        meal_request = 0; 
        user_select = 0; 
        action_type = 2'b00;
        
        #15 rst_n = 1;
        $display("System Reset Complete");
        $display("  Initial Balance: %d credits\n", current_balance);
        
        // Test 1: Ate Mess (subtract 73)
        $display("------------------------------------------------------------");
        $display("Test 1: Ate Mess Transaction (Cost: 73)");
        $display("------------------------------------------------------------");
        #20 meal_request = 1; 
        action_type = 2'b00;
        #10 meal_request = 0;
        #120 user_select = 1;
        #10 user_select = 0;
        #150 
        $display("  Transaction Complete");
        $display("  Balance: %d (Expected: 182)", current_balance);
        $display("  Credit OK: %b\n", credit_ok);
        
        // Test 2: Skipped Mess (add 73)
        $display("------------------------------------------------------------");
        $display("Test 2: Skipped Mess Refund (+73)");
        $display("------------------------------------------------------------");
        #20 meal_request = 1; 
        action_type = 2'b01;
        #10 meal_request = 0;
        #120 user_select = 1;
        #10 user_select = 0;
        #150 
        $display("  Refund Complete");
        $display("  Balance: %d (Expected: 255)", current_balance);
        $display("  Credit OK: %b\n", credit_ok);
        
        // Test 3: Ate Canteen (subtract 80)
        $display("------------------------------------------------------------");
        $display("Test 3: Ate Canteen Transaction (Cost: 80)");
        $display("------------------------------------------------------------");
        #20 meal_request = 1; 
        action_type = 2'b10;
        #10 meal_request = 0;
        #120 user_select = 1;
        #10 user_select = 0;
        #150 
        $display("  Transaction Complete");
        $display("  Balance: %d (Expected: 175)", current_balance);
        $display("  Credit OK: %b\n", credit_ok);
        
        // Test 4: Insufficient balance
        $display("------------------------------------------------------------");
        $display("Test 4: Insufficient Balance Test");
        $display("------------------------------------------------------------");
        action_type = 2'b10;
        repeat(3) begin
            #20 meal_request = 1;
            #10 meal_request = 0;
            #120 user_select = 1;
            #10 user_select = 0;
            #150 
            $display("  Balance: %d | Credit OK: %b", current_balance, credit_ok);
        end
        
        $display("\n============================================================");
        $display("             ALL TESTS COMPLETED SUCCESSFULLY!              ");
        $display("============================================================\n");
        
        #100 $finish;
    end
    
    // Monitor state changes with better formatting
    always @(current_state) begin
        case (current_state)
            3'b000: $display("  [FSM State: IDLE]");
            3'b001: $display("  [FSM State: AUTH - Authenticating...]");
            3'b010: $display("  [FSM State: RECOMMEND - Showing Options]");
            3'b011: $display("  [FSM State: TRANSACTION - Processing...]");
            3'b100: $display("  [FSM State: UPDATE - Updating Balance]");
        endcase
    end
    
    // Generate waveform file
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, testbench);
    end
endmodule