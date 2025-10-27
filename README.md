# Intelligent Digital Credit Management System for University Mess/Canteen

<!-- First Section -->
## Team Details
<details>
  <summary>Detail</summary>

  > Semester: 3rd Sem B. Tech. CSE

  > Section: S2

  > Team ID: [Your Team ID]

  > Member-1: Shanthi Alluri, 241CS206, shanthi.alluri@example.com

  > Member-2: Deekshitha Gowda, 241CS224, deekshitha.gowda@example.com

  > Member-3: Somyak Priyadarshi Mohanta, 241CS257, somyak.mohanta@example.com
</details>

<!-- Second Section -->
## Abstract
<details>
  <summary>Detail</summary>
  
  <p><strong>1. Motivation:</strong> Traditional university mess and canteen systems rely on manual or basic digital billing, leading to long queues, credit disputes, and operational inefficiencies. This project addresses these challenges by implementing an automated, intelligent credit management system using digital circuit design principles. By applying our knowledge of Finite State Machines (FSM), Arithmetic Logic Units (ALU), and sequential logic circuits, we create a real-world solution that enhances both student experience and administrative efficiency.</p>

  <p><strong>2. Problem Statement:</strong> This project aims to design and implement a fully automated digital credit management system for university dining facilities using Logisim and Verilog HDL. The system must handle student authentication, flexible credit operations (deductions for meals and additions for refunds), real-time balance validation, and accurate transaction processing. The implementation utilizes only digital components—flip-flops, logic gates, multiplexers, comparators, and adders/subtractors—without relying on microcontrollers or software-based solutions.</p>

  <p><strong>3. Features:</strong></p>
  <ul>
    <li><strong>(a) 5-State FSM Controller:</strong> Implements IDLE, AUTH, RECOMMEND, TRANSACTION, and UPDATE states with minimized next-state logic derived from Karnaugh maps.</li>
    <li><strong>(b) Action-Type Based ALU:</strong> Supports three transaction modes using 2-bit encoding: Ate Mess (00), Skipped Mess (01), and Ate Canteen (10) with configurable add/subtract operations.</li>
    <li><strong>(c) Real-Time Credit Validation:</strong> 8-bit comparator validates sufficient balance for deductions while bypassing checks for refund operations.</li>
    <li><strong>(d) Timer-Based Authentication:</strong> Counter-comparator unit enforces configurable authentication delays to prevent unauthorized access.</li>
    <li><strong>(e) BCD Display Driver:</strong> Converts 8-bit binary balance to dual-digit 7-segment display format for real-time visual feedback.</li>
    <li><strong>(f) Synchronous Design:</strong> All modules operate on a central clock ensuring race-free, atomic transactions.</li>
  </ul>
</details>

<!-- Third Section -->
## Functional Block Diagram
<details>
  <summary>Detail</summary>
  
  <h3>Main System Architecture</h3>
  <img src="Snapshots/Diagrams/block_diagram.png" alt="System Block Diagram">
  
  <h3>Detailed Component Interaction</h3>
  <p>The system integrates five principal components:</p>
  <ul>
    <li><strong>FSM Core:</strong> Central controller managing state transitions and generating control signals</li>
    <li><strong>Credit Register:</strong> 8-bit register storing current student balance</li>
    <li><strong>ALU Unit:</strong> Performs arithmetic operations (add/subtract) based on action type</li>
    <li><strong>Display Driver:</strong> Converts balance to BCD for 7-segment displays</li>
    <li><strong>ROM:</strong> Stores predefined meal costs (Mess: 0x49, Canteen: 0x50)</li>
  </ul>
  
</details>

