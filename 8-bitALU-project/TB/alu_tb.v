`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2026 12:22:39
// Design Name: 
// Module Name: alu_tb
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


module alu_tb;
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] opcode;
    
    wire [7:0] Result;
    wire Zero_flag;
    wire Carry_flag;
    wire Overflow_flag;
    
    integer passed;
    integer failed;
    
    
    alu uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .Result(Result),
        .Zero_flag(Zero_flag),
        .Carry_flag(Carry_flag),
        .Overflow_flag(Overflow_flag)
    );
    
    task check_result;
    input [7:0] exp_result;
    input exp_zero;
    input exp_carry;
    input exp_overflow;

    begin
        if ((Result === exp_result) &&
            (Zero_flag === exp_zero) &&
            (Carry_flag === exp_carry) &&
            (Overflow_flag === exp_overflow)) begin

            $display("PASS");
            passed = passed + 1;

        end
        else begin

            $display("FAIL");
            $display("Expected: Result=%d Zero=%b Carry=%b Overflow=%b",
                     exp_result, exp_zero, exp_carry, exp_overflow);
            $display("Actual:   Result=%d Zero=%b Carry=%b Overflow=%b",
                     Result, Zero_flag, Carry_flag, Overflow_flag);

            failed = failed + 1;
        end
    end
endtask

    initial begin
    
    passed = 0;
    failed = 0;

    // Test 1: 5 + 3 = 8
    A = 8'd5;
    B = 8'd3;
    opcode = 3'b000;
    #10;

    check_result(8'd8, 1'b0, 1'b0, 1'b0);


    // Test 2: 255 + 1 = 0 with carry
A = 8'd255;
B = 8'd1;
opcode = 3'b000;
#10;

check_result(8'd0, 1'b1, 1'b1, 1'b0);

    // Test 3: 127 + 1 = signed overflow
A = 8'd127;
B = 8'd1;
opcode = 3'b000;
#10;

check_result(8'd128, 1'b0, 1'b0, 1'b1);

// Test 4: AND
A = 8'b10101010;
B = 8'b11001100;
opcode = 3'b010;
#10;
check_result(8'b10001000, 1'b0, 1'b0, 1'b0);

// Test 5: OR
A = 8'b10101010;
B = 8'b11001100;
opcode = 3'b011;
#10;
check_result(8'b11101110, 1'b0, 1'b0, 1'b0);

// Test 6: XOR
A = 8'b10101010;
B = 8'b11001100;
opcode = 3'b100;
#10;
check_result(8'b01100110, 1'b0, 1'b0, 1'b0);

// Test 7: Shift Left
A = 8'b10000001;
B = 8'b00000000;
opcode = 3'b101;
#10;
check_result(8'b00000010, 1'b0, 1'b1, 1'b0);

// Test 8: Shift Right
A = 8'b10000001;
B = 8'b00000000;
opcode = 3'b110;
#10;
check_result(8'b01000000, 1'b0, 1'b1, 1'b0);

// Test 9: NOT 
A = 8'b10101010; 
B = 8'b00000000; 
opcode = 3'b111; 
#10; 
check_result(8'b01010101, 1'b0, 1'b0, 1'b0);

// Test 10: SUB - normal
A = 8'd10;
B = 8'd3;
opcode = 3'b001;
#10;
check_result(8'd7, 1'b0, 1'b1, 1'b0);

// Test 11: SUB - result is zero
A = 8'd5;
B = 8'd5;
opcode = 3'b001;
#10;
check_result(8'd0, 1'b1, 1'b1, 1'b0);

// Test 12: SUB - borrow
A = 8'd3;
B = 8'd5;
opcode = 3'b001;
#10;
check_result(8'd254, 1'b0, 1'b0, 1'b0);

// Test 13: SUB - signed overflow
A = 8'd127;
B = 8'd255;
opcode = 3'b001;
#10;
check_result(8'd128, 1'b0, 1'b0, 1'b1);


// Test 14: ADD produces zero
A = 8'd0;
B = 8'd0;
opcode = 3'b000;
#10;
check_result(8'd0, 1'b1, 1'b0, 1'b0);

// Test 15: ADD maximum values
A = 8'd255;
B = 8'd255;
opcode = 3'b000;
#10;
check_result(8'd254, 1'b0, 1'b1, 1'b0);

// Test 16: Shift left with zero
A = 8'b00000000;
B = 8'b00000000;
opcode = 3'b101;
#10;
check_result(8'b00000000, 1'b1, 1'b0, 1'b0);

// Test 17: Shift right with zero
A = 8'b00000000;
B = 8'b00000000;
opcode = 3'b110;
#10;
check_result(8'b00000000, 1'b1, 1'b0, 1'b0);

// Test 18: NOT zero
A = 8'b00000000;
B = 8'b00000000;
opcode = 3'b111;
#10;
check_result(8'b11111111, 1'b0, 1'b0, 1'b0);


$display("--------------------------------");
$display("Total Passed: %d", passed);
$display("Total Failed: %d", failed);
$display("--------------------------------");

$finish;

end

endmodule



