// ============================================================================
// File: gate_level.v
// Description: Gate-level modules (Full Adder and 8-bit Adder)
// ============================================================================

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