<!-- Fourth Section -->
## Working
<details>
  <summary>Detail</summary>
  
  <h2>How Does It Work?</h2>
  
  <h3>System Initialization</h3>
  <p>The system begins in the IDLE state with a default balance loaded into the Credit Register (typically 255 credits). The 7-segment displays show the current balance in decimal format through the BCD Display Driver.</p>
  
  <h3>Transaction Flow</h3>
  <ol>
    <li><strong>Meal Request (IDLE → AUTH):</strong> Student initiates transaction by asserting the Meal Request signal (M=1), triggering transition to AUTH state.</li>
    
    <li><strong>Authentication (AUTH → RECOMMEND):</strong> The system enforces a timer-based delay (10 clock cycles) using a counter-comparator unit. This prevents rapid unauthorized access attempts. Upon timer completion (TD=1), the system transitions to RECOMMEND state.</li>
    
    <li><strong>Meal Selection (RECOMMEND → TRANSACTION):</strong> Available meal options are presented with costs (Mess: 73 credits, Canteen: 80 credits). Student selects meal type and action using a 2-bit control:
      <ul>
        <li><strong>00:</strong> Ate Mess - Deduct 73 credits</li>
        <li><strong>01:</strong> Skipped Mess - Add 73 credits (refund)</li>
        <li><strong>10:</strong> Ate Canteen - Deduct 80 credits</li>
      </ul>
      User selection (U=1) triggers transition to TRANSACTION state.
    </li>
    
    <li><strong>Credit Validation (TRANSACTION):</strong> The ALU performs parallel operations:
      <ul>
        <li>Cost selection via 2:1 MUX based on Action[1]</li>
        <li>Balance comparison for deduction operations</li>
        <li>Calculation of new balance using configurable adder/subtractor</li>
      </ul>
      For deductions: Transaction proceeds only if BALANCE ≥ COST.<br>
      For refunds: Credit check is bypassed; transaction always approved.
    </li>
    
    <li><strong>Balance Update (TRANSACTION → UPDATE → IDLE):</strong> If transaction is approved (CREDIT_OK=1), the system transitions to UPDATE state where:
      <ul>
        <li>New balance is written to Credit Register</li>
        <li>Display Driver updates 7-segment outputs</li>
        <li>System returns to IDLE state for next transaction</li>
      </ul>
      If transaction is denied (insufficient balance), system returns directly to IDLE without balance modification.
    </li>
  </ol>
  
  <h3>Action Type Processing</h3>
  <p>The ALU decodes the 2-bit action type to control three key operations:</p>
  <ul>
    <li><strong>Action[1]:</strong> Selects cost (0=Mess/0x49, 1=Canteen/0x50)</li>
    <li><strong>Action[0]:</strong> Determines operation (0=Subtract, 1=Add)</li>
    <li><strong>Combined Logic:</strong> Enables flexible credit management supporting both meal consumption and skip refunds</li>
  </ul>
  
  <h2>Flowchart</h2>
  <img src="design/IMAGE/image.png" alt="System Flowchart">
  
  <h2>Functional State Table</h2>
  
  | Current State | M | U | TD | Next State | Action | Balance Change |
  |---------------|---|---|----|-----------|---------|--------------------|
  | IDLE (000) | 0 | X | X | IDLE (000) | Wait | No change |
  | IDLE (000) | 1 | X | X | AUTH (001) | Start auth | No change |
  | AUTH (001) | X | X | 0 | AUTH (001) | Wait timer | No change |
  | AUTH (001) | X | X | 1 | RECOMMEND (010) | Show options | No change |
  | RECOMMEND (010) | X | 0 | X | RECOMMEND (010) | Wait select | No change |
  | RECOMMEND (010) | X | 1 | X | TRANSACTION (011) | Validate | No change |
  | TRANSACTION (011) | X | X | 0 | TRANSACTION (011) | Process | No change |
  | TRANSACTION (011) | X | X | 1 | UPDATE (100) | Update balance | Apply ±Cost |
  | UPDATE (100) | X | X | X | IDLE (000) | Complete | Display new balance |
  
  <h2>Transaction Examples</h2>
  
  | Initial Balance | Action Type | Operation | Cost | Final Balance | Credit OK |
  |----------------|-------------|-----------|------|---------------|-----------|
  | 100 | 00 (Ate Mess) | Subtract | 73 | 27 | ✓ |
  | 100 | 01 (Skipped Mess) | Add | 73 | 173 | ✓ |
  | 100 | 10 (Ate Canteen) | Subtract | 80 | 20 | ✓ |
  | 50 | 00 (Ate Mess) | Subtract | 73 | 50 (unchanged) | ✗ |
  | 50 | 01 (Skipped Mess) | Add | 73 | 123 | ✓ |
  | 73 | 00 (Ate Mess) | Subtract | 73 | 0 | ✓ |
  
</details>

<!-- Fifth Section -->
## Logisim Circuit Diagram
<details>
  <summary>Detail</summary>

  <h3>Main Module</h3>
  <img src="design/IMAGE/main_circuit.png" alt="Main Module Circuit">
  <p>Integrates FSM Core, ALU Unit, Credit Register, ROM, and Display Driver with clock and reset distribution.</p>

  <h3>FSM Core</h3>
  <img src="design/IMAGE/FSM_circuit.png" alt="FSM Core Circuit">
  <p>Implements 5-state controller with state register, next-state logic, state decoder, and authentication timer.</p>

  <h3>Next State Logic</h3>
  <img src="design/IMAGE/Next_state_logic.png" alt="Next State Logic">
  <p>Combinatorial circuit implementing minimized Boolean expressions derived from Karnaugh maps.</p>

  <h3>ALU Unit</h3>
  <img src="design/IMAGE/ALU_circuit.png" alt="ALU Circuit">
  <p>Contains action type decoder, cost selector MUX, configurable adder/subtractor, and 8-bit comparator.</p>

  <h3>Display Driver</h3>
  <img src="design/IMAGE/Display_driver.png" alt="Display Driver Circuit">
  <p>Binary-to-BCD converter with dual 4-to-7 segment decoders for real-time balance display.</p>
  
</details>

