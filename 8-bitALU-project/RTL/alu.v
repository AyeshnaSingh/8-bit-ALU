`timescale 1ns / 1ps

// 8-bit ALU
// Operations:
// 000 - ADD
// 001 - SUB
// 010 - AND
// 011 - OR
// 100 - XOR
// 101 - Shift Left
// 110 - Shift Right
// 111 - NOT A
//
// Flags:
// Zero     - Result is zero
// Carry    - Carry out for ADD, no-borrow convention for SUB
// Overflow - Signed arithmetic overflow

module alu(
    input [7:0] A,
    input [7:0] B,
    input [2:0] opcode,
    output reg [7:0] Result,
    output reg Zero_flag,
    output reg Carry_flag,
    output reg Overflow_flag
    );

    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND_OP = 3'b010;
    localparam OR_OP = 3'b011;
    localparam XOR_OP = 3'b100;
    localparam SHL = 3'b101;
    localparam SHR = 3'b110;
    localparam NOT_OP = 3'b111;

    reg [8:0] temp;

    
    always @(*) begin
    
        Result = 8'b0;
        Carry_flag = 1'b0;
        Overflow_flag = 1'b0;
        temp = 9'b0;
    
    case (opcode)

    ADD: begin
         temp = A + B;
         Result = temp[7:0];
         Carry_flag = temp[8];
         Overflow_flag = (~A[7] & ~B[7] & Result[7]) |
                (A[7] & B[7] & ~Result[7]);
    end

    SUB: begin
        temp = {1'b0, A} - {1'b0, B};
        Result = temp[7:0];
        Carry_flag = ~temp[8];
        Overflow_flag = (~A[7] & B[7] & Result[7]) |
                (A[7] & ~B[7] & ~Result[7]);
    end

    AND_OP: begin
        Result = A & B;
        Carry_flag = 1'b0;
        Overflow_flag = 1'b0;
    end

    OR_OP: begin
        Result = A | B;
        Carry_flag = 1'b0;
        Overflow_flag = 1'b0;
    end

    XOR_OP: begin
        Result = A ^ B;
        Carry_flag = 1'b0;
        Overflow_flag = 1'b0;
    end

    SHL: begin
        Result = A << 1;
        Carry_flag = A[7];
        Overflow_flag = 1'b0;
    end

    SHR: begin
        Result = A >> 1;
        Carry_flag = A[0];
        Overflow_flag = 1'b0;
    end

    NOT_OP: begin
        Result = ~A;
        Carry_flag = 1'b0;
        Overflow_flag = 1'b0;
    end
    

    endcase

    Zero_flag = (Result == 8'b0);
    end

endmodule