<!-- Sixth Section -->
## Verilog Code
<details>
  <summary>Detail</summary>

  ### Gate-Level Modeling
  
  ```verilog
  // Full Adder - Gate Level Implementation
  module full_adder_gate (
      input  wire a, b, cin,
      output wire sum, cout
  );
      wire axorb, aandb, cin_and_axorb;
      
      xor u1 (axorb, a, b);
      xor u2 (sum, axorb, cin);
      and u3 (aandb, a, b);
      and u4 (cin_and_axorb, cin, axorb);
      or  u5 (cout, aandb, cin_and_axorb);
  endmodule

  // 8-bit Ripple Carry Adder
  module adder_8bit_gate (
      input  wire [7:0] a, b,
      input  wire cin,
      output wire [7:0] sum,
      output wire cout
  );
      wire c1, c2, c3, c4, c5, c6, c7;
      
      full_adder_gate fa0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c1));
      full_adder_gate fa1 (.a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]), .cout(c2));
      full_adder_gate fa2 (.a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]), .cout(c3));
      full_adder_gate fa3 (.a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]), .cout(c4));
      full_adder_gate fa4 (.a(a[4]), .b(b[4]), .cin(c4), .sum(sum[4]), .cout(c5));
      full_adder_gate fa5 (.a(a[5]), .b(b[5]), .cin(c5), .sum(sum[5]), .cout(c6));
      full_adder_gate fa6 (.a(a[6]), .b(b[6]), .cin(c6), .sum(sum[6]), .cout(c7));
      full_adder_gate fa7 (.a(a[7]), .b(b[7]), .cin(c7), .sum(sum[7]), .cout(cout));
  endmodule
  ```

  ### Dataflow Modeling

  ```verilog
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
  ```

  ### Behavioral Modeling

  ```verilog
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
              IDLE: next_state = meal_request ? AUTH : IDLE;
              AUTH: next_state = timer_done ? RECOMMEND : AUTH;
              RECOMMEND: next_state = user_select ? TRANSACTION : RECOMMEND;
              TRANSACTION: next_state = timer_done ? UPDATE : TRANSACTION;
              UPDATE: next_state = IDLE;
              default: next_state = IDLE;
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
  ```

  ### Test Bench

  ```verilog
  `timescale 1ns/1ps

  module main_system_tb;
      reg clk, rst_n, meal_request, user_select;
      reg [1:0] action_type;
      wire [2:0] current_state;
      wire [7:0] current_balance;
      wire [6:0] tens_display, ones_display;
      wire credit_ok;
      
      main_system_behavioral uut (
          .clk(clk), .rst_n(rst_n), .meal_request(meal_request),
          .user_select(user_select), .action_type(action_type),
          .current_state(current_state), .current_balance(current_balance),
          .tens_display(tens_display), .ones_display(ones_display),
          .credit_ok(credit_ok)
      );
      
      initial begin
          clk = 0;
          forever #5 clk = ~clk;
      end
      
      initial begin
          $display("Starting Complete System Test\n");
          rst_n = 0; meal_request = 0; user_select = 0; action_type = 2'b00;
          #15 rst_n = 1;
          $display("Initial Balance: %d\n", current_balance);
          
          // Test Case 1: Ate Mess
          #20 meal_request = 1; action_type = 2'b00;
          #10 meal_request = 0;
          #120 user_select = 1;
          #10 user_select = 0;
          #150 $display("After Ate Mess - Balance: %d\n", current_balance);
          
          // Test Case 2: Skipped Mess
          #20 meal_request = 1; action_type = 2'b01;
          #10 meal_request = 0;
          #120 user_select = 1;
          #10 user_select = 0;
          #150 $display("After Skipped Mess - Balance: %d\n", current_balance);
          
          #100 $finish;
      end
      
      initial begin
          $dumpfile("main_system_tb.vcd");
          $dumpvars(0, main_system_tb);
      end
  endmodule
  ```

  ### Simulation Output
  
  <img src="Snapshots/Simulations/simulation_output.png" alt="Verilog Simulation Output">
  
  <h3>Complete Verilog Files</h3>
  <p>All Verilog implementations (gate-level, dataflow, behavioral) and testbenches are available in the <code>/Verilog</code> directory.</p>
  
</details>

## References
<details>
  <summary>Detail</summary>
  
  1. Harris, D. M., & Harris, S. L. (2012). *Digital Design and Computer Architecture*. Morgan Kaufmann.
  2. Patterson, D. A., & Hennessy, J. L. (2017). *Computer Organization and Design*. Morgan Kaufmann.
  3. Smith, J. (2020). "Arithmetic Logic Unit Design for Educational Processors." *Journal of Computing Sciences in Colleges*.
  4. Brown, S. & Vranesic, Z. (2021). *Fundamentals of Digital Logic with Verilog Design*. McGraw-Hill.
  5. Logisim Evolution Documentation: http://github.com/logisim-evolution/logisim-evolution
  6. Verilog HDL Quick Reference Guide: https://www.verilog.com
   
</details>
